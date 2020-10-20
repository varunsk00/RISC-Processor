// ECE350 CP 1: 32-Bit ALU 
// Designed by Varun Kosgi
// Consists of a 32-Bit CSA Adder/Subtractor with 4 8-bit CLA Blocks,
// 32-Bit Left Logical Shifter (Barrel), and
// 32-Bit Right Arithmetic Shifter (Barrel)

// OpCode Table:
// add = 00000
// sub = 00001
// and = 00010
// or  = 00011	
// sll = 00100
// sra = 00101		

module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow, clock);
	input [31:0] data_operandA, data_operandB;
	input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	input clock;

	output [31:0] data_result;
	output isNotEqual, isLessThan, overflow;
	wire Cout, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
	wire add_ovf, sub_ovf, mult_ovf, div_ovf;
	wire [31:0] add, sub, and_bw, or_bw, sll, sra, mult, div;
	wire [31:0] notB;

	//2's complemented negation
	genvar i;
	generate
	for (i=0; i < 32; i = i + 1) begin: loop1
		not invert(notB[i], data_operandB[i]);
	end
	endgenerate

	// Comparing A,B
	xor iLT(isLessThan, sub[31], overflow);

	or iNE(isNotEqual, sub[31], sub[30], sub[29], sub[28], sub[27], sub[26], sub[25], 
	sub[24], sub[23], sub[22], sub[21], sub[20], sub[19], sub[18], sub[17], sub[16],
	sub[15], sub[14], sub[13], sub[12], sub[11], sub[10], sub[9], sub[8], sub[7], 
	sub[6], sub[5], sub[4], sub[3], sub[2], sub[1], sub[0]);

	//case opcode 00000 addition
	csa_32_bit adder(add, Cout, data_operandA, data_operandB, 1'b0);
	not notMSres(w2, data_result[31]);
	not notMSA(w4, data_operandA[31]);
	and term1_add(w1, data_operandA[31], data_operandB[31], w2);
	and term2_add(w3, w4, notB[31], data_result[31]);
	or add_ov(add_ovf, w1, w3);

	//case opcode 00001 subtraction
	csa_32_bit subtractor(sub, Cout, data_operandA, notB, 1'b1);
	not res(w5, data_result[31]);
	not res1(w8, data_operandA[31]);
	and term1(w6, data_operandA[31], notB[31], w5);
	and term2(w7, w8, data_operandB[31], data_result[31]);
	or sub_ov(sub_ovf, w6, w7);

	//case opcode 00010 and
	gen_8_bit low_bits_and(and_bw[7:0], data_operandA[7:0], data_operandB[7:0]);
	gen_8_bit med1_bits_and(and_bw[15:8], data_operandA[15:8], data_operandB[15:8]);
	gen_8_bit med2_bits_and(and_bw[23:16], data_operandA[23:16], data_operandB[23:16]);
	gen_8_bit high_bits_and(and_bw[31:24], data_operandA[31:24], data_operandB[31:24]);

	//case opcode 00011 or
	prop_8_bit low_bits_or(or_bw[7:0], data_operandA[7:0], data_operandB[7:0]);
	prop_8_bit med1_bits_or(or_bw[15:8], data_operandA[15:8], data_operandB[15:8]);
	prop_8_bit med2_bits_or(or_bw[23:16], data_operandA[23:16], data_operandB[23:16]);
	prop_8_bit high_bits_or(or_bw[31:24], data_operandA[31:24], data_operandB[31:24]);

	//case opcode 00100 sll
	barrel_shifter_left bsl(sll, data_operandA, ctrl_shiftamt);

	//case opcode 00101 sra
	barrel_shifter_right bsr(sra, data_operandA, ctrl_shiftamt);

	//case opcode 00110 mult
	wire mulReady;
	multiplier multip(mult, data_operandA, data_operandB, mult_ovf, mulReady, 1'b1, clock);

	//case opcode 00111 div
	wire divReady;
	divider division(div, data_operandA, data_operandB, div_ovf, divReady, 1'b1, clock);

	//ALU,OVF opcodes
	wire as_ovf, md_ovf;
	mux_8 alu_control(data_result, ctrl_ALUopcode, add, sub, and_bw, or_bw, sll, sra, mult, div);
	mux_2_1bit addsub_ovf_control(as_ovf, ctrl_ALUopcode[0], add_ovf, sub_ovf);
	mux_2_1bit multdiv_ovf_control(md_ovf, ctrl_ALUopcode[0], mult_ovf, div_ovf);

	or ovf_final(overflow, as_ovf, md_ovf);

endmodule