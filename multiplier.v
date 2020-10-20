module multiplier(data_result, data_operandA, data_operandB, data_exception, data_resultRDY, ctrl_MULT, clock);
	output [31:0] data_result;
	output data_exception, data_resultRDY;

	input [31:0] data_operandA, data_operandB;
	input ctrl_MULT, clock;

	wire clk = clock;
    //not anticlk(clk, clock);

    wire [64:0] newProd;
    wire reset;

    assign reset = 1'b0;
    //and rst(reset, ctrl_MULT, clk);

    // Termination after 16 clock cycles
    wire enable =1'b1;
    wire [5:0] current_count;
	wire not_zero, not_one, not_two, not_three, not_five;
	not n0(not_one, current_count[1]);
	not n1(not_two, current_count[2]);
	not n2(not_three, current_count[3]);
	not n3(not_five, current_count[5]);
        not n4(not_zero, current_count[0]);
    sync_up_counter count(current_count, clock, enable, ctrl_MULT);
    and data_ready(data_resultRDY, not_five, current_count[4], not_three, not_two, not_one, not_zero);

    // Registers
    wire [64:0] currentProd;
    register_65 product(currentProd, newProd, clk, enable, reset);

    wire [64:0] firstProd;

    assign firstProd[64:33] = 32'd0;
    assign firstProd[32:1]  = data_operandB;
    assign firstProd[0] = 1'b0;

    // out, in
    wire [64:0] intermedProd;
    assign intermedProd[64:33] = aluRes;
    assign intermedProd[32:0] = currentProd[32:0];

    wire [64:0] intermedProd_shifted;
    right_shift_by_2_65 rs(intermedProd_shifted, intermedProd);
    // out, select, in0, in1
    mux_2_65bit initMux(newProd, ctrl_MULT, intermedProd_shifted, firstProd);

    wire [2:0] check;
    assign check[2:0] = currentProd[2:0];

    wire low2same;
    xnor xn(low2same, check[1], check[0]);
    wire msb_diff;
    xor msb_diff_from_bottom_two(msb_diff, check[2], check[1]);
    wire shift_select;
    and shift_sel(shift_select, low2same, msb_diff);

    wire [31:0] mult_su;
    wire [31:0] shift_mpc;
    assign shift_mpc = data_operandA << 1;
    mux_2_32bit shift(mult_su, shift_select, data_operandA, shift_mpc);
    
    wire [31:0] term;

    wire msb_same;
    xnor msb_same_from_bottom_two(msb_same, check[2], check[1]);
    wire nothing_select;
    and nothing_sel(nothing_select, low2same, msb_same);

    mux_2_32bit term_gen(term, nothing_select, mult_su, 32'd0);

    wire ovf;
    // A, B, opcode, result, ovf
    wire [31:0] aluRes;
    md_alu adding_alu(currentProd[64:33], term, check[2], aluRes, ovf);

    wire all_one;
    and MSB(all_one, currentProd[64], currentProd[63],currentProd[62],currentProd[61],currentProd[60],
            currentProd[59], currentProd[58], currentProd[57], currentProd[56], currentProd[55],
            currentProd[54], currentProd[53], currentProd[52], currentProd[51], currentProd[50], 
            currentProd[49], currentProd[48], currentProd[47], currentProd[46], currentProd[45], 
            currentProd[44], currentProd[43], currentProd[42], currentProd[41], currentProd[40],
            currentProd[39], currentProd[38], currentProd[37], currentProd[36], currentProd[35], currentProd[34], currentProd[33]);

    wire one_one;
    or msb(one_one, currentProd[64], currentProd[63],currentProd[62],currentProd[61],currentProd[60],
            currentProd[59], currentProd[58], currentProd[57], currentProd[56], currentProd[55],
            currentProd[54], currentProd[53], currentProd[52], currentProd[51], currentProd[50], 
            currentProd[49], currentProd[48], currentProd[47], currentProd[46], currentProd[45], 
            currentProd[44], currentProd[43], currentProd[42], currentProd[41], currentProd[40],
            currentProd[39], currentProd[38], currentProd[37], currentProd[36], currentProd[35], currentProd[34], currentProd[33]);

    wire and_xor;
    xor andx(and_xor, all_one, currentProd[32]);
    wire or_xor;
    xor orx(or_xor, one_one, currentProd[32]);

    wire ovf1, ovf2, ovf3, ovf4, ovf5;

    xnor o1(ovf1, data_operandA[31], data_operandB[31]);
	and o2(ovf2, ovf1, currentProd[32]);

    wire not_msb;
    not ms(not_msb, currentProd[32]);
    xor o3(ovf3, data_operandA[31], data_operandB[31]);
    and o4(ovf4, ovf3, not_msb);

    wire low_one;
	or lsb(low_one, currentProd[32], currentProd[31],currentProd[30],currentProd[29],currentProd[28],
            currentProd[27], currentProd[26], currentProd[25], currentProd[24], currentProd[23],
            currentProd[22], currentProd[21], currentProd[20], currentProd[19], currentProd[18], 
            currentProd[17], currentProd[16], currentProd[15], currentProd[14], currentProd[13], 
            currentProd[12], currentProd[11], currentProd[10], currentProd[9], currentProd[8],
            currentProd[7], currentProd[6], currentProd[5], currentProd[4], currentProd[3], currentProd[2], currentProd[1]);
	
	and lastcase(ovf5, ovf4, low_one);

    or except(data_exception, and_xor, or_xor, ovf2, ovf5);

    assign data_result = currentProd[32:1];
endmodule