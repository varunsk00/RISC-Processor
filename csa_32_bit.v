module csa_32_bit(S, Cout, A, B, Cin);
	input [31:0] A, B;
	input Cin;
	output [31:0] S;
	output Cout;
	wire select, cout_mux0, cout_mux1;
	wire [15:0] sum_mux0, sum_mux1;
	
	csa_16_bit top(S[15:0], select, A[15:0], B[15:0], Cin);

	csa_16_bit mid(sum_mux0, cout_mux0, A[31:16], B[31:16], 1'b0);
	csa_16_bit bottom(sum_mux1, cout_mux1, A[31:16], B[31:16], 1'b1);
	mux_2_16bit sum_mux(S[31:16], select, sum_mux0, sum_mux1);
	mux_2_1bit cout_mux(Cout, select, cout_mux0, cout_mux1);
endmodule