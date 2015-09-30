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
plot 'lines_of_code_by_author.dat' using 1:2 title "Evren Esat Özkan" w lines, 'lines_of_code_by_author.dat' using 1:3 title "dyrnade" w lines, 'lines_of_code_by_author.dat' using 1:4 title "Ali Riza Keles" w lines, 'lines_of_code_by_author.dat' using 1:5 title "Ozgur Firat Cinar" w lines, 'lines_of_code_by_author.dat' using 1:6 title "Evren Kutar" w lines, 'lines_of_code_by_author.dat' using 1:7 title "Gokhan Boranalp" w lines, 'lines_of_code_by_author.dat' using 1:8 title "bahadr" w lines, 'lines_of_code_by_author.dat' using 1:9 title "fjzach" w lines, 'lines_of_code_by_author.dat' using 1:10 title "tolabey" w lines, 'lines_of_code_by_author.dat' using 1:11 title "geallen" w lines, 'lines_of_code_by_author.dat' using 1:12 title "bahadrr" w lines, 'lines_of_code_by_author.dat' using 1:13 title "Ozgur" w lines, 'lines_of_code_by_author.dat' using 1:14 title "cemg" w lines, 'lines_of_code_by_author.dat' using 1:15 title "cem" w lines, 'lines_of_code_by_author.dat' using 1:16 title "alirizakeles" w lines, 'lines_of_code_by_author.dat' using 1:17 title "The Gitter Badger" w lines
