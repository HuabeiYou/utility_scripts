import subprocess
import sys
import re
import tempfile
import zipfile
from pathlib import Path


def main():
    if len(sys.argv) < 2:
        print("Usage: python extract_wheel.py [wheel name]")
        sys.exit(1)

    pkg = sys.argv[1]
    output_file = f"requirements_{pkg}.txt"

    with tempfile.TemporaryDirectory() as tmp:
        print(f"Downloading {pkg}...")
        subprocess.run(
            ["pip", "download", pkg, "--no-deps", "-d", tmp],
            check=True,
            capture_output=True,
        )

        wheels = list(Path(tmp).glob("*.whl"))
        if not wheels:
            print("Error: No wheel downloaded")
            sys.exit(1)
        whl = wheels[0]
        print(f"Extracting {whl.name}...")

        extract_dir = Path(tmp) / "extracted"
        with zipfile.ZipFile(whl, "r") as z:
            z.extractall(extract_dir)

        # Find all bundled dependencies (exclude the wrapper itself)
        deps = []
        wrapper_marker = pkg.lower().replace("-", "_").replace(".", "_")

        for meta in extract_dir.glob("**/*.dist-info/METADATA"):
            content = meta.read_text()

            if wrapper_marker in meta.parent.name.lower():
                # Wrapper package: extract from Requires-Dist lines
                for line in content.splitlines():
                    if line.startswith("Requires-Dist:"):
                        dep = line.split(":", 1)[1].strip()
                        # Strip environment markers (e.g., `; python_version>"3.8"`)
                        if ";" in dep:
                            dep = dep.split(";")[0].strip()
                        deps.append(dep)
            else:
                # Bundled/vendored package: extract directly from metadata
                name = re.search(r"^Name: (.+)$", content, re.MULTILINE)
                ver = re.search(r"^Version: (.+)$", content, re.MULTILINE)
                if name and ver:
                    deps.append(f"{name.group(1).strip()}=={ver.group(1).strip()}")

        if not deps:
            print("No bundled dependencies found in wheel")
            sys.exit(1)

        print(f"Found {len(deps)} packages")

        deps.sort()
        Path(output_file).write_text("\n".join(deps) + "\n")
        print(f"Saved {len(deps)} dependencies to {output_file}")


if __name__ == "__main__":
    main()
