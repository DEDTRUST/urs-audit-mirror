# URS/DUX v1.2.0 - Sovereign Audit Mirror

Public, verification-only mirror of the signed, anchored release artifacts. The
program source is not distributed here; it lives in the access-controlled primary
repository. This mirror ships the sealed outputs so anyone can verify authenticity,
integrity, and provenance without repo access.

## Contents
- attestations/publickey.asc  - operator key 0BBD9D4EBF822348
  fingerprint 459A ECD6 41EA FBA2 FAE5  5F9C 0BBD 9D4E BF82 2348
  SHA-256 cb8c33c0c32affd6fcf1cf92474dd94c90ba8806cca4d73f4e25e0eb4a917eb2
- attestations/TAG_VERIFICATION.txt  - git tag -v v1.2.0 output (Good signature),
  tag bound to freeze commit 4449e3de5c7cd120477d050e272b806d5da74e6e
- attestations/RELEASE_v1.2.0_PROVENANCE.md  - pinned roots + provenance chain
- store/  - content-addressed artifacts, MANIFEST.json, BUNDLE_ROOT (56dca82e...)
- verify_bundle.sh (Linux/Mac) and verify_bundle.ps1 (Windows)

## Pinned roots
Tier-14 8c2e2906...  |  1M scenario cb80d4ef...  |  bundle 56dca82e...  |  lattice 5d64e56c...

## Verify
Windows:   powershell -ExecutionPolicy Bypass -File verify_bundle.ps1
Linux/Mac: ./verify_bundle.sh
Both print: [PASS] bundle_root reproduces: 56dca82e...

No source here; source-level root reproduction is done in the primary repo with
independent_verify.sh. Operator: Dwayne Edwards - edwardsdwayne869@gmail.com
