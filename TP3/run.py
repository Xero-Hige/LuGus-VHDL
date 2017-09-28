#!/usr/bin/python
import os
import re
import sys

ANALISIS_ERRROR = 1
COMPILE_ERROR = 2
RUN_ERROR = 3


ANALYZER = 'ghdl -a '
COMPILER = 'ghdl -e '
VALID_EXTENSIONS = ['vhd','vhdl']

def analyze_file(filepath):
    print '\n\n###### ANALYSING ' + get_name(filepath) + ' ######'
    rvalue = os.system(ANALYZER + filepath)
    if not rvalue:
        print "OK"
    else:
        sys.exit(ANALISIS_ERRROR)

def compile_file(filepath):
    print '\n\n###### COMPILING ' + get_name(filepath) + ' ######'
    rvalue = os.system(COMPILER + filepath)
    if not rvalue:
        print "OK"
    else:
        sys.exit(COMPILE_ERROR)

def get_extension(filepath):
    return filepath.split('.')[-1]

def get_name(filepath):
    return (filepath.split('/')[-1]).split('.')[0]

def get_files_recursively(folderpath=os.getcwd()):
    files = []
    for f in os.listdir(folderpath):
        if os.path.isdir(f):
            files = files + get_files_recursively(f)
        elif get_extension(f) in VALID_EXTENSIONS:
            if(folderpath == os.getcwd()):
                files.append(f)
            else:
                files.append(folderpath + "/" + f)
    return files

def get_file_level(filepath):
    total_components = 0
    f = open(filepath, 'r')
    for line in f:
        match = re.search('.*component .* is.*', line)
        if match:
            total_components += 1
    f.close()
    return total_components

def get_entities(filepath):
    entities = []
    f = open(filepath, 'r')
    for line in f:
        entity = re.match('.*entity (.*) is.*', line)
        if entity:
            entities.append(entity.group(1))
    f.close()
    return entities


def get_testbenches(filelist):
    locallist = filter(lambda filename : (filename.split('_')[-1]).split(".")[0] == 'tb',filelist)
    return locallist

def get_components(filelist):
    testbenches = get_testbenches(filelist)
    return list(set(filelist) - set(testbenches))


def main():
    files = get_files_recursively()
    components = get_components(files)
    components.sort(key=lambda elem: get_file_level(elem))

    '''Components should be analyzed before test benches always to prevent compilation errors '''
    map(analyze_file,components)


    test_benches = get_testbenches(files)
    map(analyze_file,test_benches)
    entities = []
    for tb in test_benches:
        entities += get_entities(tb)

    map(compile_file,entities)
    end_status = 0
    for f in entities:
        name = get_name(f)
        print "\n\n\n\n####### RUNING TEST FOR: " +  name + ' ######'
        end_status += os.system("./" + name)
    if end_status:
        sys.exit(RUN_ERROR)

main()
