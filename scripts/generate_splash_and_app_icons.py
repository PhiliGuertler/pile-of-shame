import os
import subprocess
import shutil

class terminalColors:
    WARNING = '\033[93m'
    INFO = '\033[94m'
    END_COLOR = '\033[0m'

# first of all, jump into this directory no matter where we actually started this script
script_path = os.path.abspath(__file__)
script_directory = os.path.dirname(script_path)
os.chdir(script_directory)
# now jump to the root directory of the repository
os.chdir('..')

# Windows requires the shell=True option on subprocesses that use the 'flutter' or 'dart' commands with arguments.
requireShellFlag = os.name == 'nt'

# generate app icon
subprocess.run(['dart', 'run', 'flutter_launcher_icons'], check=True, shell=requireShellFlag)
shutil.copy('./assets/app/logo.png', './android/fastlane/metadata/android/de-DE/images/icon.png')
# generate splash screens
subprocess.run(['dart', 'run', 'flutter_native_splash:create'], check=True, shell=requireShellFlag)
