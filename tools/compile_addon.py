#!/usr/bin/env python3
"""Build the safe, local install tree for ForeverQuestProbe."""
from __future__ import annotations
import argparse
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / ".compiled" / "ForeverQuestProbe"
SHIPPED = ("ForeverQuestProbe.toc", "Core.lua", "Capabilities.lua", "QuestScanner.lua", "PinScanner.lua", "Correlator.lua", "Serializer.lua", "UI.lua", "LICENSE", "README.md", "CHANGELOG.md")
def version() -> str:
    base = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    result = subprocess.run(["git", "describe", "--always", "--dirty"], cwd=ROOT, capture_output=True, text=True, check=False)
    return base + "+" + (result.stdout.strip() or "local")
def compile_addon(output: Path = OUTPUT, *, dry_run: bool = False) -> list[Path]:
    files = [ROOT / name for name in SHIPPED]
    if dry_run: return [output / path.name for path in files]
    if output.exists(): shutil.rmtree(output)
    output.mkdir(parents=True)
    for source in files: shutil.copy2(source, output / source.name)
    toc = output / "ForeverQuestProbe.toc"; toc.write_text(toc.read_text(encoding="utf-8").replace("@project-version@", version()), encoding="utf-8")
    return [output / path.name for path in files]
if __name__ == "__main__":
    parser = argparse.ArgumentParser(); parser.add_argument("--dry-run", action="store_true"); args = parser.parse_args(); built = compile_addon(dry_run=args.dry_run); print(f"Built {len(built)} files in {OUTPUT}" if not args.dry_run else "\n".join(map(str, built)))
