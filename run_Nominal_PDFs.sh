workFolder=${PWD}

# # NNPDF30 hessian
# python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 1.0 1.0 < stageInput.txt

# cd ${workFolder}

# CT18NLO

python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 14400 1.0 1.0 < stageInput.txt

cd ${workFolder}


# MSHT20nlo_as118

python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 27100 1.0 1.0 < stageInput.txt

cd ${workFolder}

# ABMP16_5_nlo 
python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 42960 1.0 1.0 < stageInput.txt

cd ${workFolder}

#NNPDF40_nlo_as_01180 
python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 331700 1.0 1.0 < stageInput.txt

cd ${workFolder}
