
workFolder=${PWD}

PDFs=( $(seq 303000 303100)  ) 
echo ${PDFs[@]}
for pdf in  ${PDFs[@]}; do
	# "y\ny\n11\n" y- change seeds, y- sure, stage 11, 12, 13, 14, 15, 2, 31
	# if stage is 11, the first two yes are not necessary
	# python submit_handler.py N-jobs, path ttbarj, mass top, LHA PDF NUMBER, muR factor, muF factor
	python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 ${pdf} 1.0 1.0 "HTCondor" < stageInput.txt
	sleep 1
	cd ${workFolder}
done

MASSES=( 166.0 167.0 168.0 169.0 170.0 171.0 172.0 173.0 174.0 175.0 176.0 177.0 178.0 179.0 )

for mass in  ${MASSES[@]}; do
	# "y\ny\n11\n" y- change seeds, y- sure, stage 11, 12, 13, 14, 15, 2, 31
	# if stage is 11, the first two yes are not necessary
	# python submit_handler.py N-jobs, path ttbarj, mass top, LHA PDF NUMBER, muR factor, muF factor
	python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj ${mass} 303000 1.0 1.0 "HTCondor" < stageInput.txt
	sleep 1
	cd ${workFolder}
done


# # scale variations

python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 303000 0.5 1.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 303000 2.0 1.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 303000 1.0 0.5 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 303000 1.0 2.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 303000 2.0 2.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 303000 0.5 0.5 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}

#alphaS variations
# CT18NLO_as_0119
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 266000 1.0 1.0 "HTCondor" < stageInput.txt
sleep 1
# cd ${workFolder}
# # CT18NLO_as_0117
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 265000 1.0 1.0 "HTCondor" < stageInput.txt
sleep 1
# cd ${workFolder}

