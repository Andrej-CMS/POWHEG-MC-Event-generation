
workFolder=${PWD}

PDFs=( $(seq 93300 93342) )
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
	python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj ${mass} 93300 1.0 1.0 "HTCondor" < stageInput.txt
	sleep 1
	cd ${workFolder}
done

# # scale variations

python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 93300 0.5 1.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 93300 2.0 1.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 93300 1.0 0.5 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 93300 1.0 2.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 93300 2.0 2.0 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 93300 0.5 0.5 "HTCondor" < stageInput.txt
sleep 1
cd ${workFolder}

##alphaS variations
## ABMP16NLOals_0119
#python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 43140 1.0 1.0 < stageInput.txt
#sleep 1
#cd ${workFolder}
## ABMP16NLOals_0117
#python submit_handler.py 48 /eos/user/a/asaibel/PowhegTTbarj/POWHEG-BOX-V2/ttbarj 172.5 43080 1.0 1.0 < stageInput.txt
#sleep 1
#cd ${workFolder}

