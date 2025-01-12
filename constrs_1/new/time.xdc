#create_clock -period 5.000 -name clk200m -waveform {0.000 2.500} -add [get_ports sclk]
#set_clock_groups -name group_200m -asynchronous -group [get_clocks clk200m]
