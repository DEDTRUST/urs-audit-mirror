# Signing Key Attestation — URS/DUX Audit Bundle

The maintainer's official OpenPGP **public** key is published here and attested
below. Every value is read directly from the key itself.

## Key

| Field | Value |
|---|---|
| Owner UID | `dwayne edwards <edwardsdwayne869@gmail.com>` |
| Long key ID | `0BBD9D4EBF822348` |
| Full fingerprint (40‑hex) | `459AECD641EAFBA2FAE55F9C0BBD9D4EBF822348` |
| Algorithm | ed25519 (sign) + cv25519 (encrypt) |
| Created / expires | 2026‑07‑11 / 2029‑07‑11 |
| Public key file | `attestations/publickey.asc` |
| `publickey.asc` SHA‑256 | `cb8c33c0c32affd6fcf1cf92474dd94c90ba8806cca4d73f4e25e0eb4a917eb2` |

Formatted fingerprint (for reports):
`459A ECD6 41EA FBA2 FAE5  5F9C 0BBD 9D4E BF82 2348`

## What this key signs

The release tag `v1.2.0` (annotated on commit `4449e3d`) and, optionally, detached
signatures of the audit artifacts. The tag records the pinned roots:

| Root | Value |
|---|---|
| Tier‑14 escalation MSR | `8c2e29062c977d2c1d6e21b359a63481e3d46a7a825af23ecafab373f947da8a` |
| 1,000,000‑scenario audit MSR | `cb80d4ef4de1e108ccb2ba48366fef890b93c6bf4ec2f5df3472a04d25603535` |
| Spintronic lattice root | `5d64e56c865334bac0766e17a0153e712891d68764b39dbf37c1ab2d2bc8de2b` |
| Artifact bundle root | `56dca82e985024e5fe341b0a1ac48a385be724794d816ca49af092024cd279c8` |
| External anchor payload | `URS1|56dca82e985024e5fe341b0a1ac48a385be724794d816ca49af092024cd279c8` (txid PENDING) |

> The tag is currently **annotated, not signed** — this build environment holds
> no private key and cannot push tag refs (GitHub returns 403 on `refs/tags/*`
> for the session token). Sign and push from a machine that holds the **private**
> half of `0BBD9D4EBF822348`:
>
> ```bash
> git fetch origin
> git config --global gpg.format openpgp
> git config --global user.signingkey 0x0BBD9D4EBF822348
> # tag the freeze commit 4449e3d (carries all pinned roots)
> git tag -s v1.2.0 4449e3d -m "URS/DUX v1.2.0 — Tier14 8c2e2906… · 1M cb80d4ef… · bundle 56dca82e…"
> git push origin v1.2.0
> git tag -v v1.2.0        # expect: Good signature from dwayne edwards
> ```
> Then paste the `git tag -v v1.2.0` output into `attestations/TAG_VERIFICATION.txt`.
>
> Also upload the public key to GitHub (Settings → SSH and GPG keys → New GPG
> key) so the web UI shows the tag/commits as **Verified**.

## Auditor verification — run these

```bash
# A. Import and confirm the published key matches this attestation
gpg --import attestations/publickey.asc
gpg --fingerprint 0x0BBD9D4EBF822348      # must equal 459AECD641EAFBA2FAE55F9C0BBD9D4EBF822348
sha256sum attestations/publickey.asc       # must equal cb8c33c0c32affd6fcf1cf92474dd94c90ba8806cca4d73f4e25e0eb4a917eb2

# B. Verify the signed release tag against that key (after the maintainer signs it)
git tag -v v1.2.0                           # expect "Good signature"

# C. Reproduce every pinned root independently (no trust in our environment)
./independent_verify.sh                     # PASS ⇒ Tier-14 + 1M + bundle reproduce

# D. (once broadcast) confirm the external anchor carries the bundle root
ANCHOR_TXID=<txid> ./independent_verify.sh
```

If (B) fails, re‑check that the **full fingerprint** (not the 16‑char ID) matches
and that `publickey.asc` is the exact key used to sign.

## Notes

- Only the **public** key is published here; the private key stays with the owner.
- Use the full 40‑hex fingerprint in audit reports, never a short ID.
- The `publickey.asc` SHA‑256 above lets auditors confirm the exact key file.
- On rotation, publish a statement signed by the old key linking old→new
  fingerprints and add it to governance ADRs.

*© 2026 SSV Sentinel LLC — THE INTERFACE IS THE INTELLIGENCE™ · THE CODE IS THE HARDWARE™*
