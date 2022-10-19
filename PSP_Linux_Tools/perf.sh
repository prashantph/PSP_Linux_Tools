DURATION_IN_MINS=$1
OUTPUT_DIR=$2

cat /proc/kallsyms > $OUTPUT_DIR/kallsymps.raw
sleep 10
if [[ $DURATION_IN_MINS -ge 4 ]]
then
	COUNT=1
	MAXCOUNT=2
	REST=60
	while [[ $COUNT -le $MAXCOUNT ]]
	do
		perf record -a -e cycles  -c 10000000 -o $OUTPUT_DIR/perf.raw_${COUNT} sleep 20
		sleep 30
		perf record -a -g -c 10000000 -o $OUTPUT_DIR/perf.raw.callgraph.dat_${COUNT} sleep 20
		sleep $REST
		((COUNT+=1))
	done

else
	perf record -a -e cycles  -c 10000000 -o $OUTPUT_DIR/perf.raw sleep 20
	sleep 10
	perf record -a -g -c 10000000 -o $OUTPUT_DIR/perf.raw.callgraph.dat sleep 20
fi
