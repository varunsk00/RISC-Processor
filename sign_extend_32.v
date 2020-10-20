module sign_extend_32 (out, in);
	input [16:0] in;
	output [31:0] out;

    assign out[16:0] = in[16:0];
    assign out[31:17] = in[16];
endmodule