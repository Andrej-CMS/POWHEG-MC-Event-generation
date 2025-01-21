
workFolder=${PWD}

python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 14400 1.0 1.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
