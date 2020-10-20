module right_shift_by_4(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar d;
	generate
	for (d=0; d < 28; d = d + 1) begin: lp4
		assign B[d] = A[d+4];
	end
	endgenerate
	genvar e;
	generate
	for (e=31; e > 27; e = e - 1) begin: lp5
		assign B[e] = A[31];
	end
	endgenerate
endmodule