set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.00 [get_ports clk]

set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports enable]

set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports reset]; # BTNU
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports response_btn]; # BTNC
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports ready_btn]; # BTNR
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports restart_btn]; # BTNL

set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports trigger_led]

set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {ssd_anode[3]}]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {ssd_anode[2]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {ssd_anode[1]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {ssd_anode[0]}]

set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[7]}]
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[6]}]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[5]}]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[4]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[3]}]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[2]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[1]}]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports {ssd_cathode[0]}]
