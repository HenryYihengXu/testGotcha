#!/bin/bash
### LSF syntax
#BSUB -nnodes 1                   #number of nodes
#BSUB -W 1                        #walltime in minutes
#BSUB -e myerrors.txt             #stderr
#BSUB -o myoutput.txt             #stdout
#BSUB -J myjob                    #name of job
#BSUB -q pbatch                   #queue to use
#BSUB -stage "storage=2"

echo $PATH
printf "111111111\n\n"
echo $BBPATH
printf "222222222\n\n"
date
hostname

