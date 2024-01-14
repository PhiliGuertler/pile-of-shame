import os
import pathlib
import re

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

os.chdir('./test')

# This script generates a test file that includes all non-generated source files to provide a valid base for coverage tests.

with open('coverage_helper_test.dart', 'w+') as file:
    file.write('// ######################################################### //\n')
    file.write('// ### This file is auto generated. Please do not modify ### //\n')
    file.write('// ######################################################### //\n')
    file.write('\n')
    file.write('// ignore_for_file: unused_import\n')
    file.write('\n')
    file.write('// Import all files of this project under /lib:\n')
    file.write('\n')

    libDirectory = pathlib.Path('../lib')
    allFiles = list(libDirectory.rglob("**/*.dart"))
    regex = re.compile(r'.*\.(freezed|g)\.dart')
    filteredFiles = [i for i in allFiles if not regex.match(i.as_posix())]
    for filePath in filteredFiles:
        posixPath = pathlib.Path(*filePath.parts[2:]).as_posix()
        file.write("import 'package:pile_of_shame/" + posixPath + "';\n")

    file.write('\n')
    file.write('void main() {}\n')
