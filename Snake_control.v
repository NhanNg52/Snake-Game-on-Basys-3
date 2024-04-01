`timescale 1ns / 1ps

// Determines color of pixel at current horizontal and vertical position of the VGA.
// Maintains snake position and length.

module Snake_control(
    input       CLK,
    input       RESET,
    input [1:0] MSM_STATE,
    input [1:0] NAV_STATE,
    input [7:0] TARGET_ADDR_H,
    input [6:0] TARGET_ADDR_V,
    input [9:0] ADDRH,
    input [9:0] ADDRV,
    output reg [11:0] COLOUR_OUT,
    output reg TARGET_REACHED,
    output reg LOST
);

    parameter SnakeLength = 30;
    parameter SmallSnake = 2;
    parameter MaxX = 159;
    parameter MaxY = 119;

    parameter RED = 12'b000000001111;
    parameter BLUE = 12'b111100000000;
    parameter DARKBLUE = 12'b011100000000;
    parameter YELLOW = 12'b000011111111;
    parameter BLACK = 12'b000000000000;

    reg [7:0] SnakeState_X [0 : SnakeLength - 1];
    reg [6:0] SnakeState_Y [0 : SnakeLength - 1];
    reg [4:0] SnakeVar;
    
    integer i;

    wire TRIG_FRAME;

    initial begin
        TARGET_REACHED <= 0;
        SnakeVar <= SmallSnake;
        LOST = 0;
    end

    // Reduce clock frequency to determine snake speed
    Generic_counter # (
        .COUNTER_WIDTH(24),
        .COUNTER_MAX(9999999)
    ) FreqCounter (
        .CLK(CLK),
        .ENABLE_IN(1'b1),
        .RESET(1'b0),
        .TRIG_OUT(TRIG_FRAME)
    );

    always @ (posedge CLK)
        if (RESET) begin
            LOST <= 1'b0;
            SnakeVar <= SmallSnake;
        end else
            case (MSM_STATE)

                // START
                2'b00 : begin
                //
                    if ((ADDRH >= 125 && ADDRH <= 250 && ADDRV >= 75 && ADDRV <= 100) ||
                        (ADDRH >= 100 && ADDRH <= 275 && ADDRV >= 100 && ADDRV <= 175) ||
                        (ADDRH >= 75 && ADDRH <= 150 && ADDRV >= 175 && ADDRV <= 350) ||
                        (ADDRH >= 125 && ADDRH <= 225 && ADDRV >= 325 && ADDRV <= 400) ||
                        (ADDRH >= 175 && ADDRH <= 325 && ADDRV >= 375 && ADDRV <= 450) ||
                        (ADDRH >= 250 && ADDRH <= 500 && ADDRV >= 450 && ADDRV <= 480) ||
                        (ADDRH >= 475 && ADDRH <= 500 && ADDRV >= 425 && ADDRV <= 450))
                        COLOUR_OUT <= YELLOW;
                    else if ((ADDRH >= 275 && ADDRH <= 400 && ADDRV >= 150 && ADDRV <= 160) ||
                             (ADDRH >= 370 && ADDRH <= 380 && ADDRV >= 130 && ADDRV <= 150))
                        COLOUR_OUT <= RED;
                    else if ((ADDRH >= 450 && ADDRH <= 495 && ADDRV >= 225 && ADDRV <= 240) ||
                             (ADDRH >= 450 && ADDRH <= 465 && ADDRV >= 240 && ADDRV <= 270) ||
                             (ADDRH >= 465 && ADDRH <= 495 && ADDRV >= 270 && ADDRV <= 285) ||
                             (ADDRH >= 495 && ADDRH <= 510 && ADDRV >= 285 && ADDRV <= 315) ||
                             (ADDRH >= 465 && ADDRH <= 510 && ADDRV >= 315 && ADDRV <= 330) ||
                             (ADDRH >= 495 && ADDRH <= 510 && ADDRV >= 240 && ADDRV <= 255) ||
                             (ADDRH >= 450 && ADDRH <= 465 && ADDRV >= 300 && ADDRV <= 315))
                        COLOUR_OUT <= BLUE;
                    else
                        COLOUR_OUT <= BLACK;
                    if ((ADDRH >= 210 && ADDRH <= 225 && ADDRV >= 120 && ADDRV <= 135))
                        COLOUR_OUT <= BLACK;
                    SnakeVar <= SmallSnake;
                end
                  
                // PLAY
                2'b01 : begin

                    // Display
                    if (ADDRH[9:2] == SnakeState_X[0] && ADDRV[8:2] == SnakeState_Y[0]) 
                        COLOUR_OUT <= YELLOW;
                    else if (ADDRH[9:2] == TARGET_ADDR_H && ADDRV[8:2] == TARGET_ADDR_V)
                        COLOUR_OUT <= RED;
                    else
                        COLOUR_OUT <= DARKBLUE;
                    for (i = 0; i < SnakeVar; i = i + 1)
                        if (ADDRH[9:2] == SnakeState_X[i] && 
                            ADDRV[8:2] == SnakeState_Y[i])
                            COLOUR_OUT <= YELLOW;

                    // Target
                    if (SnakeState_X[1] == TARGET_ADDR_H && 
                        SnakeState_Y[1] == TARGET_ADDR_V &&
                        TARGET_REACHED == 0) begin
                        TARGET_REACHED <= 1; 
                        if (SnakeVar < SnakeLength)
                            SnakeVar <= SnakeVar + 1; 
                    end else
                        TARGET_REACHED <= 0;

                    // Collisions
                    if (SnakeState_X[0] < 1 || SnakeState_X[0] > MaxX+1 || 
                        SnakeState_Y[0] < 1 || SnakeState_Y[0] > MaxY+1)
                        LOST <= 1'b1;
                    for (i = 1; i < SnakeVar; i = i + 1)
                        if (SnakeState_X[0] == SnakeState_X[i] && 
                            SnakeState_Y[0] == SnakeState_Y[i])
                            LOST <= 1'b1;

                end
                    
                // LOST
                2'b10 : begin
                    if ((ADDRH >= 0 && ADDRH <= 275 && ADDRV >= 375 && ADDRV <= 480) ||
                        (ADDRH >= 250 && ADDRH <= 400 && ADDRV >= 400 && ADDRV <= 480))
                        COLOUR_OUT <= YELLOW;
                    else if ((ADDRH >= 400 && ADDRH <= 550 && ADDRV >= 460 && ADDRV <= 470) ||
                             (ADDRH >= 520 && ADDRH <= 530 && ADDRV >= 440 && ADDRV <= 460))
                        COLOUR_OUT <= RED;
                    else if ((ADDRH >= 450 && ADDRH <= 465 && ADDRV >= 175 && ADDRV <= 265) ||
                             (ADDRH >= 465 && ADDRH <= 480 && ADDRV >= 190 && ADDRV <= 205) ||
                             (ADDRH >= 480 && ADDRH <= 510 && ADDRV >= 175 && ADDRV <= 190) ||
                             (ADDRH >= 510 && ADDRH <= 525 && ADDRV >= 190 && ADDRV <= 205))
                        COLOUR_OUT <= BLUE;
                    else
                        COLOUR_OUT <= BLACK;
                    if ((ADDRH >= 205 && ADDRH <= 210 && ADDRV >= 400 && ADDRV <= 405) ||
                        (ADDRH >= 210 && ADDRH <= 215 && ADDRV >= 405 && ADDRV <= 410) ||
                        (ADDRH >= 215 && ADDRH <= 220 && ADDRV >= 410 && ADDRV <= 415) ||
                        (ADDRH >= 220 && ADDRH <= 225 && ADDRV >= 415 && ADDRV <= 420) ||
                        (ADDRH >= 225 && ADDRH <= 230 && ADDRV >= 420 && ADDRV <= 425) ||
                        (ADDRH >= 225 && ADDRH <= 230 && ADDRV >= 400 && ADDRV <= 405) ||
                        (ADDRH >= 220 && ADDRH <= 225 && ADDRV >= 405 && ADDRV <= 410) ||
                        (ADDRH >= 210 && ADDRH <= 215 && ADDRV >= 415 && ADDRV <= 420) ||
                        (ADDRH >= 205 && ADDRH <= 210 && ADDRV >= 420 && ADDRV <= 425))
                        COLOUR_OUT <= BLACK;
                    else if ((ADDRH[9:3] >= 10 && ADDRH[9:3] < 70 && ADDRV[8:3] == 10) && 
                             ((ADDRH[9:3]-10)%2 == 0 && (ADDRH[9:3]-10)/2 < SnakeVar-2))
                        COLOUR_OUT <= RED;
                end

            endcase  

    // Shift body on every tick
    always @ (posedge CLK)
        for (i = 0; i < SnakeLength - 1; i = i + 1)
            if (RESET) begin
                SnakeState_X[i+1] <= 80;
                SnakeState_Y[i+1] <= 100;
            end else if (TRIG_FRAME) begin
                SnakeState_X[i+1] <= SnakeState_X[i];
                SnakeState_Y[i+1] <= SnakeState_Y[i];
            end

    // Move snake head on every tick
    always @ (posedge CLK)
        if (RESET) begin
            SnakeState_X[0] <= 80;
            SnakeState_Y[0] <= 100;
        end else if (TRIG_FRAME)
            case (NAV_STATE)
                2'b00 : SnakeState_Y[0] <= SnakeState_Y[0] - 1;  // UP
                2'b10 : SnakeState_X[0] <= SnakeState_X[0] + 1;  // RIGHT
                2'b01 : SnakeState_X[0] <= SnakeState_X[0] - 1;  // LEFT
                2'b11 : SnakeState_Y[0] <= SnakeState_Y[0] + 1;  // DOWN
            endcase

endmodule
    
    
    

