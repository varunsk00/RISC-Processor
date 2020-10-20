module left_shift_by_16(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar h;
	generate
	for (h=0; h < 16; h = h + 1) begin: lp8
		assign B[h+16] = A[h];
	end
	endgenerate

	genvar j;
	generate
	for (j=0; j < 16; j = j + 1) begin: lp9
		assign B[j] = 1'b0;
	end
	endgenerate
endmodule