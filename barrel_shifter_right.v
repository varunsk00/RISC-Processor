module barrel_shifter_right(out, A, shamt);
	output [31:0] out;
	input [31:0] A;
	input [4:0] shamt;
	wire [31:0] b1, b2, b3, b4, b5, b6, b7, b8, b9;

	right_shift_by_16 block_0(b1, A);
	mux_2_32bit mux_0(b2, shamt[4], A, b1);
	
	right_shift_by_8 block_1(b3, b2);
	mux_2_32bit mux_1(b4, shamt[3], b2, b3);

	right_shift_by_4 block_2(b5, b4);
	mux_2_32bit mux_2(b6, shamt[2], b4, b5);

	right_shift_by_2 block_3(b7, b6);
	mux_2_32bit mux_3(b8, shamt[1], b6, b7);

	right_shift_by_1 block_4(b9, b8);
	mux_2_32bit mux_4(out, shamt[0], b8, b9);
endmodule