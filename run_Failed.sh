
workFolder=${PWD}
# # scale variations

#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 0.5 1.0 < stageInput.txt
#sleep 1
#cd ${workFolder}
#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 2.0 1.0 < stageInput.txt
#sleep 1
#cd ${workFolder}
#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 1.0 0.5 < stageInput.txt
#sleep 1
#cd ${workFolder}
#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 1.0 2.0 < stageInput.txt
#sleep 1
#cd ${workFolder}
#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 2.0 2.0 < stageInput.txt
#sleep 1
#cd ${workFolder}
#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 0.5 0.5 < stageInput.txt
#sleep 1
#cd ${workFolder}

#alphaS variations
# NNPDF30_nlo_as_0119
#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 266000 1.0 1.0 < stageInput.txt
#sleep 1
#cd ${workFolder}
# NNPDF30_nlo_as_0117
#python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 265000 1.0 1.0 < stageInput.txt
#sleep 1
cd ${workFolder}
python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303023 1.0 1.0 < stageInput.txt
cd ${workFolder}
