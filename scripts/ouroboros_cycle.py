#!/usr/bin/env python3
"""
ouroboros_cycle.py - Multi-Generation Ouroboros Engine

Executes recursive generational cycles where the final HTML5 output of Stage 18
is fed back into Stage 0 as the new input, executing the full 20-stage pipeline
for N generations to prove mathematical idempotency.
"""

import argparse
import os
import shutil
import subprocess
import sys
import time

# Bauhaus ANSI Palette
RESET = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"
RED = "\033[1;31m"
YELLOW = "\033[1;33m"
BLUE = "\033[1;34m"
GREEN = "\033[1;32m"
WHITE = "\033[1;37m"
CYAN = "\033[1;36m"


def print_banner(cycles: int):
    print(f"\n{BOLD}{WHITE}╔══════════════════════════════════════════════════════════════════════════╗{RESET}")
    print(f"{BOLD}{WHITE}║{RESET}  {BOLD}{RED}●{RESET} {BOLD}{YELLOW}▲{RESET} {BOLD}{BLUE}■{RESET}  {BOLD}{WHITE}OUROBOROS-HTML :: MULTI-GENERATION IDEMPOTENCY ENGINE{RESET}       {BOLD}{WHITE}║{RESET}")
    print(f"{BOLD}{WHITE}╠══════════════════════════════════════════════════════════════════════════╣{RESET}")
    print(f"{BOLD}{WHITE}║{RESET}  Target Generations: {BOLD}{YELLOW}{cycles}{RESET}                                                {BOLD}{WHITE}║{RESET}")
    print(f"{BOLD}{WHITE}║{RESET}  Rule: Output[k-1] --> Input[k] across 20 compiler stages               {BOLD}{WHITE}║{RESET}")
    print(f"{BOLD}{WHITE}╚══════════════════════════════════════════════════════════════════════════╝{RESET}\n")


def print_generation_header(gen: int, total: int):
    print(f"{BOLD}{BLUE}┌──────────────────────────────────────────────────────────────────────────┐{RESET}")
    print(f"{BOLD}{BLUE}│{RESET}  {BOLD}{WHITE}GENERATION {gen:02d} / {total:02d}{RESET}  {DIM}--> Initiating full 20-stage compilation cycle{RESET}      {BOLD}{BLUE}│{RESET}")
    print(f"{BOLD}{BLUE}└──────────────────────────────────────────────────────────────────────────┘{RESET}")


def run_command(cmd: list[str]) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)


def main():
    parser = argparse.ArgumentParser(description="Multi-Generation Ouroboros Runner")
    parser.add_argument("--cycles", type=int, default=3, help="Number of recursive compiler cycles")
    args = parser.parse_args()

    cycles = args.cycles
    print_banner(cycles)

    root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    input_file = os.path.join(root_dir, "stages", "00_input", "input.html")
    output_file = os.path.join(root_dir, "stages", "18_posthtml_minify", "output.html")
    verify_script = os.path.join(root_dir, "scripts", "verify_dom.js")
    artifacts_dir = os.path.join(root_dir, "artifacts")

    if not os.path.exists(input_file):
        print(f"{RED}Error: Initial input file not found: {input_file}{RESET}")
        sys.exit(1)

    # Backup original canonical input as Gen 0 reference
    with open(input_file, "r", encoding="utf-8") as f:
        gen0_payload = f.read()

    os.makedirs(artifacts_dir, exist_ok=True)
    gen0_artifact = os.path.join(artifacts_dir, "gen_00_reference.html")
    with open(gen0_artifact, "w", encoding="utf-8") as f:
        f.write(gen0_payload)

    print(f"{DIM}[Gen 00 Reference]{RESET} Canonical payload cached ({len(gen0_payload)} bytes):")
    print(f"  {CYAN}{gen0_payload.strip()}{RESET}\n")

    generation_metrics = []

    try:
        for k in range(1, cycles + 1):
            print_generation_header(k, cycles)
            start_time = time.time()

            # Clean workspace
            clean_res = run_command(["make", "clean"])
            if clean_res.returncode != 0:
                print(f"{RED}[Gen {k:02d} Clean Failed]{RESET}\n{clean_res.stderr}")
                sys.exit(1)

            # Run full pipeline
            make_res = run_command(["make", "all"])
            elapsed = time.time() - start_time

            if make_res.returncode != 0:
                print(f"{RED}[Gen {k:02d} Build Failed with Code {make_res.returncode}]{RESET}")
                print(make_res.stdout)
                print(make_res.stderr)
                sys.exit(1)

            if not os.path.exists(output_file):
                print(f"{RED}[Gen {k:02d} Error] Stage 14 output.html missing!{RESET}")
                sys.exit(1)

            with open(output_file, "r", encoding="utf-8") as f:
                current_output = f.read()

            # Store generational snapshot
            gen_snapshot = os.path.join(artifacts_dir, f"gen_{k:02d}_output.html")
            with open(gen_snapshot, "w", encoding="utf-8") as f:
                f.write(current_output)

            # Assert deep DOM equivalence against Gen 0
            verify_res = run_command(["node", verify_script, gen0_artifact, gen_snapshot])
            if verify_res.returncode != 0:
                print(f"{RED}[Gen {k:02d} DOM Equivalence Failed!]{RESET}")
                print(verify_res.stderr)
                sys.exit(1)

            generation_metrics.append({
                "gen": k,
                "duration": elapsed,
                "bytes": len(current_output),
                "payload": current_output.strip()
            })

            print(f"{GREEN}✔ Generation {k:02d} passed{RESET} in {BOLD}{elapsed:.2f}s{RESET} | Snapshot: {gen_snapshot}")
            print(f"  Payload: {CYAN}{current_output.strip()}{RESET}")

            # Re-feed output into Stage 0 for next generation
            shutil.copyfile(output_file, input_file)
            print(f"  {DIM}Fed output back to stages/00_input/input.html for next cycle{RESET}\n")

    finally:
        # Restore original canonical input
        with open(input_file, "w", encoding="utf-8") as f:
            f.write(gen0_payload)

    # Bauhaus Final Verification Certificate
    total_time = sum(m["duration"] for m in generation_metrics)
    print(f"\n{BOLD}{GREEN}╔══════════════════════════════════════════════════════════════════════════╗{RESET}")
    print(f"{BOLD}{GREEN}║{RESET}  {BOLD}{WHITE}OUROBOROS MATHEMATICAL IDEMPOTENCY CERTIFICATE{RESET}                       {BOLD}{GREEN}║{RESET}")
    print(f"{BOLD}{GREEN}╠══════════════════════════════════════════════════════════════════════════╣{RESET}")
    print(f"{BOLD}{GREEN}║{RESET}  Status:       {BOLD}{GREEN}PROVEN LOSSLESS & IDEMPOTENT{RESET}                             {BOLD}{GREEN}║{RESET}")
    print(f"{BOLD}{GREEN}║{RESET}  Cycles:       {BOLD}{WHITE}{cycles}{RESET} complete recursive generations                            {BOLD}{GREEN}║{RESET}")
    print(f"{BOLD}{GREEN}║{RESET}  Total Time:   {BOLD}{WHITE}{total_time:.2f}s{RESET}                                                     {BOLD}{GREEN}║{RESET}")
    print(f"{BOLD}{GREEN}║{RESET}  Stages / Gen: {BOLD}{WHITE}20 distinct parsers, compilers & runtimes{RESET}                 {BOLD}{GREEN}║{RESET}")
    print(f"{BOLD}{GREEN}║{RESET}  Total Passes: {BOLD}{WHITE}{cycles * 20}{RESET} compiled transformations                                  {BOLD}{GREEN}║{RESET}")
    print(f"{BOLD}{GREEN}║{RESET}  Invariant:    ∀ k ∈ [1..{cycles}], DOM(Pipeline^k(S0)) ≡ DOM(S0)             {BOLD}{GREEN}║{RESET}")
    print(f"{BOLD}{GREEN}╚══════════════════════════════════════════════════════════════════════════╝{RESET}\n")


if __name__ == "__main__":
    main()
