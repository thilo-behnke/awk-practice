# Look for time between errors in adapted log file from: https://de.wikipedia.org/wiki/Logdatei 

BEGIN {
	print "TIME BETWEEN ERRORS"
	print "==================="
	cnt = -1
	last_error_time = 0
}

# Pre processing
{
	gsub(/\(/, "", $0);
	gsub(/\)/, "", $0);
	$1 = $1 " " $2 " " $3 " " $4 " " $5;
	$2 = $3 = $4 = $5 = ""
}

{
	OFS = FS;
	command="date -d " "\047"$1"\047" " +%s";
	command | getline $1;
	close(command);
}

/\[ERROR\]/ {
	cnt++
	error_time = last_error_time
	last_error_time = $1
	if (error_time == 0) { 
		print cnt ") " $1 " No previous ERROR"
		printMessage($7)
		next
	}
	error_diff = $1 - error_time
	print cnt ") " $1 " ERROR time diff: " error_diff " (" error_time " -> " last_error_time ")"
	printMessage($7)
}

function printMessage(msg) {
	str = ""
	for (i = 7; i <= NF; i++) {
		str = str " " $i
	}
	print "   -> " str
}


