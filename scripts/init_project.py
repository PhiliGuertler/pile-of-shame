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

# Run initialization steps
subprocess.run(['flutter', 'pub', 'get'], check=True)
subprocess.run(['flutter', 'gen-l10n'], check=True)
subprocess.run(['dart', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'], check=True)