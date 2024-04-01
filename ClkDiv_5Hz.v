`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    ClkDiv_5Hz
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Converts input 100MHz clock signal to a 5Hz clock signal.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////

module ClkDiv_5Hz(
    input CLK,											// 100MHz onbaord clock
    input RESET,											// Reset
    output reg CLKOUT										// New clock output
);

    // Output register
    initial
        CLKOUT = 1'b1;

    // Value to toggle output clock at
    parameter cntEndVal = 23'd4999999;
    // Current count
    reg [23:0] clkCount = 24'h000000;
	

    //-------------------------------------------------
    //	5Hz Clock Divider Generates Send/Receive signal
    //-------------------------------------------------
    always @(posedge CLK)
        // Reset clock
        if(RESET == 1'b1) begin
            CLKOUT <= 1'b0;
            clkCount <= 24'h000000;
        end else
            if(clkCount == cntEndVal) begin
                CLKOUT <= ~CLKOUT;
                clkCount <= 24'h000000;
            end else
                clkCount <= clkCount + 1'b1;

endmodule
