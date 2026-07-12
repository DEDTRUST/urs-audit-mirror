# urs-audit-mirror

Public read-only mirror of the **URS/DUX v1.2.0** sealed audit outputs.  
Contains no source code — only the generated artefacts and an independent verifier.

---

## What is this?

| Item | Purpose |
|---|---|
| `bundle/metadata.json` | Release provenance (project, version, timestamp, algorithm) |
| `bundle/outputs/audit_report.json` | Sealed audit report (all 142 checks PASS) |
| `bundle/outputs/schema.json` | JSON Schema for the audit report format |
| `bundle/manifest.json` | Per-file SHA-256 hashes + deterministic `bundle_root` |
| `verify_bundle.ps1` | Content-addressed verifier — run this to confirm integrity |

---

## Verify from a fresh clone

```powershell
git clone https://github.com/DEDTRUST/urs-audit-mirror.git mirror-check
cd mirror-check
powershell -ExecutionPolicy Bypass -File verify_bundle.ps1
```

Expected output:

```
[ok]  bundle/metadata.json
[ok]  bundle/outputs/audit_report.json
[ok]  bundle/outputs/schema.json

[PASS] bundle_root reproduces: f39654c0...
```

Exit code `0` = PASS, `1` = FAIL (a file is missing or tampered).

---

## How `bundle_root` is computed

1. SHA-256 each file listed in `bundle/manifest.json`.
2. Build lines of the form `"<hash>  <rel_path>"` (two spaces, forward slashes).
3. Sort those lines lexicographically.
4. Append a trailing newline.
5. `bundle_root = SHA-256` of the resulting UTF-8 string (no BOM).

The `bundle/manifest.json` file is **excluded** from its own hash (it stores the result).

---

## Chain of trust

```
GPG-signed tag  ──►  reproducible build roots
                          │
                          ▼
                   content-addressed bundle  ──►  bundle_root: f39654c0…
                          │
                          ▼
               verify_bundle.ps1 (anyone can run this)
```

---

## License

Audit outputs are published for transparency.  
All rights reserved — see the main URS/DUX project repository for licence terms.