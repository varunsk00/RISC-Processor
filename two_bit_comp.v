module two_bit_comp(Eq_i,Gt_i, A, B, Eq_ip1, Gt_ip1);
	input [1:0] A, B;
	output Eq_i, Gt_i;
	input Eq_ip1, Gt_ip1;
	wire Gt_not, B0_not, E_not;
	wire [2:0] select;
	wire w2, i0, i1, i2, i3, i4, i5, i6, i7;
	wire w3;
	wire i8, i9, i10, i11, i12, i13, i14, i15;
	assign select[2:1] = A;
	assign select[0] = B[1];

	not(Gt_not, Gt_ip1);
	not(B0_not, B[0]);
	not(E_not, Eq_ip1);

	and(i0, Eq_ip1, Gt_not, B0_not);
	assign i1 = 1'b0;
	and(i2, Eq_ip1, Gt_not, B[0]);
	assign i3 = 1'b0;
	assign i4 = 1'b0;
	and(i5, Eq_ip1, Gt_not, B0_not);
	assign i6 = 1'b0;
	and(i7, Eq_ip1, Gt_not, B[0]);

	assign i8 = 1'b0;
	assign i9 = 1'b0;
	and(i10, Eq_ip1, Gt_not, B0_not);
	assign i11 = 1'b0;
	and(i12, Eq_ip1, Gt_not);
	assign i13 = 1'b0;
	and(i14, Eq_ip1, Gt_not);
	and(i15, Eq_ip1, Gt_not, B0_not);
	
	mux_8_1bit eq(Eq_i, select[2:0], i0, i1, i2, i3, i4, i5, i6, i7);

	mux_8_1bit gt_mux(w2, select[2:0], i8, i9, i10, i11, i12, i13, i14, i15);
	and(w3, E_not, Gt_ip1);
	or(Gt_i, w2, w3);
endmodule
