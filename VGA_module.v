`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// This module takes the input COLOUR_IN from the wrapper module and transmits it to the
// screen if the pixel address is within the range of the screen
// Dependencies: Generic_counter.v
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_module(
    input CLK,
    input [11:0] COLOUR_IN,
    output reg [11:0] COLOUR_OUT,
    output reg HS,
    output reg VS,
    output reg [9:0] ADDRH,
    output reg [8:0] ADDRV
);
    
    // stating all the wire connections
    wire  TRIG_1;
    wire  HorTriggOut;
    wire  VerticalTriggOut;
    wire  [9:0] HorCount;
    wire  [9:0] VerticalCount;
   
    // Time in vertical lines
    parameter VertTimeToPulseWidthEnd   = 10'd2;
    parameter VertTimeToBackPorchEnd    = 10'd31;
    parameter VertTimeToDisplayTimeEnd  = 10'd511;
    parameter VertTimeToFrontPorchEnd   = 10'd521;
    
    // Time in Front Horizontal Lines
    parameter HorzTimeToPulseWidthEnd   = 10'd96;
    parameter HorzTimeToBackPorchEnd    = 10'd144;
    parameter HorzTimeToDisplayTimeEnd  = 10'd784;
    parameter HorzTimeToFrontPorchEnd   = 10'd800;
    
    // Reduce the frequency from 100MHz to 25MHz for screen refresh
    Generic_counter # (
        .COUNTER_WIDTH(2),
        .COUNTER_MAX(3)
    ) FreqCounter (
        .CLK(CLK),
        .ENABLE_IN(1'b1),
        .RESET(1'b0),
        .TRIG_OUT(TRIG_1)
    );
    
    // Count the horizontal pixel position
    Generic_counter # (
        .COUNTER_WIDTH(10),
        .COUNTER_MAX(799)
    ) HorizCounter (
        .CLK(CLK),
        .ENABLE_IN(TRIG_1),
        .RESET(1'b0),
        .TRIG_OUT(HorTriggOut),
        .COUNT(HorCount)
    );
                       
    // Counter to count the vertical pixel position
    Generic_counter # (
        .COUNTER_WIDTH(10),
        .COUNTER_MAX(520)
    ) VerticalCounter (
        .CLK(CLK),
        .ENABLE_IN(HorTriggOut),
        .RESET(1'b0),
        .COUNT(VerticalCount)
    );
     
    // Horizontal synchronization signal is generated if the horizontal count value is greater than 
    // Horizontal Time to pulse width end
    always @ (posedge CLK)
        if (HorCount < HorzTimeToPulseWidthEnd)
            HS <= 0;
        else 
            HS <= 1;
     
    // Vertical synchronization signal is generated if the vertical count value is greater than 
    // Vertical Time to pulse width end
    always @ (posedge CLK)
        if (VerticalCount < VertTimeToPulseWidthEnd)
            VS <= 0;
        else 
            VS <= 1;
     
    // If the horizontal and vertical counts are within the display range, then the 
    // the input colour is transmitted to screen; otherwise, colour is set to black
    always @ (posedge CLK)
        if (HorCount < HorzTimeToDisplayTimeEnd && 
            HorCount > HorzTimeToBackPorchEnd && 
            VerticalCount < VertTimeToDisplayTimeEnd && 
            VerticalCount > VertTimeToBackPorchEnd)
            COLOUR_OUT <= COLOUR_IN;    
        else 
            COLOUR_OUT <= 0;  
          
    // If the horizontal count is within the range, then its value is assigned to the 
    // horizontal address subtracting the offset value (144 pixels)
    // Otherwise, address is set to 0
    always @ (posedge CLK)
        if (HorCount < HorzTimeToDisplayTimeEnd && HorCount > HorzTimeToBackPorchEnd)
            ADDRH <= HorCount - HorzTimeToBackPorchEnd;
        else 
            ADDRH <= 0;
     
    // If the vertical count is within the range, then its value is assigned to the 
    // vertical address subtracting the offset value (31 pixels)
    // Otherwise, address is set to 0 
    always @ (posedge CLK)
        if (VerticalCount < VertTimeToDisplayTimeEnd && VerticalCount > VertTimeToBackPorchEnd)
            ADDRV <= VerticalCount - VertTimeToBackPorchEnd;
        else 
            ADDRV <= 0;
                
endmodule
