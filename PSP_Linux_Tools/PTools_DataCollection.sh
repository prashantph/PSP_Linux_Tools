#! /bin/bash

if [ -z "$1" ]
  then
    echo "Usage: ./PTools_DataCollection.sh -t CollectionTime(in seconds), -l list of tools to be run"
    echo " tools supported lpcpu, 24x7, perf"
fi

#setup the dependencies 
./prereq_setup.sh

while [ -n "$1" ]
do
 key="$1"

      case $key in
        -t)
          DURATION="$2"
	  echo $2
          ;;
	-l)
	  echo "list of perf tools"
	  shift
	  tool_list=( "$@" )
	  echo ${tool_list[@]}		
	  echo $#
        esac
	shift 
done

HOST=`hostname`
timestamp=`date +%Y%m%d%H%M`
OUTPUT_DIR=${HOST}_${timestamp}
mkdir $OUTPUT_DIR
DURATION_IN_MINS=`echo $((DURATION/60))`
SAMPLES=`echo $((DURATION/10))`
CURR_PATH=`pwd`
perf_run="no"
install_run_lpcpu () {
	if [ -d "$CURR_PATH/lpcpu" ];
	then
        	echo "lpcpu tool availabe...."
	else
        	echo "lpcpu tool not available !!!"
		echo "Downloading the package...."
        	git clone  https://github.com/open-power-sdk/lpcpu

	fi
	echo "Started lpcpu"
	date >> $CURR_PATH/$OUTPUT_DIR/PTool.log
	./lpcpu/lpcpu.sh duration=$DURATION output_dir=$OUTPUT_DIR >> $OUTPUT_DIR/PTool.log & 2>&1		
}


install_run_perf () {
	echo "Started perf recording"
	date >> $CURR_PATH/$OUTPUT_DIR/PTool.log
	./perf.sh $DURATION_IN_MINS $OUTPUT_DIR  &
	perf_run="yes"
}
	
install_run_24x7 () {
	if [ -d "$CURR_PATH/Process24x7" ];
	then
        	echo "Unpacking 24x7 tool...."
        	tar -xf Process24x7.tar
	else
        	echo "24x7 tool not available .. Kindly download the package"
        	wget http://pdat1.aus.stglabs.ibm.com:8080/nest10/Process24x7/Process24x7.tar
        	tar -xf Process24x7.tar
	fi
	echo "Collecting 24x7"
	Process24x7/collectData.sh -i $SAMPLES -t 10 -o $OUTPUT_DIR/BW.out  >> $OUTPUT_DIR/PTool.log & 2>&1
}

echo "Data collection begins . . ."
echo "++++++++++++++++++++++++++++++"

for i in "${tool_list[@]}"
do 
	if [ $i == "perf" ]
	then 
		install_run_perf

	elif [ $i == "lpcpu" ]
	then 
		install_run_lpcpu

	elif  [ $i == "24x7" ]
        then
		install_run_24x7	
	else
		echo "$i is not supported "
	fi
done


#echo "Starting faststat pmu"
#date >> $CURR_PATH/$OUTPUT_DIR/PTool.log
#cd $CURR_PATH/faststatcollect; ./runit.sh -d $DURATION_IN_MINS -o $CURR_PATH/$OUTPUT_DIR &
#PMUPID=$!

echo "++++++++++++++++++++++++++++++"
echo "Sleeping $DURATION seconds . . ."
sleep $DURATION
sleep 60
#wait $PMUPID

echo "Processing data . . ."

date >> $CURR_PATH/$OUTPUT_DIR/Ptool.log
cd $CURR_PATH/$OUTPUT_DIR
if [ $perf_run == "yes" ]
then 
	for i in perf.raw*
	do
		perf report -n --no-children --sort=dso,symbol -i $i > ${i}.report
	done
fi
echo "Packaging data . . ."
cd $CURR_PATH
tar -cvjf ${OUTPUT_DIR}.tar.bz2 $OUTPUT_DIR > PTool.log 2>&1
echo "======>> ${OUTPUT_DIR}.tar.bz2  "
echo "Done"
