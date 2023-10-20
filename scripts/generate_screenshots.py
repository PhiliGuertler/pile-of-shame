import os
import subprocess

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

subprocess.run(['flutter', 'test', 'test/generate_screenshots/screenshot_generator.dart', '--update-goldens'], check=True, shell=True)

# TODO: copy screenshots to android directory