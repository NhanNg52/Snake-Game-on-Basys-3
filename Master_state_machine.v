`timescale 1ns / 1ps

// This module stores the current state of the game and manages transitions in state.

module Master_state_machine(
    input BTNC,
    input CLK,
    input RESET,
    input LOST,
    output [1:0] MSM_STATE
);
    
    parameter START = 2'b00;
    parameter PLAY = 2'b01;
    parameter LOSS = 2'b10;
    
    reg [1:0] Curr_state;
    reg [1:0] Next_state;
        
    initial
        Curr_state = 0;
    
    // Bind MSM_STATE to the Current state    
    assign MSM_STATE = Curr_state;
        
    always @ (posedge CLK or posedge RESET or posedge LOST)
        if (RESET) 
            Curr_state <= START;
        else if (LOST)
            Curr_state <= LOSS;
        else 
            Curr_state <= Next_state;

    always @ (Curr_state or RESET or BTNC)
        case (Curr_state)
            START :
                if (BTNC)
                    Next_state <= PLAY;
                else
                    Next_state <= Curr_state;
        endcase

endmodule
