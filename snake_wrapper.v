`timescale 1ns / 1ps

 
// Dependencies: -random_num_gen.v
//               -VGA_module.v
//               -Score_counter(wrapper_new.v)
//               -Snake_control.v
//               -Master_state_machine.v
//               -Navigation_state_machine.v
//
// Additional Comments: HOW TO PLAY
/////////////////////// To start the game, Right, Left, Down or Up button should be pressed.
/////////////////////// In order to choose timed game mode, SW15 should be set in the ON position.
/////////////////////// Once the game is finished, use SW0 to restart the game (do not forget to 
/////////////////////// set bach to the OFF position once the start screen appears).
///////////////////////
/////////////////////// CONTROLS
/////////////////////// UP, DOWN, RIGHT, LEFT - joystick on Ja
/////////////////////// RESTART               - BTNR
/////////////////////// START                 - BTNC
/////////////////////// TIMED MODE            - SW15
/////////////////////// 
/////////////////////// TIMED GAME MODE
/////////////////////// In this mode player has 60 seconds to eat 10 targets.
/////////////////////// If the time is up, game is over.
/////////////////////// To exit this game mode, set the SW15 switch to the OFF position
/////////////////////// when in the starting screen.


module snake_wrapper(
    input CLK,
    input RESET,
    input BTNC,
    input MISO,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    output SS,
    output MOSI,
    output SCLK,
    output [3:0] LED 
);

    // Connections between the modules
    wire [1:0] MSM_STATE;
    wire [1:0] NAV_STATE;
    
    wire [7:0] TARGET_ADDR_H;
    wire [6:0] TARGET_ADDR_V;
    
    wire TARGET_REACHED;
    wire LOST;
    
    wire [11:0] COLOUR_OUTS;
    
    wire [9:0] ADDRH;
    wire [8:0] ADDRV;
    
    wire Timed_Mode;
    
    wire BTNU;
    wire BTND;
    wire BTNL;
    wire BTNR;
    
    //Instantiating Master state machine
    Master_state_machine Master(
        .BTNC(BTNC),
        .CLK(CLK),
        .RESET(RESET),
        .LOST(LOST),
        .MSM_STATE(MSM_STATE)
    );
                            
    // Instantiating navigation system                        
    Navigation_state_machine Navigation(
        .BTNU(BTNU),
        .BTND(BTND),
        .BTNR(BTNR),
        .BTNL(BTNL),
        .CLK(CLK),
        .RESET(RESET),
        .NAV_STATE(NAV_STATE)
    );
    
    // Instantiating random number generator
    random_num_gen Target(
        .RESET(RESET),
        .CLK(CLK),
        .TARGET_REACHED(TARGET_REACHED),
        .TARGET_ADDR_H(TARGET_ADDR_H),
        .TARGET_ADDR_V(TARGET_ADDR_V)
    );                    
    
    // Instantiating VGA_control                        
    VGA_module VGA(
        .COLOUR_IN(COLOUR_OUTS),
        .CLK(CLK),
        .HS(HS),
        .VS(VS),
        .ADDRH(ADDRH),
        .ADDRV(ADDRV),
        .COLOUR_OUT(COLOUR_OUT)
    );
    
    // Instantiating Snake control                        
    Snake_control Control(
        .MSM_STATE(MSM_STATE),
        .NAV_STATE(NAV_STATE),
        .TARGET_ADDR_H(TARGET_ADDR_H),
        .TARGET_ADDR_V(TARGET_ADDR_V),
        .ADDRH(ADDRH),
        .ADDRV(ADDRV),
        .COLOUR_OUT(COLOUR_OUTS),
        .TARGET_REACHED(TARGET_REACHED),
        .CLK(CLK),
        .LOST(LOST),
        .RESET(RESET)
    );
                            
    PmodJSTK_Demo PmodJSTK (
        .CLK(CLK),
        .RESET(RESET),
        .MISO(MISO),
        .SS(SS),
        .MOSI(MOSI),
        .SCLK(SCLK),
        .BTNU(BTNU),
        .BTND(BTND),
        .BTNL(BTNL),
        .BTNR(BTNR),
        .LED(LED)
    );
                            
endmodule




