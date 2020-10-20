module md_alu(data_operandA, data_operandB, ctrl_ALUopcode, data_result, overflow);
	input [31:0] data_operandA, data_operandB;
	input ctrl_ALUopcode;

	output [31:0] data_result;
	output overflow;
	wire Cout, w1, w2, w3, w4, w5, w6, w7, w8;
	wire add_ovf, sub_ovf;
	wire [31:0] add, sub;
	wire [31:0] notB;

	//2's complemented negation
	genvar i;
	generate
	for (i=0; i < 32; i = i + 1) begin: loop1
		not invert(notB[i], data_operandB[i]);
	end
	endgenerate

	//case opcode 0 addition
	csa_32_bit adder(add, Cout, data_operandA, data_operandB, 1'b0);
	not notMSres(w2, data_result[31]);
	not notMSA(w4, data_operandA[31]);
	and term1_add(w1, data_operandA[31], data_operandB[31], w2);
	and term2_add(w3, w4, notB[31], data_result[31]);
	or add_ov(add_ovf, w1, w3);

	//case opcode 1 subtraction
	csa_32_bit subtractor(sub, Cout, data_operandA, notB, 1'b1);
	not res(w5, data_result[31]);
	not res1(w8, data_operandA[31]);
	and term1(w6, data_operandA[31], notB[31], w5);
	and term2(w7, w8, data_operandB[31], data_result[31]);
	or sub_ov(sub_ovf, w6, w7);

	//ALU,OVF opcodes
	mux_2_32bit alu_control(data_result, ctrl_ALUopcode, add, sub);
	mux_2_1bit ovf_control(overflow, ctrl_ALUopcode, add_ovf, sub_ovf);
endmodule