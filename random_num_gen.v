`timescale 1ns / 1ps

// This modules uses LFSR to generate a random horizontal position and a random vertical position.

module random_num_gen(
    input RESET,
    input CLK,
    input TARGET_REACHED,
    output reg [7:0] TARGET_ADDR_H,
    output reg [6:0] TARGET_ADDR_V
);
    
    reg [7:0] LFSR_1;
    reg [6:0] LFSR_2;

    wire R_INPUT_1 = (LFSR_1[3] ~^ (LFSR_1[4] ~^ (LFSR_1[5] ~^ LFSR_1[7])));  // XNORs
    wire R_INPUT_2 = LFSR_2[6] ~^ LFSR_2[5];

    initial begin
        LFSR_1 = 8'b0001000;
        TARGET_ADDR_H = 8'b01010000;
    end
    
    initial begin
        LFSR_2 = 7'b0001000;
        TARGET_ADDR_V = 7'b0111100;
    end
    
    // To generate a random number Linear Feedback Shift Register concept is used.
    // For the 8-bit shift register, the input value is generated from 4 XNOR gates
    // connected to 4 bits of the register.
    always @ (posedge CLK)
        if (RESET)
            LFSR_1 <= 8'b00000000;
        else begin
            LFSR_1[7] <= LFSR_1[6];
            LFSR_1[6] <= LFSR_1[5];
            LFSR_1[5] <= LFSR_1[4];
            LFSR_1[4] <= LFSR_1[3];
            LFSR_1[3] <= LFSR_1[2];
            LFSR_1[2] <= LFSR_1[1];
            LFSR_1[1] <= LFSR_1[0];
            LFSR_1[0] <= R_INPUT_1;
        end
    
    // For the 7-bit shift register, the input value is generated from 2 XNOR gates
    // connected to 2 bits of the register.
    always @ (posedge CLK)
        if (RESET) 
            LFSR_2 <= 7'b0000000;
        else begin
            LFSR_2[6] <= LFSR_2[5];
            LFSR_2[5] <= LFSR_2[4];
            LFSR_2[4] <= LFSR_2[3];
            LFSR_2[3] <= LFSR_2[2];
            LFSR_2[2] <= LFSR_2[1];
            LFSR_2[1] <= LFSR_2[0];
            LFSR_2[0] <= R_INPUT_2;
        end
 
    // The values of LFSR_1 and LFSR_2 are assigned to be target address coordinates only
    // if the are within the range of the screen and the TARGET_REACHED signal is received. 
    // The following condditions are designed to check whether the generated numbers are correct.
    // If the conditions are not satisfied, target is set in the middle of the screen. 
    always @ (posedge CLK)
        if (TARGET_REACHED) begin
            if (LFSR_1 < 160)
                TARGET_ADDR_H <= LFSR_1;
            else
                TARGET_ADDR_H <= 80;
            if (LFSR_2 < 120)
                TARGET_ADDR_V <= LFSR_2;
            else 
                TARGET_ADDR_V <= 60;
        end else if (RESET) begin
            TARGET_ADDR_H <= 80;
            TARGET_ADDR_V <= 60;
        end
    
endmodule
