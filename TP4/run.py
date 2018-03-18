#!/usr/bin/python
#!/usr/local/bin/python
import os
import re
import sys

ANALISIS_ERRROR = 1
COMPILE_ERROR = 2
RUN_ERROR = 3

GHDL_HOME = '../ghdl'
GHDL = GHDL_HOME + '/bin/ghdl'

IMPORTER = GHDL + ' -i '
ANALYZER =  GHDL + ' -a '
COMPILER = GHDL + ' -m '
RUNNER = GHDL + ' -r '

IMPORTED_LIBRARIES = {
        'unisim':[GHDL_HOME + '/lib/ghdl/vendors/vhdl/src/unisims/unisim_vcomp.vhd',GHDL_HOME + '/lib/ghdl/vendors/vhdl/src/unisims/unisim_vpkg.vhd',GHDL_HOME + '/lib/ghdl/vendors/vhdl/src/unisims/primitive/*.vhd'],
        'unimacro':[GHDL_HOME + '/lib/ghdl/vendors/vhdl/src/unimacro/*.vhd']
    }

#------FLAGS-------
LIBRARIES_FLAGS = [' -P' + key + ' ' for key in IMPORTED_LIBRARIES.keys()]
EXECUTION_FLAGS = [' --ieee=synopsys']
FLAGS = EXECUTION_FLAGS + LIBRARIES_FLAGS

VALID_EXTENSIONS = ['vhd','vhdl']


def execute(command, flags, param):
    return os.system(command + ' '.join(flags) + param)

def analyze_file(filepath):
    print '\n\n###### ANALYSING ' + get_name(filepath) + ' ######'
    rvalue = execute(ANALYZER, FLAGS, filepath)
    if not rvalue:
        print "OK"
    else:
        sys.exit(ANALISIS_ERRROR)

def compile_file(filepath):
    print '\n\n###### COMPILING ' + get_name(filepath) + ' ######'
    rvalue = execute(COMPILER, FLAGS, filepath)
    if not rvalue:
        print "OK"
    else:
        sys.exit(COMPILE_ERROR)

def import_libraries():
    for key in IMPORTED_LIBRARIES.keys():
        print '\n\n###### IMPORTING: ' +  key + ' ######\n\n'
        work_flag = '--work=' + key + ' '
        for path in IMPORTED_LIBRARIES[key]:
            execute(IMPORTER, [work_flag] ,path)

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

def filter_by_name(module_name, component_list):
    if(module != None):
        return filter(lambda name : module_name in name, component_list)
    return component_list


def main(module):

    import_libraries()

    files = get_files_recursively()
    components = get_components(files)
    components.sort(key=lambda elem: get_file_level(elem))

    components = filter_by_name(module, components)

    '''Components should be analyzed before test benches always to prevent compilation errors '''
    map(analyze_file,components)


    test_benches = filter_by_name(module, get_testbenches(files))


    map(analyze_file,test_benches)
    entities = []
    for tb in test_benches:
        entities += get_entities(tb)

    map(compile_file,entities)
    end_status = 0
    for f in entities:
        name = get_name(f)
        print "\n\n\n\n####### RUNING TEST FOR: " +  name + ' ######'
        end_status += execute(RUNNER, FLAGS, name)
    if end_status:
        sys.exit(RUN_ERROR)

module = None
args = sys.argv
if(len(args) > 1):
    module = args[1]

main(module)
