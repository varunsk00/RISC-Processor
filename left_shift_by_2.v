module left_shift_by_2(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar b;
	generate
	for (b=0; b < 30; b = b + 1) begin: lp2
		assign B[b+2] = A[b];
	end
	endgenerate

	genvar c;
	generate
	for (c=0; c < 2; c = c + 1) begin: lp3
		assign B[c] = 1'b0;
	end
	endgenerate
endmodule