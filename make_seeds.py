'''
Create the seed file pwgseeds.dat for a given number of batches and given processes, which is needed for running POWHEG with the manyseedsflag 
'''



import sys
import os, shutil
import random
import string


def make_seeds (nbatches, process, initial_process):

        useSameSeedsForAll = True
    
        # loop over all given process in the arguments
        process = os.path.abspath(process)
        initial_process = os.path.abspath(initial_process)
        # check if given argument is a process directory in POWHEG-BOX-V2
        if 'POWHEG' not in os.path.dirname(process):
            print(('Argument ' + str(process) + ' is not a POWHEG process directory' + '\njob aborted'))
            return
        # if it works go to process directory and write the seed file
        work_dir = os.getcwd()
        os.chdir(os.path.abspath(process))
        
        # make the seedfile, if already a seedfile exists, rename it and make a new one afterwards
        seedfile = ""
        if useSameSeedsForAll:
            seedfile = os.path.join(initial_process, "pwgseeds.dat")
        else:
            seedfile = os.path.join(process, "pwgseeds.dat")
        
        if os.path.exists(os.path.abspath(seedfile)):
            print ("The seedfile pwgseeds.dat alread exists. Do you want to overwrite it?")
            confirmation = input("y/n ")
            if any(confirmation == x for x in ["y","Y","yes","Yes", "YES"]):
                print ("are you sure?")
                confirmation = input("y/n ")
                if any(confirmation == x for x in ["y","Y","yes","Yes", "YES"]):
                    print ("Overwriting pwgseeds.dat")
                else:
                    print ("Keeping old pwgseeds.dat" )
                    os.chdir(work_dir)
                    return
            else:
                print ("Keeping old pwgseeds.dat")
                if useSameSeedsForAll:
                    source = seedfile
                    destination = os.path.join(process, "pwgseeds.dat")
                    shutil.copyfile(source, destination)
                else:
                    os.chdir(work_dir)
                return

        if useSameSeedsForAll:
            seedfile_old = os.path.join(initial_process, "old_pwgseeds.dat")
        else:
            seedfile_old = os.path.join(process, "old_pwgseeds.dat")

        if os.path.isfile(os.path.abspath(seedfile)):
            if os.path.exists(seedfile_old):
                os.remove(seedfile_old)
            os.rename(seedfile, seedfile_old)
        with open(seedfile, 'w') as textfile:
            for i in range(nbatches):
                textfile.write(str(random.randint(0, 99999999))+'\n')

        destination = os.path.join(process, "pwgseeds.dat")
        shutil.copyfile(seedfile, destination)
        os.chdir(work_dir)
    
    
    
