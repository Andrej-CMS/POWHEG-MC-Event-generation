
workFolder=${PWD}

# NNPDF30 hessian
python submit_handler.py 48 ../POWHEG-BOX-V2/ttbarj/ 172.5 303000 1.0 1.0 < stageInput.txt

cd ${workFolder}

