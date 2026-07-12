# URS/DUX v1.2.0 - Reproducibility Statement (mirror)

Outputs are deterministic and content-addressed. Verifiable here (no source):
operator key, bundle root (verify_bundle), recorded signed-tag verification, and
the OTS/on-chain anchor once present. Requires the primary repository: rebuilding
the binaries and reproducing the Tier-14 / 1M-scenario roots from source via
./independent_verify.sh. This is a distribution boundary (the mirror is
source-free), not a limit on verifiability - the roots reproduce exactly for
anyone with source access, and their sealed forms reproduce here for everyone.
