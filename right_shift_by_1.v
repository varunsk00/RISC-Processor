module right_shift_by_1(B, A);
	input [31:0] A;
	output [31:0] B;

	genvar a;
	generate
	for (a=0; a < 31; a = a + 1) begin: lp1
		assign B[a] = A[a+1];
	end
	assign B[31] = A[31];
	endgenerate
endmodule