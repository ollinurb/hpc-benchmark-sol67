#!/bin/bash

TARGET=""
CUSTOM=false
MAX_NODES=""
SUBMIT_FILE=""

show_help() {
    echo "Usage: $0 -t <target>"
    echo
    echo "Options:"
    echo "  -t <target>       Specify the target application (e.g., vasp)"
    echo "                    Currently the only option is vasp."
    echo
    echo "                    If you want to specify an option not present,"
    echo "                    use -c <binary> with the name of the program used "
    echo "                    in the mpirun command."
    echo
    echo "                    For example, if your command is:"
    echo "                    mpirun -n 24 lmp "
    echo 
    echo "                    Then use $0 -c lmp"
    echo
    echo "  -c <target>       Specify custom target application"
    echo
    echo "  -n <max nodes>    Specify the max amount of nodes "
    echo "                    the benchmark will use."
    echo    
    echo "  --help            Display this help message"
    echo
    echo "Examples:"
    echo "  $0 -t vasp -n 4   Run the script for VASP configuration"
    exit 0
}

delete_test_directories() {
    if [ -d "nodes" ]; then
        rm -r "nodes"
    fi
}

create_dirs() {
mkdir nodes
for i in $(seq 1 $MAX_NODES); do
    cp -r template nodes/$i
done
}

find_template_dir() {
	if [ ! -d "template" ]; then
		echo "ERROR:"
		echo "No template directory found! Make sure the base case for simulation "
		echo "is present on a directory named 'template' with all its input files "
		echo "and the submit file (eg VASP: template/INCAR template/POTCAR ...).  "
		echo
		echo "Please fix and try again."
		exit 
	fi
}

find_submit_file() {
	HITS=$(grep -lr "#PBS" template/ | wc -l)
	
	if [ $HITS -eq 0 ]; then
		echo "No PBS submit script was found."
		exit 1
	elif [ $HITS -eq 1 ]; then
		SUBMIT_FILE=$(basename "$(grep -lr "#PBS" template)")

	elif [ $HITS -gt 1 ]; then
		echo "There are many script files, please indicate which one to use, then hit [ENTER]"
		mapfile -t FILES < <(grep -lr "#PBS" template/)

		for i in "${!FILES[@]}"; do
                    echo "$((i + 1))) ${FILES[i]}"
                done
		read FILE_INDEX

		if [[ FILE_INDEX -gt ${#FILES[@]} || FILE_INDEX -lt 1 ]]; then
			echo "wrong index!"
			exit 1
		fi
		SUBMIT_FILE=$(basename ${FILES[FILE_INDEX-1]}) 
	fi
}

update_test_case() {
    NODES=$1
    CORES=$2
    sed -i "/mpirun /s/mpirun .* $TARGET/mpirun -n $CORES --bind-to node --map-by core --report-bindings $TARGET/g" "nodes/$NODES/$SUBMIT_FILE"
    sed -i "s/#PBS -l .*/#PBS -l nodes=$NODES:ppn=24:nomem128:c48:ib/g" "nodes/$NODES/$SUBMIT_FILE"
    sed -i "s|#PBS -N \(.*\)|#PBS -N ${NODES}_\1|g" "nodes/$NODES/$SUBMIT_FILE"


}	

attach_submit_file_sendscript() {
   sed -i "s/SUBMIT_FILE=.*/SUBMIT_FILE=$SUBMIT_FILE/g" "send_jobs.sh" 
}

update_node() {
    cores_per_node=24
    for node_amount in $(seq 1 $MAX_NODES); do
       update_test_case $node_amount $cores_per_node
       cores_per_node=$(($cores_per_node + 24))
    done
}

# Check for --help before parsing options
if [[ "$1" == "--help" ]]; then
    show_help
fi

while getopts "t:c:n:" opt; do
    case "$opt" in
        t) TARGET="$OPTARG" ;;
	c) CUSTOM=true; TARGET="$OPTARG" ;;
	n) MAX_NODES=$OPTARG ;;
        *) echo "Usage: $0 -t <target>"; exit 1 ;;
    esac
done

find_template_dir
delete_test_directories
create_dirs
find_submit_file
attach_submit_file_sendscript

if [[ "$TARGET" == "vasp" ]]; then    
    update_node
elif [[ $CUSTOM == true ]]; then
    echo "beware using the custom options, things might break easier."    
    update_node
else
    echo "Unknown options used."
    echo "Plase run $0 --help"
    exit 1
fi
