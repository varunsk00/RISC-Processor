module eight_bit_comp(Eq_i, Gt_i, A, B);
	input [7:0] A, B;
	wire Eq_ip1, Gt_ip1;
	output Eq_i, Gt_i;
	wire w1, w2, w3, w4, w5, w6;
	assign Eq_ip1 = 1;
	assign Gt_ip1 = 0;

	two_bit_comp cmp1(w1, w2, A[7:6], B[7:6], Eq_ip1, Gt_ip1);
	two_bit_comp cmp2(w3, w4, A[5:4], B[5:4], w1, w2);
	two_bit_comp cmp3(w5, w6, A[3:2], B[3:2], w3, w4);
	two_bit_comp cmp4(Eq_i, Gt_i, A[1:0], B[1:0], w5, w6);
endmodule