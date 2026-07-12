# Release v1.2.0 — Provenance & Audit Summary

| Field | Value |
|---|---|
| Operator | Dwayne Edwards |
| Operator key ID | `0BBD9D4EBF822348` |
| Fingerprint | `459A ECD6 41EA FBA2 FAE5  5F9C 0BBD 9D4E BF82 2348` |
| Public key SHA-256 | `cb8c33c0c32affd6fcf1cf92474dd94c90ba8806cca4d73f4e25e0eb4a917eb2` |
| Repository | `ecosystem-directory` |
| Release tag | `v1.2.0` |
| Tag object | `7108e6cd954db1a50f8e046b2dce7a32178686d9` |
| Tagged commit | `4449e3de5c7cd120477d050e272b806d5da74e6e` |

## Pinned roots bound by v1.2.0

| Root | Value |
|---|---|
| Tier-14 escalation MSR | `8c2e29062c977d2c1d6e21b359a63481e3d46a7a825af23ecafab373f947da8a` |
| 1,000,000-scenario MSR | `cb80d4ef4de1e108ccb2ba48366fef890b93c6bf4ec2f5df3472a04d25603535` |
| Artifact bundle root | `56dca82e985024e5fe341b0a1ac48a385be724794d816ca49af092024cd279c8` |
| Spintronic lattice root | `5d64e56c865334bac0766e17a0153e712891d68764b39dbf37c1ab2d2bc8de2b` |

## Signature verification

`git tag -v v1.2.0` (full output in `attestations/TAG_VERIFICATION.txt`):

```
gpg: Good signature from "dwayne edwards <edwardsdwayne869@gmail.com>" [ultimate]
```

Confirms: the tag is signed with the operator's ed25519 key, the freeze commit is
authenticated, and the pinned roots are cryptographically bound to it.

## Anchor status

| Field | Value |
|---|---|
| OTS stamp target | `store/BUNDLE_ROOT` (contains the bundle root; the canonical anchored value) |
| OTS proof file | `store/BUNDLE_ROOT.ots` (created by `ots stamp`) |
| OTS proof SHA-256 | PENDING |
| Bitcoin TXID | PENDING |
| Anchor metadata | `store/anchor/anchor_bundle.json` |

> Note: the bundle root is content-addressed over `store/MANIFEST.json`, not the
> hash of a tarball. Auditors reproduce it with
> `bash scripts/build_artifact_store.sh verify` or `./independent_verify.sh`.

## Independent verification

See `AUDITOR_GUIDE.md`. In short:

```bash
git tag -v v1.2.0                 # Good signature — tag authenticity
./independent_verify.sh           # Tier-14 + 1M + bundle root reproduce from source
ots verify store/BUNDLE_ROOT.ots  # (optional) timestamp validity, once stamped
```

## Provenance chain

```
operator key 0BBD9D4EBF822348
      │ signs
      ▼
signed tag v1.2.0 ──▶ freeze commit 4449e3de5c
                          │ contains / binds
                          ▼
      Tier-14 root · 1M scenario root · lattice root · artifact bundle root
                          │ content-addressed
                          ▼
             store/MANIFEST.json → BUNDLE_ROOT 56dca82e
                          │ (optional) timestamp
                          ▼
                 OpenTimestamps / on-chain anchor (PENDING)
```

*© 2026 SSV Sentinel LLC — THE INTERFACE IS THE INTELLIGENCE™ · THE CODE IS THE HARDWARE™*
