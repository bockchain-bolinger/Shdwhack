# Technischer Audit-Report

## Vorherige Risiken
- Fehlende `tga.sh`-Sprünge führten zu Laufzeitabbrüchen.
- Breite Legacy-Menüs mit potenziell riskanten Aktionen.
- Keine deterministischen Exit-Codes für Automatisierung.
- Kein CI-Linting für Shell-Qualität.

## Umgesetzte Optimierungen

### Security
1. Menü auf sichere Allowlist reduziert (`0-3`).
2. Legacy-Risikooptionen vollständig aus aktiver Logik entfernt.
3. Eigene `SECURITY.md` Policy ergänzt.

### Data Integrity / Stability
1. `set -euo pipefail` aktiv.
2. Deterministische Exit-Codes definiert (`0`, `2`, `3`, `64`).
3. Non-interactive CLI-Flags ergänzt (`--prepare-tools`, `--remove-tools`, `--usage`, `--open-guide`, `--help`).
4. Lokale Offlinenutzung mit `USAGE.md`.

### Quality
1. CI-Workflow für `bash -n` + `shellcheck` ergänzt.
2. `CHANGELOG.md` für versionsklare Nachvollziehbarkeit ergänzt.

## Offene nächste Schritte
1. Optional Integrationstests via `bats` hinzufügen.
2. Optional Lockfile (`flock`) für parallele Ausführung ergänzen.
3. Optional TTY-sensitives Rendering (`--no-banner`) ergänzen.
