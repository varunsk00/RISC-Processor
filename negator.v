module negator(B, A);
	output[31:0] B;
	input[31:0] A;

	wire[31:0] notA;
	//2's complemented negation
	genvar i;
	generate
	for (i=0; i < 32; i = i + 1) begin: loop1
		not invert(notA[i], A[i]);
	end
	endgenerate

	wire Co;
	csa_32_bit add_1(B, Co, notA, 32'd1, 1'b0);
endmodule