module left_shift_by_8(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar f;
	generate
	for (f=0; f < 24; f = f + 1) begin: lp6
		assign B[f+8] = A[f];
	end
	endgenerate

	genvar g;
	generate
	for (g=0; g < 8; g = g + 1) begin: lp7
		assign B[g] = 1'b0;
	end
	endgenerate
endmodule