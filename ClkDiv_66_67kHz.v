`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    ClkDiv_66_67kHz 
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Converts input 100MHz clock signal to a 66.67kHz clock signal.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////

// ============================================================================== 
// 										  Define Module
// ==============================================================================
module ClkDiv_66_67kHz(
    input CLK,											// 100MHz onbaord clock
    input RESET,											// Reset
    output reg CLKOUT										// New clock output
);

    // Output register
    initial
        CLKOUT = 1'b1;

    // Value to toggle output clock at
    parameter cntEndVal = 10'b1011101110;
    // Current count
    reg [9:0] clkCount = 10'b0000000000;

    //----------------------------------------------
    //	Serial Clock
    //	66.67kHz Clock Divider, period 15us
    //----------------------------------------------
    always @(posedge CLK)
        // Reset clock
        if(RESET == 1'b1) begin
            CLKOUT <= 1'b0;
            clkCount <= 10'b0000000000;
        end
        // Count/toggle normally
        else
            if(clkCount == cntEndVal) begin
                CLKOUT <= ~CLKOUT;
                clkCount <= 10'b0000000000;
            end else
                clkCount <= clkCount + 1'b1;

endmodule
