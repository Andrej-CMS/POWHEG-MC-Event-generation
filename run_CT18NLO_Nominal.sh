
workFolder=${PWD}

python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 14400 1.0 1.0 < stageInput.txt
sleep 1
cd ${workFolder}
