module right_shift_by_2(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar b;
	generate
	for (b=0; b < 30; b = b + 1) begin: lp2
		assign B[b] = A[b+2];
	end
	endgenerate
	genvar c;
	generate
	for (c=31; c > 29; c = c - 1) begin: lp3
		assign B[c] = A[31];
	end
	endgenerate
endmodule