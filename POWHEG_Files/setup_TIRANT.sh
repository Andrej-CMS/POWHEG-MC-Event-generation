module load gcc/8.1.0
module load openmpi/3.1.1

export LHAPDF_PATH=/storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/LHAPDF-6.5.3
export PATH=$PATH:$LHAPDF_PATH/installDir/bin:/storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/fastjet-install/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LHAPDF_PATH/installDir/lib
export PYTHONPATH=$PYTHONPATH:$LHAPDF_PATH/installDir/lib/python3.9/site-packages
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/storage/home/vlc40/vlc40476/PowhegProduction/POWHEG-BOX-V2/fastjet-install/lib:$LHAPDF_PATH/installDir/lib
