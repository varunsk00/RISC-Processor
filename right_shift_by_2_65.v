module right_shift_by_2_65(B, A);
	input [64:0] A;
	output [64:0] B;

	genvar b;
	generate
	for (b=0; b < 63; b = b + 1) begin: lp2
		assign B[b] = A[b+2];
	end
	endgenerate
	genvar c;
	generate
	for (c=64; c > 62; c = c - 1) begin: lp3
		assign B[c] = A[64];
	end
	endgenerate
endmodule