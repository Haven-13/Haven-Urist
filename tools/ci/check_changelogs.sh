#!/bin/bash
set -euo pipefail

md5sum -c - <<< "2d8811f2f66cf848f8f19e658aa41300 *.changelog/.example.yml"
python3 tools/changelog/generate_cl.py --dry-run
python3 tools/changelog/compile_cl.py html/changelog/changelog.html .changelog --dry-run

