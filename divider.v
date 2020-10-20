module divider(data_result, data_operandA, data_operandB, data_exception, data_resultRDY, ctrl_DIV, clock);
	output [31:0] data_result;
	output data_exception, data_resultRDY;

    // Dividend = A, Divisor = B
	input [31:0] data_operandA, data_operandB;
	input ctrl_DIV, clock;

	wire dividend_sign = data_operandA[31];
	wire divisor_sign = data_operandB[31];

	wire [31:0] A_neg, B_neg;
	negator a(A_neg, data_operandA);
	negator b(B_neg, data_operandB);

	wire [31:0] dividend, divisor;

	mux_2_32bit divid(dividend, dividend_sign, data_operandA, A_neg);
	mux_2_32bit divis(divisor, divisor_sign, data_operandB, B_neg);

	wire clk = clock;
    //not anticlk(clk, clock);

    wire [63:0] newRemQuo;
    wire reset;

    assign reset = 1'b0;
    //and rst(reset, ctrl_DIV, clk);

    // Termination after 32 clock cycles
    wire enable =1'b1;
    wire [5:0] current_count;
	wire not_four, not_three, not_two, not_one;
	not n0(not_one, current_count[1]);
	not n1(not_two, current_count[2]);
	not n2(not_three, current_count[3]);
	not n3(not_four, current_count[4]);
    sync_up_counter count(current_count, clock, enable, ctrl_DIV);
	//stop at cycle 34 (100010)
    and data_ready(data_resultRDY, current_count[5], not_four, not_three, not_two, not_one, current_count[0]);

	// Registers
    wire [63:0] currentRemQuo;
    register_64 quotient(currentRemQuo, newRemQuo, clk, enable, reset);

	wire [63:0] firstRemQuo;

    assign firstRemQuo[63:32] = 32'd0;
    assign firstRemQuo[31:0]  = dividend;

	// out, in
    wire [63:0] intermedRemQuo;
    assign intermedRemQuo[63:32] = aluRes;
    assign intermedRemQuo[31:0] = currentRemQuo[31:0];

    wire [63:0] intermedRemQuo_shifted;
    left_shift_by_1_64 ls(intermedRemQuo_shifted, intermedRemQuo);
    // out, select, in0, in1
    mux_2_63bit initMux(newRemQuo[63:1], ctrl_DIV, intermedRemQuo_shifted[63:1], firstRemQuo[63:1]);
	mux_2_1bit lastbitMux(newRemQuo[0], ctrl_DIV, shiftedRemSign_not, firstRemQuo[0]);

	wire remSign = currentRemQuo[63];
	wire notRemSign;
	not nrs(notRemSign, remSign);

	wire shiftedremSign = intermedRemQuo_shifted[63];
	wire shiftedRemSign_not;
	not ns(shiftedRemSign_not, shiftedremSign);

	wire ovf;
	wire [31:0] aluRes;
	//A,B, opcode, res, ovf
    md_alu rem_alu(currentRemQuo[63:32], divisor, notRemSign, aluRes, ovf);

	wire co;
	wire [31:0] adder_res;
	// sum, cout, a,b, cin
	csa_32_bit add(adder_res, co, currentRemQuo[63:32], divisor, 1'b0);

    // out, select, ino0, in1
	wire [31:0] remainder;
    mux_2_32bit final_mux(remainder, shiftedremSign, intermedRemQuo_shifted[63:32], adder_res);

	nor divbyzero(data_exception, data_operandB[31], data_operandB[30], data_operandB[29], data_operandB[28],
					data_operandB[27], data_operandB[26], data_operandB[25], data_operandB[24], data_operandB[23],
					data_operandB[22], data_operandB[21], data_operandB[20], data_operandB[19], data_operandB[18],
					data_operandB[17], data_operandB[16], data_operandB[15], data_operandB[14], data_operandB[13],
					data_operandB[12], data_operandB[11], data_operandB[10], data_operandB[9], data_operandB[8],
					data_operandB[7], data_operandB[6], data_operandB[5], data_operandB[4], data_operandB[3],
					data_operandB[2], data_operandB[1], data_operandB[0]);

	wire[31:0] res;
	mux_2_32bit excep(res, data_exception, currentRemQuo[31:0], 32'd0);
	wire[31:0] notRes;
	negator not_res(notRes, res);
	
	wire quot_neg;
	xor posq(quot_neg, dividend_sign, divisor_sign);

	mux_2_32bit final(data_result, quot_neg, res, notRes);

endmodule