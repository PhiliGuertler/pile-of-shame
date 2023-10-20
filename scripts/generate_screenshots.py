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

# generate screenshots
subprocess.run(['flutter', 'test', 'test/generate_screenshots/screenshot_generator.dart', '--update-goldens'], check=True, shell=True)

locales = ['de-DE', 'en-US']
screens = ['game_list', 'add_game', 'game_details', 'hardware_list', 'library_list', 'analytics_all_list']

def copyFiles(locale):
    sourceDir = './test/generate_screenshots/goldens/'

    phonePrefix = 'android-dark-'+locale[:2]+'-'
    fileSuffix = '.final.png'
    targetDir = './android/fastlane/metadata/android/'+locale+'/images/phoneScreenshots/'

    counter = 1
    for screen in screens:
        shutil.copy(sourceDir + phonePrefix + screen + fileSuffix, targetDir + str(counter) + '_' + locale + '.png')
        counter = counter + 1

for locale in locales:
    copyFiles(locale)