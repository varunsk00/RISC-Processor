module right_shift_by_16(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar h;
	generate
	for (h=0; h < 16; h = h + 1) begin: lp8
		assign B[h] = A[h+16];
	end
	endgenerate
	genvar j;
	generate
	for (j=31; j > 15; j = j - 1) begin: lp9
		assign B[j] = A[31];
	end
	endgenerate
endmodule