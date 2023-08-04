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
os.chdir('../ios/')

print('Removing Podfile.lock')
subprocess.run(['rm', '-f', './Podfile.lock'], check=True)
print('Removing pod repo trunk')
subprocess.run(['pod', 'repo', 'remove', 'trunk'], check=True)
print('Installing pods')
subprocess.run(['pod', 'install', '--repo-update'], check=True)
print('Cleaning flutter')
subprocess.run(['flutter', 'clean'], check=True)
print('Getting flutter dependencies')
subprocess.run(['flutter', 'pub', 'get'], check=True)

print(f'{terminalColors.WARNING}If this did not help, try restarting your IDE.{terminalColors.END_COLOR}')