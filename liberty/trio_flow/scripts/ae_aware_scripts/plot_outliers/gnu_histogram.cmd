
set terminal png
set output "./TYPE_pcntg_error_hist.png"
   
set xlabel "Data points"
set ylabel "Freq"
set title "Histogram of data"

min = MINIMUM
max = MAXIMUM
n=500
width = (max - min)/n

hist(x,width) = width/2 + width*floor(x/width)
   
set size sq

plot "G_VS_A_DELAY_DAT" u (hist($4,width)):(1.0) smooth freq w boxes lc rgb "red"  title "delay", \
     "G_VS_A_TRANS_DAT" u (hist($4,width)):(1.0) smooth freq w boxes lc rgb "blue" title "trans"

