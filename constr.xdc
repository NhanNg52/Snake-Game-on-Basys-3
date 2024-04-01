#BUTTONS
set_property PACKAGE_PIN U18 [get_ports BTNC]
    set_property IOSTANDARD LVCMOS33 [get_ports BTNC]
#set_property PACKAGE_PIN W19 [get_ports BTNL]
#    set_property IOSTANDARD LVCMOS33 [get_ports BTNL]
#set_property PACKAGE_PIN U17 [get_ports BTND]
#    set_property IOSTANDARD LVCMOS33 [get_ports BTND]
#set_property PACKAGE_PIN T17 [get_ports BTNR]
#    set_property IOSTANDARD LVCMOS33 [get_ports BTNR]
#set_property PACKAGE_PIN T18 [get_ports BTNU]
#    set_property IOSTANDARD LVCMOS33 [get_ports BTNU]
#set_property PACKAGE_PIN R2 [get_ports GAME_IN]
#    set_property IOSTANDARD LVCMOS33 [get_ports GAME_IN]

#RESET    
set_property PACKAGE_PIN T17 [get_ports RESET]
    set_property IOSTANDARD LVCMOS33 [get_ports RESET]

##7-SEGMENT DISPLAY    
#set_property PACKAGE_PIN U2 [get_ports {SEG_SELECT_OUT[3]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[3]}]
        
#set_property PACKAGE_PIN U4 [get_ports {SEG_SELECT_OUT[2]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[2]}]
    
#set_property PACKAGE_PIN V4 [get_ports {SEG_SELECT_OUT[1]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[1]}]
            
#set_property PACKAGE_PIN W4 [get_ports {SEG_SELECT_OUT[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[0]}]
    
#set_property PACKAGE_PIN W7 [get_ports {DEC_OUT[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[0]}]
            
#set_property PACKAGE_PIN W6 [get_ports {DEC_OUT[1]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[1]}]
    
#set_property PACKAGE_PIN U8 [get_ports {DEC_OUT[2]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[2]}]
                
#set_property PACKAGE_PIN V8 [get_ports {DEC_OUT[3]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[3]}]
    
#set_property PACKAGE_PIN U5 [get_ports {DEC_OUT[4]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[4]}]
                
#set_property PACKAGE_PIN V5 [get_ports {DEC_OUT[5]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[5]}]
    
#set_property PACKAGE_PIN U7 [get_ports {DEC_OUT[6]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[6]}]
                
#set_property PACKAGE_PIN V7 [get_ports {DEC_OUT[7]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[7]}]

#VGA
set_property PACKAGE_PIN G19 [get_ports {COLOUR_OUT[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[0]}]
    
set_property PACKAGE_PIN H19 [get_ports {COLOUR_OUT[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[1]}]
    
set_property PACKAGE_PIN J19 [get_ports {COLOUR_OUT[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[2]}]
    
set_property PACKAGE_PIN N19 [get_ports {COLOUR_OUT[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[3]}]
set_property PACKAGE_PIN J17 [get_ports {COLOUR_OUT[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[4]}]
    
set_property PACKAGE_PIN H17 [get_ports {COLOUR_OUT[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[5]}]
    
set_property PACKAGE_PIN G17 [get_ports {COLOUR_OUT[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[6]}]
    
set_property PACKAGE_PIN D17 [get_ports {COLOUR_OUT[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[7]}]
    
set_property PACKAGE_PIN N18 [get_ports {COLOUR_OUT[8]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[8]}]
    
set_property PACKAGE_PIN L18 [get_ports {COLOUR_OUT[9]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[9]}]
    
set_property PACKAGE_PIN K18 [get_ports {COLOUR_OUT[10]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[10]}]
    
set_property PACKAGE_PIN J18 [get_ports {COLOUR_OUT[11]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[11]}]
    
set_property PACKAGE_PIN P19 [get_ports HS]
    set_property IOSTANDARD LVCMOS33 [get_ports HS]
    
set_property PACKAGE_PIN R19 [get_ports VS]
    set_property IOSTANDARD LVCMOS33 [get_ports VS]     

#CLOCK
set_property PACKAGE_PIN W5 [get_ports CLK]
    set_property IOSTANDARD LVCMOS33 [get_ports CLK]

# LEDs
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]

##Pmod Header JB
set_property PACKAGE_PIN A14 [get_ports {SS}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {SS}]
set_property PACKAGE_PIN A16 [get_ports {MOSI}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {MOSI}]
set_property PACKAGE_PIN B15 [get_ports {MISO}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {MISO}]
set_property PACKAGE_PIN B16 [get_ports {SCLK}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {SCLK}]

