`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    spiCtrl
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This component manages all data transfer requests,
//					 and manages the data bytes being sent to the PmodJSTK.
//
//  				 For more information on the contents of the bytes being sent/received 
//					 see page 2 in the PmodJSTK reference manual found at the link provided
//					 below.
//
//					 http://www.digilentinc.com/Data/Products/XUPV2P-COVERS/PmodJSTK_rm_RevC.pdf
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
////////////////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module spiCtrl(
    input CLK,						// 66.67kHz onboard clock
    input RESET,						// Reset
    input sndRec,					// Send receive, initializes data read/write
    input BUSY,						// If active data transfer currently in progress
    input [7:0] DIN,				// Data that is to be sent to the slave
    input [7:0] RxData,			// Last data byte received
    output reg SS,						// Slave select, active low
    output reg getByte,				// Initiates a data transfer in SPI_Int
    output reg [7:0] sndData,		// Data that is to be sent to the slave
    output reg [39:0] DOUT			// All data read from the slave
);

    initial begin
		SS = 1'b1;
		getByte = 1'b0;
		sndData = 8'h00;
		DOUT = 40'h0000000000;
    end

    // FSM States
    parameter [2:0] Idle = 3'd0,
                     Init = 3'd1,
                     Wait = 3'd2,
                     Check = 3'd3,
                     Done = 3'd4;
    
    // Present State
    reg [2:0] pState = Idle;

    reg [2:0] byteCnt = 3'd0;					// Number bits read/written
    parameter byteEndVal = 3'd5;				// Number of bytes to send/receive
    reg [39:0] tmpSR = 40'h0000000000;		// Temporary shift register to
																// accumulate all five data bytes
	always @(negedge CLK)
        if(RESET == 1'b1) begin
            // Reest everything
            SS <= 1'b1;
            getByte <= 1'b0;
            sndData <= 8'h00;
            tmpSR <= 40'h0000000000;
            DOUT <= 40'h0000000000;
            byteCnt <= 3'd0;
            pState <= Idle;
        end else  
            case(pState)
                // Idle
                Idle : begin
                    SS <= 1'b1;								// Disable slave
                    getByte <= 1'b0;						// Do not request data
                    sndData <= 8'h00;						// Clear data to be sent
                    tmpSR <= 40'h0000000000;			// Clear temporary data
                    DOUT <= DOUT;							// Retain output data
                    byteCnt <= 3'd0;						// Clear byte count
                    // When send receive signal received begin data transmission
                    if(sndRec == 1'b1)
                        pState <= Init;
                    else
                        pState <= Idle;
                end
                // Init
                Init : begin
                    SS <= 1'b0;								// Enable slave
                    getByte <= 1'b1;						// Initialize data transfer
                    sndData <= DIN;						// Store input data to be sent
                    tmpSR <= tmpSR;						// Retain temporary data
                    DOUT <= DOUT;							// Retain output data
                    if(BUSY == 1'b1) begin
                        pState <= Wait;
                        byteCnt <= byteCnt + 1'b1;	// Count
                    end else
                        pState <= Init;
                end
                // Wait
                Wait : begin
                    SS <= 1'b0;								// Enable slave
                    getByte <= 1'b0;						// Data request already in progress
                    sndData <= sndData;					// Retain input data to send
                    tmpSR <= tmpSR;						// Retain temporary data
                    DOUT <= DOUT;							// Retain output data
                    byteCnt <= byteCnt;					// Count
                    // Finished reading byte so grab data
                    if(BUSY == 1'b0)
                        pState <= Check;
                    // Data transmission is not finished
                    else
                        pState <= Wait;
                end
                // Check
                Check : begin
                    SS <= 1'b0;								// Enable slave
                    getByte <= 1'b0;						// Do not request data
                    sndData <= sndData;					// Retain input data to send
                    tmpSR <= {tmpSR[31:0], RxData};	// Store byte just read
                    DOUT <= DOUT;							// Retain output data
                    byteCnt <= byteCnt;					// Do not count
                    // Finished reading bytes so done
                    if(byteCnt == 3'd5)
                        pState <= Done;
                    // Have not sent/received enough bytes
                    else
                        pState <= Init;
                end
                // Done
                Done : begin
                    SS <= 1'b1;							// Disable slave
                    getByte <= 1'b0;					// Do not request data
                    sndData <= 8'h00;					// Clear input
                    tmpSR <= tmpSR;					// Retain temporary data
                    DOUT[39:0] <= tmpSR[39:0];		// Update output data
                    byteCnt <= byteCnt;				// Do not count
                    // Wait for external sndRec signal to be de-asserted
                    if(sndRec == 1'b0)
                        pState <= Idle;
                    else
                        pState <= Done;
                end
                // Default State
                default : pState <= Idle;
            endcase

endmodule
