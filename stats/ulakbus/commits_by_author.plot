set terminal png transparent size 640,240
set size 1.0,1.0

set terminal png transparent size 640,480
set output 'commits_by_author.png'
set key left top
set yrange [0:]
set xdata time
set timefmt "%s"
set format x "%Y-%m-%d"
set grid y
set ylabel "Commits"
set xtics rotate
set bmargin 6
plot 'commits_by_author.dat' using 1:2 title "Evren Esat Özkan" w lines, 'commits_by_author.dat' using 1:3 title "dyrnade" w lines, 'commits_by_author.dat' using 1:4 title "Ali Riza Keles" w lines, 'commits_by_author.dat' using 1:5 title "Ozgur Firat Cinar" w lines, 'commits_by_author.dat' using 1:6 title "Evren Kutar" w lines, 'commits_by_author.dat' using 1:7 title "Gokhan Boranalp" w lines, 'commits_by_author.dat' using 1:8 title "bahadr" w lines, 'commits_by_author.dat' using 1:9 title "fjzach" w lines, 'commits_by_author.dat' using 1:10 title "tolabey" w lines, 'commits_by_author.dat' using 1:11 title "geallen" w lines, 'commits_by_author.dat' using 1:12 title "bahadrr" w lines, 'commits_by_author.dat' using 1:13 title "Ozgur" w lines, 'commits_by_author.dat' using 1:14 title "cemg" w lines, 'commits_by_author.dat' using 1:15 title "cem" w lines, 'commits_by_author.dat' using 1:16 title "alirizakeles" w lines, 'commits_by_author.dat' using 1:17 title "The Gitter Badger" w lines
