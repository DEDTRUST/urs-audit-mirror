# URS/DUX v1.2.0 - Audit Guide (mirror)

1. Confirm the operator key
   gpg --import attestations/publickey.asc
   gpg --fingerprint 0x0BBD9D4EBF822348   (-> 459AECD641EAFBA2FAE55F9C0BBD9D4EBF822348)
   Windows hash: Get-FileHash attestations\publickey.asc -Algorithm SHA256
   (-> cb8c33c0c32affd6fcf1cf92474dd94c90ba8806cca4d73f4e25e0eb4a917eb2)

2. Verify the sealed bundle (source-free)
   Windows:   powershell -ExecutionPolicy Bypass -File verify_bundle.ps1
   Linux/Mac: ./verify_bundle.sh
   Expected:  [PASS] bundle_root reproduces: 56dca82e985024e5fe341b0a1ac48a385be724794d816ca49af092024cd279c8
   The bundle root is content-addressed (SHA-256 over the sorted "sha256 path"
   list in store/MANIFEST.json) - NOT the hash of a tarball.

3. Confirm the signed tag (in the primary repo)
   attestations/TAG_VERIFICATION.txt records: Good signature from dwayne edwards.
   Access-holders reproduce: git -C <primary-repo> tag -v v1.2.0

4. (Optional) OpenTimestamps:  ots verify store/BUNDLE_ROOT.ots  (once stamped)

5. Source-level reproduction (primary repo):  ./independent_verify.sh
