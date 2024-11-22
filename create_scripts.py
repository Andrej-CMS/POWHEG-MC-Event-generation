import sys
import os
import stat
import string
import subprocess
import random
from glob import glob

def create_scripts (nbatches, process, mass, pdf, stage, initialFolder, runMode = "HTCondor", decay = False):
    
        # check if given argument is a process directory in POWHEG-BOX-V2 or POWHEG-BOX-RES
        if 'POWHEG' not in os.path.dirname(process):
            print(('Error: Argument ' + str(process) + ' is not a POWHEG process directory' + '\nGeneration aborted!'))
            return
        
        # generate directory system
        work_dir = os.getcwd()
        process_name = os.path.basename(os.path.abspath(process))

        # create the folder in which the run is executed
        runFolder = os.path.realpath(process)


        if not os.path.exists(runFolder):
            os.mkdir(runFolder)

         # remove all already existing jobscripts in the GenData directory
        os.chdir(runFolder)
        for script in glob('*.cmd'):
            os.remove(script)

        # Need to copy the powheg inputsave file before scripts are run
        if not os.path.isfile("powheg.input-save") :
            cmd = 'cp ../powheg.input-save .'
            subprocess.call(cmd, shell = True)
    
        os.chdir(runFolder)

        if runMode == "Slurm":
            produceSlurmScripts(nbatches, process, mass, pdf, stage, process_name, work_dir, decay = False,)
        elif runMode == "HTCondor":
            produceHTCondorScripts(nbatches, process, mass, pdf, stage, process_name, initialFolder, work_dir, decay = False)
        
        os.chdir(work_dir)
        print(('created scripts for POWHEG process ' + process_name))

def produceSlurmScripts(nbatches, process, mass, pdf, stage, process_name, work_dir, decay = False):
        filename = "POWHEG_JOB"+stage+".cmd"

        queueTime = '24:00:00'
        if "11" == stage:
            queueTime = '28:00:00'
        if "2" == stage:
            queueTime = '72:00:00'
        if "31" == stage:
            queueTime = '12:00:00'

        with open(filename, 'w') as scriptfile:
            scriptfile.write('#!/bin/bash\n\n')
            scriptfile.writelines(['#SBATCH --job-name=\"'+process_name+'\"\n',
                                    '#SBATCH --workdir=.\n',
                                    '#SBATCH --output=POWHEG_stage'+stage+'.out\n',
                                    '#SBATCH --error=POWHEG_stage'+stage+'.err\n',
                                    '#SBATCH --ntasks='+str(nbatches)+'\n',
                                    '#SBATCH --time='+queueTime+'\n\n',
                                    ])
            
            scriptfile.writelines([ 'module load gcc/8.1.0\n',
                                    'module load openmpi/3.1.1\n',
                                    'cd '+runFolder+'\n',
                                    'source ../setup.sh\n',
                                ])

            if "11" in stage:
                scriptfile.writelines(['srun -n '+str(nbatches)+' ../runparallel-mpi-onlyStage11_12 ../pwhg_main-gnu\n'])
            if "13" in stage:
                scriptfile.writelines(['srun -n '+str(nbatches)+' ../runparallel-mpi-onlyStage13_14 ../pwhg_main-gnu\n'])
            if "15" in stage:
                scriptfile.writelines(['srun -n '+str(nbatches)+' ../runparallel-mpi-onlyStage15_16 ../pwhg_main-gnu\n'])
            if "17" in stage:
                scriptfile.writelines(['srun -n '+str(nbatches)+' ../runparallel-mpi-onlyStage17_18 ../pwhg_main-gnu\n'])
            if "2" == stage:
                scriptfile.writelines(['srun -n '+str(nbatches)+' ../runparallel-mpi-onlyStage2 ../pwhg_main-gnu\n'])
            if "31" == stage:
                scriptfile.writelines(['srun -n '+str(nbatches)+' ../runparallel-mpi-onlyStage34 ../pwhg_main-gnu\n'])

            scriptfile.write('cd ' + str(os.path.abspath(work_dir))+'\n')

def produceHTCondorScripts(nbatches, process, mass, pdf, stage, process_name, initialFolder, work_dir, decay = False):
    os.chdir(initialFolder)
    if not os.path.exists('./GenData'):
        os.mkdir('./GenData')
    if not os.path.exists('./GenData/' + process_name):
        os.mkdir('./GenData/' + process_name)
# create the submit scripts (create_scripts): current_dir/GenData/[ProcessName]/jobscript_batch_[BatchNumber]
    for batch in range(nbatches):
        
        filename = './GenData/'+process_name+'/jobscript_batch_' + str(batch) + '.sh'
 
        if os.path.isfile(filename):
            os.remove(filename)
        with open(filename, 'w') as scriptfile:
            scriptfile.write('#!/bin/bash\n\n')
            scriptfile.writelines([ 'sleep_time=$((5 + RANDOM % 11))',
                                    # 'export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase \n',
                                    # 'source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh \n',
                                    # 'export RUCIO_ACCOUNT=$USER \n',
                                    # 'asetup AthGeneration,21.6.105 \n',
                                    'sleep $sleep_time \n',
                                    ])
            
            scriptfile.writelines(['# run POWHEG process ' + str(process_name) + ' batch number ' + str(batch) + '\n',
                                    'cd ' + str(os.path.abspath(process)) + '\n'])
            if decay == True:
                scriptfile.writelines(['echo pwgevents-' + str(batch).zfill(4) + '.lhe | ./lhef_decay\n',
                                        'echo "</LesHouchesEvents>" | gzip - | cat - >> pwgevents-' + str(batch).zfill(4) + '-decayed.lhe \n'])
                
            else:
                scriptfile.writelines(['echo ' + str(batch) + ' | ./../pwhg_main-gnu \n'])                
                
        print(('created scripts for POWHEG process ' + process_name))
        status = os.stat(filename)
        os.chmod(filename, status.st_mode | stat.S_IEXEC)
                
