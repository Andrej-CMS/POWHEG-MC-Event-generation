
workFolder=${PWD}

PDFs=( $(seq 27100 27164) )
echo ${PDFs[@]}
for pdf in  ${PDFs[@]}; do
	# "y\ny\n11\n" y- change seeds, y- sure, stage 11, 12, 13, 14, 15, 2, 31
	# if stage is 11, the first two yes are not necessary
	# python submit_handler.py N-jobs, path ttbarj, mass top, LHA PDF NUMBER, muR factor, muF factor
	python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 ${pdf} 1.0 1.0 < stageInput.txt
	sleep 1
	cd ${workFolder}
done

MASSES=( 166.0 167.0 168.0 169.0 170.0 171.0 172.0 173.0 174.0 175.0 176.0 177.0 178.0 179.0 )

for mass in  ${MASSES[@]}; do
	# "y\ny\n11\n" y- change seeds, y- sure, stage 11, 12, 13, 14, 15, 2, 31
	# if stage is 11, the first two yes are not necessary
	# python submit_handler.py N-jobs, path ttbarj, mass top, LHA PDF NUMBER, muR factor, muF factor
	python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj ${mass} 27100 1.0 1.0 < stageInput.txt
	sleep 1
	cd ${workFolder}
done

# # scale variations

python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 27100 0.5 1.0 < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 27100 2.0 1.0 < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 27100 1.0 0.5 < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 27100 1.0 2.0 < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 27100 2.0 2.0 < stageInput.txt
sleep 1
cd ${workFolder}
python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 27100 0.5 0.5 < stageInput.txt
sleep 1
cd ${workFolder}

#alphaS variations
# MSHT20nlo_as120 has only one alpha_S variation
python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 27200 1.0 1.0 < stageInput.txt
sleep 1
#cd ${workFolder}
## ABMP16NLOals_0117
#python submit_handler.py 48 /storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/ttbarj 172.5 43080 1.0 1.0 < stageInput.txt
#sleep 1
#cd ${workFolder}

