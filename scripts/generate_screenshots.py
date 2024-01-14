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

# This script generates screenshots for the google play store entry using widget tests and the golden_toolkit.

# generate screenshots
subprocess.run(['flutter', 'test', 'test/generate_screenshots/screenshot_generator.dart', '--update-goldens'], check=True, shell=requireShellFlag)

locales = ['de-DE', 'en-US', 'es-ES', 'fr-FR', 'pt-PT', 'ru-RU']
sizes = [['android', 'phoneScreenshots'], ['android7inch', 'sevenInchScreenshots'], ['android10inch', 'tenInchScreenshots']]
screens = ['game_list', 'add_game', 'game_details', 'hardware_list', 'library_list', 'analytics_all_list']

def copyFiles(locale, prefix, target):
    sourceDir = './test/generate_screenshots/goldens/'

    phonePrefix = prefix+'-dark-'+locale[:2]+'-'
    fileSuffix = '.final.png'
    targetDir = './android/fastlane/metadata/android/'+locale+'/images/'+target+'/'

    counter = 1
    for screen in screens:
        shutil.copy(sourceDir + phonePrefix + screen + fileSuffix, targetDir + str(counter) + '_' + locale + '.png')
        counter = counter + 1

for locale in locales:
    for size in sizes:
        copyFiles(locale, size[0], size[1])

# Use the english images for korean and japanese, as their glyphs are not loaded by golden_toolkit somehow.
def copyEnglishFiles(locale):
    sourceDir = './android/fastlane/metadata/android/en-US/images/'
    targetDir = './android/fastlane/metadata/android/'+locale+'/images/'

    if os.path.exists(targetDir):
        shutil.rmtree(targetDir)
    shutil.copytree(sourceDir, targetDir)

copyEnglishFiles('ja-JP')
copyEnglishFiles('ko-KR')