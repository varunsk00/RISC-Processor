module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] enable, w_decoder_out, r1_decoder_out, r2_decoder_out;

	wire [31:0] reg_out0, reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, reg_out9, 
			reg_out10, reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16, reg_out17, reg_out18, reg_out19, reg_out20, reg_out21, 
			reg_out22, reg_out23, reg_out24, reg_out25, reg_out26, reg_out27, reg_out28, reg_out29, reg_out30, reg_out31;
	
	decoder_32 decode1(w_decoder_out, ctrl_writeReg);
	decoder_32 decode2(r1_decoder_out, ctrl_readRegA);
	decoder_32 decode3(r2_decoder_out, ctrl_readRegB);

	//generate enables for reg
	genvar i;
	generate
	for (i=0; i < 32; i = i + 1) begin: loop1
		and en(enable[i], ctrl_writeEnable, w_decoder_out[i]);
	end
	endgenerate
	
	// registers
	register_32 reg0(reg_out0, 32'd0, clock, 1'b1, ctrl_reset);
	register_32 reg1(reg_out1, data_writeReg, clock, enable[1], ctrl_reset);
	register_32 reg2(reg_out2, data_writeReg, clock, enable[2], ctrl_reset);
	register_32 reg3(reg_out3, data_writeReg, clock, enable[3], ctrl_reset);
	register_32 reg4(reg_out4, data_writeReg, clock, enable[4], ctrl_reset);
	register_32 reg5(reg_out5, data_writeReg, clock, enable[5], ctrl_reset);
	register_32 reg6(reg_out6, data_writeReg, clock, enable[6], ctrl_reset);
	register_32 reg7(reg_out7, data_writeReg, clock, enable[7], ctrl_reset);
	register_32 reg8(reg_out8, data_writeReg, clock, enable[8], ctrl_reset);
	register_32 reg9(reg_out9, data_writeReg, clock, enable[9], ctrl_reset);
	register_32 reg10(reg_out10, data_writeReg, clock, enable[10], ctrl_reset);
	register_32 reg11(reg_out11, data_writeReg, clock, enable[11], ctrl_reset);
	register_32 reg12(reg_out12, data_writeReg, clock, enable[12], ctrl_reset);
	register_32 reg13(reg_out13, data_writeReg, clock, enable[13], ctrl_reset);
	register_32 reg14(reg_out14, data_writeReg, clock, enable[14], ctrl_reset);
	register_32 reg15(reg_out15, data_writeReg, clock, enable[15], ctrl_reset);
	register_32 reg16(reg_out16, data_writeReg, clock, enable[16], ctrl_reset);
	register_32 reg17(reg_out17, data_writeReg, clock, enable[17], ctrl_reset);
	register_32 reg18(reg_out18, data_writeReg, clock, enable[18], ctrl_reset);
	register_32 reg19(reg_out19, data_writeReg, clock, enable[19], ctrl_reset);
	register_32 reg20(reg_out20, data_writeReg, clock, enable[20], ctrl_reset);
	register_32 reg21(reg_out21, data_writeReg, clock, enable[21], ctrl_reset);
	register_32 reg22(reg_out22, data_writeReg, clock, enable[22], ctrl_reset);
	register_32 reg23(reg_out23, data_writeReg, clock, enable[23], ctrl_reset);
	register_32 reg24(reg_out24, data_writeReg, clock, enable[24], ctrl_reset);
	register_32 reg25(reg_out25, data_writeReg, clock, enable[25], ctrl_reset);
	register_32 reg26(reg_out26, data_writeReg, clock, enable[26], ctrl_reset);
	register_32 reg27(reg_out27, data_writeReg, clock, enable[27], ctrl_reset);
	register_32 reg28(reg_out28, data_writeReg, clock, enable[28], ctrl_reset);
	register_32 reg29(reg_out29, data_writeReg, clock, enable[29], ctrl_reset);
	register_32 reg30(reg_out30, data_writeReg, clock, enable[30], ctrl_reset);
	register_32 reg31(reg_out31, data_writeReg, clock, enable[31], ctrl_reset);
	
	// data_readRegA
	tri_state_buff buff0(data_readRegA, reg_out0, r1_decoder_out[0]);
	tri_state_buff buff1(data_readRegA, reg_out1, r1_decoder_out[1]);
	tri_state_buff buff2(data_readRegA, reg_out2, r1_decoder_out[2]);
	tri_state_buff buff3(data_readRegA, reg_out3, r1_decoder_out[3]);
	tri_state_buff buff4(data_readRegA, reg_out4, r1_decoder_out[4]);
	tri_state_buff buff5(data_readRegA, reg_out5, r1_decoder_out[5]);
	tri_state_buff buff6(data_readRegA, reg_out6, r1_decoder_out[6]);
	tri_state_buff buff7(data_readRegA, reg_out7, r1_decoder_out[7]);
	tri_state_buff buff8(data_readRegA, reg_out8, r1_decoder_out[8]);
	tri_state_buff buff9(data_readRegA, reg_out9, r1_decoder_out[9]);
	tri_state_buff buff10(data_readRegA, reg_out10, r1_decoder_out[10]);
	tri_state_buff buff11(data_readRegA, reg_out11, r1_decoder_out[11]);
	tri_state_buff buff12(data_readRegA, reg_out12, r1_decoder_out[12]);
	tri_state_buff buff13(data_readRegA, reg_out13, r1_decoder_out[13]);
	tri_state_buff buff14(data_readRegA, reg_out14, r1_decoder_out[14]);
	tri_state_buff buff15(data_readRegA, reg_out15, r1_decoder_out[15]);
	tri_state_buff buff16(data_readRegA, reg_out16, r1_decoder_out[16]);
	tri_state_buff buff17(data_readRegA, reg_out17, r1_decoder_out[17]);
	tri_state_buff buff18(data_readRegA, reg_out18, r1_decoder_out[18]);
	tri_state_buff buff19(data_readRegA, reg_out19, r1_decoder_out[19]);
	tri_state_buff buff20(data_readRegA, reg_out20, r1_decoder_out[20]);
	tri_state_buff buff21(data_readRegA, reg_out21, r1_decoder_out[21]);
	tri_state_buff buff22(data_readRegA, reg_out22, r1_decoder_out[22]);
	tri_state_buff buff23(data_readRegA, reg_out23, r1_decoder_out[23]);
	tri_state_buff buff24(data_readRegA, reg_out24, r1_decoder_out[24]);
	tri_state_buff buff25(data_readRegA, reg_out25, r1_decoder_out[25]);
	tri_state_buff buff26(data_readRegA, reg_out26, r1_decoder_out[26]);
	tri_state_buff buff27(data_readRegA, reg_out27, r1_decoder_out[27]);
	tri_state_buff buff28(data_readRegA, reg_out28, r1_decoder_out[28]);
	tri_state_buff buff29(data_readRegA, reg_out29, r1_decoder_out[29]);
	tri_state_buff buff30(data_readRegA, reg_out30, r1_decoder_out[30]);
	tri_state_buff buff31(data_readRegA, reg_out31, r1_decoder_out[31]);

	// data_readRegB
	tri_state_buff buff32(data_readRegB, reg_out0, r2_decoder_out[0]);
	tri_state_buff buff33(data_readRegB, reg_out1, r2_decoder_out[1]);
	tri_state_buff buff34(data_readRegB, reg_out2, r2_decoder_out[2]);
	tri_state_buff buff35(data_readRegB, reg_out3, r2_decoder_out[3]);
	tri_state_buff buff36(data_readRegB, reg_out4, r2_decoder_out[4]);
	tri_state_buff buff37(data_readRegB, reg_out5, r2_decoder_out[5]);
	tri_state_buff buff38(data_readRegB, reg_out6, r2_decoder_out[6]);
	tri_state_buff buff39(data_readRegB, reg_out7, r2_decoder_out[7]);
	tri_state_buff buff40(data_readRegB, reg_out8, r2_decoder_out[8]);
	tri_state_buff buff41(data_readRegB, reg_out9, r2_decoder_out[9]);
	tri_state_buff buff42(data_readRegB, reg_out10, r2_decoder_out[10]);
	tri_state_buff buff43(data_readRegB, reg_out11, r2_decoder_out[11]);
	tri_state_buff buff44(data_readRegB, reg_out12, r2_decoder_out[12]);
	tri_state_buff buff45(data_readRegB, reg_out13, r2_decoder_out[13]);
	tri_state_buff buff46(data_readRegB, reg_out14, r2_decoder_out[14]);
	tri_state_buff buff47(data_readRegB, reg_out15, r2_decoder_out[15]);
	tri_state_buff buff48(data_readRegB, reg_out16, r2_decoder_out[16]);
	tri_state_buff buff49(data_readRegB, reg_out17, r2_decoder_out[17]);
	tri_state_buff buff50(data_readRegB, reg_out18, r2_decoder_out[18]);
	tri_state_buff buff51(data_readRegB, reg_out19, r2_decoder_out[19]);
	tri_state_buff buff52(data_readRegB, reg_out20, r2_decoder_out[20]);
	tri_state_buff buff53(data_readRegB, reg_out21, r2_decoder_out[21]);
	tri_state_buff buff54(data_readRegB, reg_out22, r2_decoder_out[22]);
	tri_state_buff buff55(data_readRegB, reg_out23, r2_decoder_out[23]);
	tri_state_buff buff56(data_readRegB, reg_out24, r2_decoder_out[24]);
	tri_state_buff buff57(data_readRegB, reg_out25, r2_decoder_out[25]);
	tri_state_buff buff58(data_readRegB, reg_out26, r2_decoder_out[26]);
	tri_state_buff buff59(data_readRegB, reg_out27, r2_decoder_out[27]);
	tri_state_buff buff60(data_readRegB, reg_out28, r2_decoder_out[28]);
	tri_state_buff buff61(data_readRegB, reg_out29, r2_decoder_out[29]);
	tri_state_buff buff62(data_readRegB, reg_out30, r2_decoder_out[30]);
	tri_state_buff buff63(data_readRegB, reg_out31, r2_decoder_out[31]);
endmodule