#Anode selector
ghdl -a *.vhd
ghdl -e anode_selector_tb
ghdl -r anode_selector_tb --vcd=out.vcd --stop-time=20us
#gtkwave out.vcd
rm out.vcd

#Bcd counter
ghdl -a *.vhd
ghdl -e bcd_counter_tb
ghdl -r bcd_counter_tb --vcd=out.vcd --stop-time=20us
#gtkwave out.vcd
rm out.vcd

#Generic counter
ghdl -a *.vhd
ghdl -e generic_counter_tb
ghdl -r generic_counter_tb --vcd=out.vcd --stop-time=20us
#gtkwave out.vcd
rm out.vcd

#Generic counter
ghdl -a *.vhd
ghdl -e generic_enabler_tb
ghdl -r generic_enabler_tb --vcd=out.vcd --stop-time=20us
gtkwave out.vcd
rm out.vcd
