module gen_8_bit(out, A, B);
	input [7:0] A, B;
	output [7:0] out;
	
	and g0(out[0], A[0], B[0]);
	and g1(out[1], A[1], B[1]);
	and g2(out[2], A[2], B[2]);
	and g3(out[3], A[3], B[3]);
	and g4(out[4], A[4], B[4]);
	and g5(out[5], A[5], B[5]);
	and g6(out[6], A[6], B[6]);
	and g7(out[7], A[7], B[7]);
endmodule