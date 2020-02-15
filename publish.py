#!/usr/bin/env python3

import os
import re
import sys


def write_file(path, str):
    f = open(path, "w")
    f.write(str)
    f.close()


def read_file(path):
    f = open(path, "r")
    str = f.read()
    f.close()
    return str


def get_input(promo, default):
    inp = input(promo)
    if inp == "":
        return default
    else:
        return inp


def get_input_multiline(promo, default):
    print(promo)
    lines = []
    while True:
        line = input()
        if line:
            lines.append(line)
        else:
            break
    if len(lines) == 0:
        return default
    else:
        return '\\n'.join(lines)


args = sys.argv.copy()[1:]
isRelease = args[0] == "release"
versionName = ""

# update version info
versionNumberRegex = "\\d+\\.\\d+\\.\\d+"
buildNumberRegex = "(?<=\\+)\\d+"
if isRelease:
    write_file("lib/nightly.dart", "const nightly = false;")
    pubspec = read_file("pubspec.yaml")

    versionNumber = re.findall(versionNumberRegex, pubspec)[0]
    buildNumber = re.findall(buildNumberRegex, pubspec)[0]
    versionNumber = get_input("Enter a new version number (current {}):".format(versionNumber),
                              versionNumber)
    buildNumber = str(int(buildNumber) + 1)
    versionName = versionNumber
    print("New version: " + versionNumber + "+" + buildNumber)

    pubspec = re.sub(versionNumberRegex, versionNumber, pubspec, 1)
    pubspec = re.sub(buildNumberRegex, buildNumber, pubspec, 1)
    write_file("pubspec.yaml", pubspec)
else:
    write_file("lib/nightly.dart", "const nightly = true;")
    pubspec = read_file("pubspec.yaml")

    versionNumber = re.findall(versionNumberRegex, pubspec)[0]
    buildNumber = re.findall(buildNumberRegex, pubspec)[0]
    buildNumber = str(int(buildNumber) + 1)
    versionName = "Nightly build " + buildNumber
    print("New version: " + versionNumber + "+" + buildNumber)

    pubspec = re.sub(buildNumberRegex, buildNumber, pubspec, 1)
    write_file("pubspec.yaml", pubspec)
del args[0]

release_note = get_input_multiline("Release Note:", "").replace("-", "[")

# build
os.system("./build.py")

# upload
if isRelease:
    os.system("thunar build/app/outputs/apk/release/")
else:
    os.system("./basic_upload_apks.py site.pegasis.yrdsb.ta \"" + versionName + "\" \"" + release_note +
              "\" build/app/outputs/apk/release/app-armeabi-v7a-release.apk build/app/outputs/apk/release/app-arm64-v8a-release.apk build/app/outputs/apk/release/app-x86_64-release.apk")
