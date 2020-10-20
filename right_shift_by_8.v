module right_shift_by_8(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar f;
	generate
	for (f=0; f < 24; f = f + 1) begin: lp6
		assign B[f] = A[f+8];
	end
	endgenerate
	genvar g;
	generate
	for (g=31; g > 23; g = g - 1) begin: lp7
		assign B[g] = A[31];
	end
	endgenerate
endmodule