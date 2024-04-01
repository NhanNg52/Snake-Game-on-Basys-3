`timescale 1ns / 1ps

// This module counts up to a given maximum and indicates when its value is reset to 0.

module Generic_counter(
    CLK,
    RESET,
    ENABLE_IN,
    TRIG_OUT,
    COUNT
);

    parameter COUNTER_WIDTH = 1;
    parameter COUNTER_MAX = 1;

    input CLK;
    input RESET;
    input ENABLE_IN;
    output TRIG_OUT;
    output [COUNTER_WIDTH-1:0] COUNT;

    reg [COUNTER_WIDTH-1:0] count_value = 0;
    reg Trigger_out;

    // Update count_values
    always @ (posedge CLK)
        if (RESET)
            count_value <= 0;
        else
            if (ENABLE_IN)
                if (count_value == COUNTER_MAX)
                    count_value <= 0;
                else
                    count_value <= count_value + 1;

    // Update Trigger_out
    always @ (posedge CLK)
        if (RESET)
            Trigger_out <= 0;
        else
            if (ENABLE_IN && (count_value == COUNTER_MAX))
                Trigger_out <= 1;
            else
                Trigger_out <= 0;

    // Bind count_value and Trigger_out to COUNT and TRIG_OUT respectively.
    assign COUNT = count_value;
    assign TRIG_OUT = Trigger_out;

endmodule
