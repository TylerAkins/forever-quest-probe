"""Static and build tests; they simulate contracts rather than a Forever client."""
from __future__ import annotations
import importlib.util
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
class ContractTests(unittest.TestCase):
    def test_toc_order_and_interface(self) -> None:
        lines = (ROOT / "ForeverQuestProbe.toc").read_text().splitlines()
        self.assertIn("## Interface: 16001", lines)
        self.assertEqual(lines[-7:], ["Core.lua", "Capabilities.lua", "QuestScanner.lua", "PinScanner.lua", "Correlator.lua", "Serializer.lua", "UI.lua"])
    def test_source_has_safety_contracts(self) -> None:
        text = (ROOT / "PinScanner.lua").read_text()
        self.assertIn("questKeys", text); self.assertIn("EnumeratePins", text); self.assertNotIn("SetUserWaypoint", text)
        self.assertIn("pcall", text); self.assertIn("ns.LIMITS.pins", text)
    def test_requested_diagnostic_contracts_are_present(self) -> None:
        core = (ROOT / "Core.lua").read_text()
        serializer = (ROOT / "Serializer.lua").read_text()
        capabilities = (ROOT / "Capabilities.lua").read_text()
        for command in ("help", "status", "apis", "pins", "quests", "capture", "list", "show", "export", "clear"):
            self.assertIn('command == "' + command + '"', core)
        self.assertIn('rest:lower() == "confirm"', core)
        self.assertIn("<cycle>", serializer); self.assertIn("<max-depth>", serializer); self.assertIn("<unsupported:", serializer)
        self.assertIn("missing", capabilities); self.assertIn("not_callable", capabilities); self.assertIn("not_attempted_missing_context", capabilities)
    def test_compiler_excludes_test_files_and_replaces_version(self) -> None:
        spec = importlib.util.spec_from_file_location("compiler", ROOT / "tools/compile_addon.py"); module = importlib.util.module_from_spec(spec); assert spec and spec.loader; spec.loader.exec_module(module)
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp) / "ForeverQuestProbe"; files = module.compile_addon(output)
            self.assertTrue((output / "ForeverQuestProbe.toc").is_file()); self.assertFalse((output / "tests").exists()); self.assertNotIn("@project-version@", (output / "ForeverQuestProbe.toc").read_text()); self.assertEqual(len(files), len(module.SHIPPED))
    def test_dry_run_is_non_mutating(self) -> None:
        spec = importlib.util.spec_from_file_location("compiler", ROOT / "tools/compile_addon.py"); module = importlib.util.module_from_spec(spec); assert spec and spec.loader; spec.loader.exec_module(module)
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp) / "ForeverQuestProbe"; output.mkdir(); marker = output / "stale"; marker.write_text("keep")
            module.compile_addon(output, dry_run=True); self.assertTrue(marker.exists())
