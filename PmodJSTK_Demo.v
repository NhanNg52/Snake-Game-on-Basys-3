`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    07/11/2012
// Module Name:    PmodJSTK_Demo 
// Project Name: 	 PmodJSTK_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: This is a demo for the Digilent PmodJSTK. Data is sent and received
//					 to and from the PmodJSTK at a frequency of 5Hz, and positional 
//					 data is displayed on the seven segment display (SSD). The positional
//					 data of the joystick ranges from 0 to 1023 in both the X and Y
//					 directions. Only one coordinate can be displayed on the SSD at a
//					 time, therefore switch SW0 is used to select which coordinate's data
//	   			 to display. The status of the buttons on the PmodJSTK are
//					 displayed on LD2, LD1, and LD0 on the Nexys3. The LEDs will
//					 illuminate when a button is pressed. Switches SW2 and SW1 on the
//					 Nexys3 will turn on LD1 and LD2 on the PmodJSTK respectively. Button
//					 BTND on the Nexys3 is used for resetting the demo. The PmodJSTK
//					 connects to pins [4:1] on port JA on the Nexys3. SPI mode 0 is used
//					 for communication between the PmodJSTK and the Nexys3.
//
//					 NOTE: The digits on the SSD may at times appear to flicker, this
//						    is due to small pertebations in the positional data being read
//							 by the PmodJSTK's ADC. To reduce the flicker simply reduce
//							 the rate at which the data being displayed is updated.
//
// Revision History: 
// 						Revision 0.01 - File Created (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////


// ============================================================================== 
// 										  Define Module
// ==============================================================================
module PmodJSTK_Demo(
    input CLK,					// 100Mhz onboard clock
    input RESET,				// Button R
    input MISO,					// Master In Slave Out, Pin 3, Port JA
    output SS,					// Slave Select, Pin 1, Port JA
    output MOSI,				// Master Out Slave In, Pin 2, Port JA
    output SCLK,				// Serial Clock, Pin 4, Port JA
    output reg BTNU,
    output reg BTND,
    output reg BTNL,
    output reg BTNR,
    output reg [3:0] LED
);

    wire [7:0] sndData;             // Holds data to be sent to PmodJSTK
    wire sndRec;                    // Signal to send/receive data to/from PmodJSTK
    wire [39:0] jstkData;           // Data read from PmodJSTK
    
    wire [9:0] posDataX;             // Signal carrying output data that user selected
    wire [9:0] posDataY;             // Signal carrying output data that user selected

    //-----------------------------------------------
    //  	  			PmodJSTK Interface
    //-----------------------------------------------
    PmodJSTK PmodJSTK_Int(
        .CLK(CLK),
        .RESET(RESET),
        .sndRec(sndRec),
        .DIN(sndData),
        .MISO(MISO),
        .SS(SS),
        .SCLK(SCLK),
        .MOSI(MOSI),
        .DOUT(jstkData)
    );

    //-----------------------------------------------
    //  			 Send Receive Generator
    //-----------------------------------------------
    ClkDiv_5Hz genSndRec(
        .CLK(CLK),
        .RESET(RESET),
        .CLKOUT(sndRec)
    );
    
    // Data to be sent to PmodJSTK, lower two bits will turn on leds on PmodJSTK
    assign sndData = 8'b10000000;
    assign posDataX = {jstkData[25:24], jstkData[39:32]};
    assign posDataY = {jstkData[9:8], jstkData[23:16]};

    // Assign PmodJSTK button status to LED[3:0]
    always @(sndRec or RESET or jstkData)
        if (posDataX >= 1023-256 &&
            posDataY < posDataX &&
            posDataY >= 1023-posDataX) begin
            BTNU <= 1'b1;
            BTND <= 1'b0;
            BTNL <= 1'b0;
            BTNR <= 1'b0;
            LED <= 4'b1000;
        end else if (posDataX < 256 &&
                     posDataY >= posDataX &&
                     posDataY < 1023-posDataX) begin
            BTNU <= 1'b0;
            BTND <= 1'b1;
            BTNL <= 1'b0;
            BTNR <= 1'b0;
            LED <= 4'b0100;
        end else if (posDataY >= 1023-256 &&
                     posDataX < posDataY &&
                     posDataX >= 1023-posDataY) begin
            BTNU <= 1'b0;
            BTND <= 1'b0;
            BTNL <= 1'b1;
            BTNR <= 1'b0;
            LED <= 4'b0010;
        end else if (posDataY < 256 &&
                     posDataX >= posDataY &&
                     posDataX < 1023-posDataY) begin
            BTNU <= 1'b0;
            BTND <= 1'b0;
            BTNL <= 1'b0;
            BTNR <= 1'b1;
            LED <= 4'b0001;
        end else begin
            BTNU <= 1'b0;
            BTND <= 1'b0;
            BTNL <= 1'b0;
            BTNR <= 1'b0;
            LED <= 4'b0000;
        end

endmodule
