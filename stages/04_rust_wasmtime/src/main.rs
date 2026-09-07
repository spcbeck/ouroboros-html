use anyhow::{Context, Result};
use std::fs;
use std::path::Path;
use wasmtime::*;
use wasmtime_wasi::preview1::{self, WasiP1Ctx};
use wasmtime_wasi::WasiCtxBuilder;

fn main() -> Result<()> {
    let wasm_file = Path::new("stage3.wasm");
    if !wasm_file.exists() {
        anyhow::bail!("Wasm bytecode stage3.wasm does not exist");
    }

    println!("[Stage 4] Initializing Wasmtime engine...");
    let engine = Engine::default();
    let module = Module::from_file(&engine, wasm_file)
        .context("Failed to load and compile WebAssembly module")?;

    let mut linker: Linker<WasiP1Ctx> = Linker::new(&engine);
    preview1::add_to_linker_sync(&mut linker, |ctx| ctx)?;

    let wasi_ctx = WasiCtxBuilder::new()
        .inherit_stdio()
        .build_p1();

    let mut store = Store::new(&engine, wasi_ctx);
    let instance = linker
        .instantiate(&mut store, &module)
        .context("Failed to instantiate WebAssembly module")?;

    // Call get_payload exported function and read directly from WebAssembly linear memory
    let get_payload = instance
        .get_typed_func::<(), i32>(&mut store, "get_payload")
        .context("Missing 'get_payload' export in WebAssembly module")?;

    let ptr = get_payload
        .call(&mut store, ())
        .context("Call to get_payload failed")? as usize;

    let memory = instance
        .get_memory(&mut store, "memory")
        .context("WebAssembly instance does not export 'memory'")?;

    let mem_data = memory.data(&store);
    if ptr >= mem_data.len() {
        anyhow::bail!("get_payload pointer {} out of bounds ({})", ptr, mem_data.len());
    }

    let end = mem_data[ptr..]
        .iter()
        .position(|&b| b == 0)
        .context("Unterminated C-string in WebAssembly memory")?;

    let payload = std::str::from_utf8(&mem_data[ptr..ptr + end])
        .context("WebAssembly payload is not valid UTF-8")?;

    println!("[Stage 4] Successfully executed WebAssembly and extracted payload:\n{}", payload);

    fs::write("output.txt", format!("{}\n", payload))
        .context("Failed to write output.txt")?;

    Ok(())
}
