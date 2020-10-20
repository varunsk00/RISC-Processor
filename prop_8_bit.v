module prop_8_bit(out, A, B);
	input [7:0] A, B;
	output [7:0] out;
	
	or g0(out[0], A[0], B[0]);
	or g1(out[1], A[1], B[1]);
	or g2(out[2], A[2], B[2]);
	or g3(out[3], A[3], B[3]);
	or g4(out[4], A[4], B[4]);
	or g5(out[5], A[5], B[5]);
	or g6(out[6], A[6], B[6]);
	or g7(out[7], A[7], B[7]);
endmodule