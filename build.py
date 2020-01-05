#!/usr/bin/env python3

import sys,os

if len(sys.argv)==1:
    os.system("flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi")
else:
    os.system("flutter build apk --target-platform {} --split-per-abi"
              .format(",".join(["android-"+s for s in sys.argv[1:]])))
os.system("thunar build/app/outputs/apk/release/")
