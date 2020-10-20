`timescale 1ns / 1ps
module tb;

    // module inputs
    reg clock = 0;

    // Instantiate multdiv
    Wrapper tester(.clock(clock), .reset(1'b0));

    always 
    	#20 clock = !clock;

endmodule