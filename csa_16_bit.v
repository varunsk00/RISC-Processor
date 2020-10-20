module csa_16_bit(S, Cout, A, B, Cin);
	input [15:0] A, B;
	input Cin;
	output [15:0] S;
	output Cout;
	wire select, cout_mux0, cout_mux1;
	wire [7:0] sum_mux0, sum_mux1;
	
	cla_8_bit top(S[7:0], select, A[7:0], B[7:0], Cin);

	cla_8_bit mid(sum_mux0, cout_mux0, A[15:8], B[15:8], 1'b0);
	cla_8_bit bottom(sum_mux1, cout_mux1, A[15:8], B[15:8], 1'b1);
	mux_2_8bit sum_mux(S[15:8], select, sum_mux0, sum_mux1);
	mux_2_1bit cout_mux(Cout, select, cout_mux0, cout_mux1);
endmodule