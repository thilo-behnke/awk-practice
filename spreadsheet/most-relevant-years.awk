# https://en.wikipedia.org/wiki/List_of_best-selling_video_games

BEGIN {
	print "YEARS SORTED BY COUNT OF BEST SELLING VIDEO GAMES"
	print "================================================="
	FPAT = "([^,]+)|(\"[^\"]+\")"
	OFS = "__"
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
	# Corrupt list, entries at the same rank are missing the rank field -> get it from the last entry.
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
	# Change field delimiter to __
	for (i = 0; i <= NF; i++) {
		$i = $i
	}
}

# Group by year
{
	if (match($8, /^"[^,]+,\s([0-9]{4})/, m)) {
		year = m[1] 
		if (by_year[year] == "") {
			by_year[year] = $0 
		} else {
			by_year[year] = by_year[year] ";;" $0
		}
	}
}

END {
	PROCINFO["sorted_in"] = "cmp_by_entries"
	for (year in by_year) {
		PROCINFO["sorted_in"] = "@unsorted"
		split(by_year[year], by_year_entries, ";;")

		total_units_sold = 0
		for (entry in by_year_entries) {
			split(by_year_entries[entry], year_data, "__")
			gsub("\"", "", year_data[3])
			gsub(",", "", year_data[3])
			total_units_sold += year_data[3] 
		}
		
		stats = length(by_year_entries) " bestsellers with " total_units_sold " total units sold"
		print "year " year ": " stats

		for (entry in by_year_entries) {
			split(by_year_entries[entry], year_data, "__")
			gsub("^\"", "<", year_data[3])
			gsub("\"$", ">", year_data[3])
			print " - " year_data[2] " at rank " year_data[1] " sold " year_data[3] " units"
		}
		print ""
	}
	print "================================================"
	print "PROCESSED " NR " NR OF LINES FOR THIS REPORT"
}

function cmp_by_entries(i1, v1, i2, v2) {
	n1 = split(v1, arr1, ";;")
	n2 = split(v2, arr2, ";;")
	if (n1 < n2) {
		return 1 
	}
	if (n2 > n1) {
		return -1 
	}
	return 0
}
