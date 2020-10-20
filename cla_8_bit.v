module cla_8_bit(S, Cout, A, B, Cin);
	input [7:0] A, B;
	input Cin;
	output [7:0] S;
	output Cout;
	wire [7:0] g;
	wire [7:0] p;
	wire pc0, p1g0, p1p0c0, p2g1, p2p1g0, p2p1p0c0, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0, p4g3, 
	p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0, p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0,
	p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0, p7g6, p7p6g5, 
	p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2p1p0c0;
	wire c1, c2, c3, c4, c5, c6, c7;

	gen_8_bit gen(g, A, B);
	prop_8_bit prop(p, A, B);
	
	and a1(pc0, p[0], Cin);
	or o1(c1, g[0], pc0);

	and a2(p1g0, p[1], g[0]);
	and a3(p1p0c0, p[1], p[0], Cin);
	or o2(c2, g[1], p1g0, p1p0c0);

	and a4(p2g1, p[2], g[1]);
	and a5(p2p1g0, p[2], p[1], g[0]);
	and a6(p2p1p0c0, p[2], p[1], p[0], Cin);
	or o3(c3, g[2], p2g1, p2p1g0, p2p1p0c0);

	and a7(p3g2, p[3], g[2]);
	and a8(p3p2g1, p[3], p[2], g[1]);
	and a9(p3p2p1g0, p[3], p[2], p[1], g[0]);
	and a10(p3p2p1p0c0, p[3], p[2], p[1], p[0], Cin);
	or o4(c4, g[3], p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0);

	and a11(p4g3, p[4], g[3]);
	and a12(p4p3g2, p[4], p[3], g[2]);
	and a13(p4p3p2g1, p[4], p[3], p[2], g[1]);
	and a14(p4p3p2p1g0, p[4], p[3], p[2], p[1], g[0]);
	and a15(p4p3p2p1p0c0, p[4], p[3], p[2], p[1], p[0], Cin);
	or o5(c5, g[4], p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0);

	and a16(p5g4, p[5], g[4]);
	and a17(p5p4g3, p[5], p[4], g[3]);
	and a18(p5p4p3g2, p[5], p[4], p[3], g[2]);
	and a19(p5p4p3p2g1, p[5], p[4], p[3], p[2], g[1]);
	and a20(p5p4p3p2p1g0, p[5], p[4], p[3], p[2], p[1], g[0]);
	and a21(p5p4p3p2p1p0c0, p[5], p[4], p[3], p[2], p[1], p[0], Cin);
	or o6(c6, g[5], p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0);

	and a22(p6g5, p[6], g[5]);
	and a23(p6p5g4, p[6], p[5], g[4]);
	and a24(p6p5p4g3, p[6], p[5], p[4], g[3]);
	and a25(p6p5p4p3g2, p[6], p[5], p[4], p[3], g[2]);
	and a26(p6p5p4p3p2g1, p[6], p[5], p[4], p[3], p[2], g[1]);
	and a27(p6p5p4p3p2p1g0, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and a28(p6p5p4p3p2p1p0c0, p[6], p[5], p[4], p[3], p[2], p[1], p[0], Cin);
	or o7(c7, g[6], p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0);	
	
	and a29(p7g6, p[7], g[6]);
	and a30(p7p6g5, p[7], p[6], g[5]);
	and a31(p7p6p5g4, p[7], p[6], p[5], g[4]);
	and a32(p7p6p5p4g3, p[7], p[6], p[5], p[4], g[3]);
	and a33(p7p6p5p4p3g2, p[7], p[6], p[5], p[4], p[3], g[2]);
	and a34(p7p6p5p4p3p2g1, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
	and a35(p7p6p5p4p3p2p1g0, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and a36(p7p6p5p4p3p2p1p0c0, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0], Cin);
	or o8(Cout, g[7], p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2p1p0c0);

	xor sum_1(S[0], A[0], B[0], Cin);
	xor sum_2(S[1], A[1], B[1], c1);
	xor sum_3(S[2], A[2], B[2], c2);
	xor sum_4(S[3], A[3], B[3], c3);
	xor sum_5(S[4], A[4], B[4], c4);
	xor sum_6(S[5], A[5], B[5], c5);
	xor sum_7(S[6], A[6], B[6], c6);
	xor sum_8(S[7], A[7], B[7], c7);
endmodule