set terminal png transparent size 640,240
set size 1.0,1.0

set terminal png transparent size 640,480
set output 'lines_of_code_by_author.png'
set key left top
set yrange [0:]
set xdata time
set timefmt "%s"
set format x "%Y-%m-%d"
set grid y
set ylabel "Lines"
set xtics rotate
set bmargin 6
plot 'lines_of_code_by_author.dat' using 1:2 title "Matthew Hampton" w lines, 'lines_of_code_by_author.dat' using 1:3 title "Samuel Abels" w lines, 'lines_of_code_by_author.dat' using 1:4 title "Ziad Sawalha" w lines, 'lines_of_code_by_author.dat' using 1:5 title "matthewhampton" w lines, 'lines_of_code_by_author.dat' using 1:6 title "Daniel Axtens" w lines, 'lines_of_code_by_author.dat' using 1:7 title "knipknap" w lines, 'lines_of_code_by_author.dat' using 1:8 title "Samuel" w lines, 'lines_of_code_by_author.dat' using 1:9 title "Evren Esat Özkan" w lines, 'lines_of_code_by_author.dat' using 1:10 title "Filipe Correia" w lines, 'lines_of_code_by_author.dat' using 1:11 title "Antti Haapala" w lines, 'lines_of_code_by_author.dat' using 1:12 title "Jose Plana" w lines, 'lines_of_code_by_author.dat' using 1:13 title "Randall Burt" w lines, 'lines_of_code_by_author.dat' using 1:14 title "Xavier Ordoquy" w lines, 'lines_of_code_by_author.dat' using 1:15 title "Benjamin Roberts" w lines, 'lines_of_code_by_author.dat' using 1:16 title "(no author)" w lines
