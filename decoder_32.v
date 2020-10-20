module decoder_32 (out, in);
	input [4:0] in;
	output [31:0] out;

	wire [4:0] in_not;

	genvar i;
	generate
	for (i=0; i < 5; i = i + 1) begin: loop1
		not invert(in_not[i], in[i]);
	end
	endgenerate

	and out_0(out[0], in_not[4], in_not[3], in_not[2], in_not[1], in_not[0]);
	and out_1(out[1], in_not[4], in_not[3], in_not[2], in_not[1], in[0]);
	and out_2(out[2], in_not[4], in_not[3], in_not[2], in[1], in_not[0]);
	and out_3(out[3], in_not[4], in_not[3], in_not[2], in[1], in[0]);
	and out_4(out[4], in_not[4], in_not[3], in[2], in_not[1], in_not[0]);
	and out_5(out[5], in_not[4], in_not[3], in[2], in_not[1], in[0]);
	and out_6(out[6], in_not[4], in_not[3], in[2], in[1], in_not[0]);
	and out_7(out[7], in_not[4], in_not[3], in[2], in[1], in[0]);
	and out_8(out[8], in_not[4], in[3], in_not[2], in_not[1], in_not[0]);
	and out_9(out[9], in_not[4], in[3], in_not[2], in_not[1], in[0]);
	and out_10(out[10], in_not[4], in[3], in_not[2], in[1], in_not[0]);
	and out_11(out[11], in_not[4], in[3], in_not[2], in[1], in[0]);
	and out_12(out[12], in_not[4], in[3], in[2], in_not[1], in_not[0]);
	and out_13(out[13], in_not[4], in[3], in[2], in_not[1], in[0]);
	and out_14(out[14], in_not[4], in[3], in[2], in[1], in_not[0]);
	and out_15(out[15], in_not[4], in[3], in[2], in[1], in[0]);
	and out_16(out[16], in[4], in_not[3], in_not[2], in_not[1], in_not[0]);
	and out_17(out[17], in[4], in_not[3], in_not[2], in_not[1], in[0]);
	and out_18(out[18], in[4], in_not[3], in_not[2], in[1], in_not[0]);
	and out_19(out[19], in[4], in_not[3], in_not[2], in[1], in[0]);
	and out_20(out[20], in[4], in_not[3], in[2], in_not[1], in_not[0]);
	and out_21(out[21], in[4], in_not[3], in[2], in_not[1], in[0]);
	and out_22(out[22], in[4], in_not[3], in[2], in[1], in_not[0]);
	and out_23(out[23], in[4], in_not[3], in[2], in[1], in[0]);
	and out_24(out[24], in[4], in[3], in_not[2], in_not[1], in_not[0]);
	and out_25(out[25], in[4], in[3], in_not[2], in_not[1], in[0]);
	and out_26(out[26], in[4], in[3], in_not[2], in[1], in_not[0]);
	and out_27(out[27], in[4], in[3], in_not[2], in[1], in[0]);
	and out_28(out[28], in[4], in[3], in[2], in_not[1], in_not[0]);
	and out_29(out[29], in[4], in[3], in[2], in_not[1], in[0]);
	and out_30(out[30], in[4], in[3], in[2], in[1], in_not[0]);
	and out_31(out[31], in[4], in[3], in[2], in[1], in[0]);
endmodule
