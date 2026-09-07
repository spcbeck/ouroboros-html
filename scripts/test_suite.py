#!/usr/bin/env python3
"""
ouroboros-html Fixture Test Suite Runner
Executes the full 16-stage compiler pipeline across multiple diverse HTML5 payloads.
Enforces Bauhaus-inspired modular grid terminal reporting and strict DOM equivalence.
"""

import os
import sys
import glob
import time
import shutil
import subprocess

# Bauhaus ANSI terminal styling
RESET = "\033[0m"
BOLD = "\033[1m"
RED = "\033[31m"
BLUE = "\033[34m"
YELLOW = "\033[33m"
WHITE_ON_BLUE = "\033[44;37m"
WHITE_ON_RED = "\033[41;37m"
WHITE_ON_BLACK = "\033[40;37m"

def print_bauhaus_banner():
    print(f"\n{BOLD}{WHITE_ON_BLACK}========================================================================{RESET}")
    print(f"{BOLD}  [OUROBOROS-HTML] COMPREHENSIVE FIXTURE SUITE & AST GENERALIZATION {RESET}")
    print(f"{BOLD}  Bauhaus Modular Verification Harness across 16 Compiler Runtimes   {RESET}")
    print(f"{BOLD}{WHITE_ON_BLACK}========================================================================{RESET}\n")

def run_pipeline():
    """Runs make all to execute stages 0-15."""
    res = subprocess.run(["make", "all"], capture_output=True, text=True)
    return res.returncode == 0, res.stdout, res.stderr

def verify_dom(input_file, output_file):
    """Executes Stage 15 deep JSDOM equivalence asserter."""
    res = subprocess.run(
        ["node", "scripts/verify_dom.js", input_file, output_file],
        capture_output=True,
        text=True
    )
    return res.returncode == 0, res.stdout, res.stderr

def main():
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    os.chdir(root_dir)

    fixtures_dir = os.path.join(root_dir, "fixtures")
    stage0_input = os.path.join(root_dir, "stages", "00_input", "input.html")
    stage15_output = os.path.join(root_dir, "stages", "15_assertion", "output.html")

    fixture_files = sorted(glob.glob(os.path.join(fixtures_dir, "*.html")))
    if not fixture_files:
        print(f"{RED}{BOLD}No fixtures found in {fixtures_dir}{RESET}")
        sys.exit(1)

    print_bauhaus_banner()

    results = []
    total_start = time.time()

    for idx, fixture_path in enumerate(fixture_files, 1):
        fixture_name = os.path.basename(fixture_path)
        with open(fixture_path, "r", encoding="utf-8") as f:
            raw_input = f.read().strip()

        print(f"{BOLD}* TEST [{idx}/{len(fixture_files)}]: {fixture_name}{RESET}")
        print(f"  Payload: {BLUE}{raw_input}{RESET}")

        # Inject fixture into Stage 0
        shutil.copyfile(fixture_path, stage0_input)

        start_time = time.time()
        pipeline_ok, p_out, p_err = run_pipeline()
        elapsed = time.time() - start_time

        if not pipeline_ok:
            print(f"  {RED}[FAILED]{RESET} Pipeline compilation error in {fixture_name}")
            print(f"  Stderr tail:\n{p_err[-400:]}")
            results.append((fixture_name, False, "Pipeline Error", elapsed))
            continue

        # Verify deep DOM equality
        dom_ok, d_out, d_err = verify_dom(stage0_input, stage15_output)
        if dom_ok:
            with open(stage15_output, "r", encoding="utf-8") as f:
                raw_output = f.read().strip()
            print(f"  {BLUE}[PASSED]{RESET} Deep DOM Equivalence Verified ({elapsed:.2f}s)")
            print(f"  Output:  {BLUE}{raw_output}{RESET}\n")
            results.append((fixture_name, True, "DOM Verified", elapsed))
        else:
            print(f"  {RED}[FAILED]{RESET} DOM Tree Mismatch: {d_err.strip()}")
            results.append((fixture_name, False, "DOM Mismatch", elapsed))

    # Restore canonical fixture
    canonical_fixture = os.path.join(fixtures_dir, "01_canonical.html")
    if os.path.exists(canonical_fixture):
        shutil.copyfile(canonical_fixture, stage0_input)
        subprocess.run(["make", "all"], capture_output=True)

    total_time = time.time() - total_start

    # Bauhaus Modular Grid Summary Report
    print(f"{BOLD}{WHITE_ON_BLACK}========================================================================{RESET}")
    print(f"{BOLD}                       FIXTURE SUITE SUMMARY REPORT                     {RESET}")
    print(f"{BOLD}{WHITE_ON_BLACK}------------------------------------------------------------------------{RESET}")
    print(f"{BOLD}{'FIXTURE NAME':<32} | {'STATUS':<12} | {'LATENCY':<10} | {'RESULT':<12}{RESET}")
    print(f"{BOLD}{WHITE_ON_BLACK}------------------------------------------------------------------------{RESET}")

    all_passed = True
    for name, ok, note, el in results:
        status_str = f"{BLUE}PASS{RESET}" if ok else f"{RED}FAIL{RESET}"
        print(f"{name:<32} | {status_str:<21} | {el:>7.2f}s   | {note:<12}")
        if not ok:
            all_passed = False

    print(f"{BOLD}{WHITE_ON_BLACK}========================================================================{RESET}")
    if all_passed:
        print(f"{BOLD}{BLUE} >>> [ALL {len(results)} FIXTURES PASSED] TOTAL TIME: {total_time:.2f}s <<<{RESET}\n")
        sys.exit(0)
    else:
        print(f"{BOLD}{RED} >>> [FIXTURE SUITE FAILED] Inspect log details above <<<{RESET}\n")
        sys.exit(1)

if __name__ == "__main__":
    main()
