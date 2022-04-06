# https://en.wikipedia.org/wiki/List_of_best-selling_video_games

BEGIN {
	print "YEARS SORTED BY COUNT OF BEST SELLING VIDEO GAMES"
	print "================================================="
	FPAT = "([^,]+)|(\"[^\"]+\")"
	OFS = ","
	last_rank = 1
}

# pre processing
{
	gsub(/<span[^>]+>/, "", $0)
}
{
	# header
	if (NR == 1) {
		next
	}
	# empty line
	if ($0 ~ /^\s*$/) {
		next
	}
}
{
	rank = $1
	if ($1 !~ /^[0-9]+\s*$/) {
		last_value = $1
		for (i = 2; i <= NF; i++) {
			tmp = $i
			$i = last_value 
			last_value = tmp
		}
		$1 = last_rank
		rank = $1
	}
	last_rank = rank 
}

{
	if (match($8, /^"[^,]+,\s([0-9]{4})/, m)) {
		year = m[1] 
		if (by_year[year] == "") {
			by_year[year] = " - " $0 
		} else {
			by_year[year] = by_year[year] "\n - " $0
		}
	}
}


END {
	PROCINFO["sorted_in"] = "@ind_str_asc"
	for (key in by_year) {
		print ""
		print key "::"
		print by_year[key]
	}
	print "================================================"
	print "PROCESSED " NR " NR OF LINES FOR THIS REPORT"
}
