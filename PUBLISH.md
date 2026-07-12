# Publishing this Audit Mirror

1. Create an empty PUBLIC repo on GitHub: urs-audit-mirror (no README/license).
2. From inside this audit_mirror folder:
     git init -b main
     git add .
     git commit -S -m "URS/DUX v1.2.0 audit mirror - sealed outputs + verifier (no source)"
     git remote add origin https://github.com/DEDTRUST/urs-audit-mirror.git
     git push -u origin main
3. Confirm a fresh clone verifies:
     git clone https://github.com/DEDTRUST/urs-audit-mirror.git
     cd urs-audit-mirror
     powershell -ExecutionPolicy Bypass -File verify_bundle.ps1   (or ./verify_bundle.sh)
4. (Optional) OTS: in the primary repo run  ots stamp store/BUNDLE_ROOT,
   copy store/BUNDLE_ROOT.ots here, record its sha256 (+txid) in
   store/anchor/anchor_bundle.json, then commit -S and push.
