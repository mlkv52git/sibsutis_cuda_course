#!/bin/sh

#PBS -q teslaq
#PBS -l walltime=0:01:00
#PBS -l select=1:ngpus=2:ncpus=1:mem=16gb

cd $PBS_O_WORKDIR
vnodes=$(qstat -f $PBS_JOBID|tr -d '\n'' ''\t'|sed 's/Hold_Types.*//'|sed 's/.*exec_vnode=//'|tr -d \(\)|tr + '\n'|sed 's/:.*//'|sort)
echo "My vnodes:"
for vnode in $vnodes ; do
    node=$(echo $vnode|sed 's/\[.*//')
    gpu=$(echo $vnode|sed 's/.*\[//'|sed 's/\]//')
    echo "$vnode = Node $node, GPU $gpu"
    gpus=$(echo  $gpus  $gpu)
done
echo "GPUS: $gpus"

export PATH=$PATH:/opt/shared/nvidia/cuda/bin
export LD_LIBRARY_PATH=/opt/shared/nvidia/cuda/lib64:/opt/shared/nvidia/cuda/lib:$LD_LIBRARY_PATH

./transMD_MT  $gpus
