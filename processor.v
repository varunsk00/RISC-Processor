/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements.
 *
 *
 */

module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile

	);

	// Control signals
	input clock, reset;

	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

  wire[31:0] branched_pc, normWrite;
  wire [31:0] op2;
  wire alu2, addi2, sw2, lw2, jump2, bne2, jal2, jr2, blt2, bex2, setx2;
  wire i_type2, r_type2, ji_type2, jii_type2;
  wire iNe, iLt, ovf, sw3;

    // Decoder for OpCodes
    wire [31:0] op;
    wire [31:0] nop = 32'd0;
    decoder_32 opCode(op, q_imem[31:27]);
    wire alu, addi, sw, lw, jump, bne, jal, jr, blt, bex, setx;
    wire i_type, r_type, ji_type, jii_type;
    assign alu = op[0];
    assign addi = op[5];
    assign sw = op[7];
    assign lw = op[8];
    assign jump = op[1];
    assign bne = op[2];
    assign jal = op[3];
    assign jr = op[4];
    assign blt = op[6];
    assign bex = op[22];
    assign setx = op[21];

    assign r_type = alu;
    or iType(i_type, addi, sw, lw, bne, blt);
    or jiType(ji_type, jump, jal, bex, setx);
    assign jii_type = jr;

    // Program Counter
    wire[31:0] pc_out;
    wire[31:0] pc_inc;
    wire Co;
    wire enable = 1'b1;
	register_32 program_counter(pc_out, pc_inc, clock, (~hazard || ~branch), reset);
    wire[31:0] pc_inc_normal;
    wire[31:0] pc_incremented;
    csa_32_bit incrementor(pc_inc_normal, Co, pc_out, 32'd1, 1'b0);

    // Assert True if branch instruction and correct
    wire blt_true;
    and isLessthan(blt_true, blt2, iLt);
    wire bne_true;
    and isNotEqual(bne_true, bne2, iNe);

    //Assert True if PC to be jumped
    wire jumped_pc;
    wire bex_true;
    assign bex_true = ~(dx_out[95:64] == 32'd0); //rstatus != 0
    or pc_j(jumped_pc, jump2, jal2, (bex2&&bex_true));

    //Muxes between normal PC, branched PCs, or jumped PCs
    wire[31:0] b1, b2, j1, j2;
    wire [31:0] target;
    assign target[31:0] = dx_out[26:0];
    mux_2_32bit branched_mux(b1, (blt_true || bne_true), pc_inc_normal, branched_pc);
    mux_2_32bit jumped_mux(j1, jumped_pc, b1, target);
    mux_2_32bit jr_mux(pc_inc, jii_type2, j1, dx_out[95:64]); //dataReadRegA with $rd as ctrl_ReadReg
    //Choose appropriate instruction
    wire[31:0] intm, intm2;
    mux_2_32bit fetch_instruction__mux(intm, branch, pc_out, branched_pc);
    mux_2_32bit fetch_instruction__mux1(intm2, jumped_pc, intm, target);
    mux_2_32bit fetch_instruction__mux2(address_imem, jr2, intm2, dx_out[95:64]);

    // Fetch/Decode Register (Top Half = PC incremented, Bottom Half = Instruction)
    wire[63:0] fd_out, fd_in;
    assign fd_in[63:32] = pc_inc;
    mux_2_32bit fd_nop_mux(fd_in[31:0], branch, q_imem, nop);
    register_64 fetch_decode(fd_out, fd_in, clock, (~hazard || ~branch), reset);

    // Decoded OpCodes
    wire [31:0] op1;
    decoder_32 opCode1(op1, fd_out[31:27]);
    wire alu1, addi1, sw1, lw1, jump1, bne1, jal1, jr1, blt1, bex1, setx1;
    wire i_type1, r_type1, ji_type1, jii_type1;
    assign alu1 = op1[0];
    assign addi1 = op1[5];
    assign sw1 = op1[7];
    assign lw1 = op1[8];
    assign jump1 = op1[1];
    assign bne1 = op1[2];
    assign jal1 = op1[3];
    assign jr1 = op1[4];
    assign blt1 = op1[6];
    assign bex1 = op1[22];
    assign setx1 = op1[21];

    assign r_type1 = alu1;
    or iType1(i_type1, addi1, sw1, lw1, bne1, blt1);
    or jiType1(ji_type1, jump1, jal1, bex1, setx1);
    assign jii_type1 = jr1;

    wire [4:0] rd, rs, rt, shamt, aluop;
    assign rs = fd_out[21:17];
    // Only if R type instruction
    mux_2_5bit rvi(rt, r_type, 5'd0, fd_out[16:12]);

    //STALLING LOGIC
    wire[4:0] rs1;
    wire[4:0] rs2;
    assign rs1 = fd_out[21:17];
    mux_2_5bit rv2(rs2, r_type, 5'd0, fd_out[16:12]);

    wire[4:0] LOAD = 5'b01000;
    wire[4:0] STORE = 5'b00111;
    assign stall = (dx_out[31:27] == LOAD) && (((rs1==dx_out[26:22]) || (rs2 == dx_out[26:22])) && (fd_in[31:27] != STORE)) && ~(rs1==5'd0) && ~(rs2==5'd0) && ~(dx_out[26:22]==5'd0);
    or haz_detect(hazard, stall);

    //BYPASS LOGIC
    wire [31:0] ALUinA, ALUinB, dmem_in;
    wire [1:0] a_select;
    wire bp1;
    assign bp1 = (dx_out[21:17] == xm_out[26:22]) && ~(dx_out[21:17]==5'd0) && ~(xm_out[26:22]==5'd0);
    wire bp2;
    assign bp2 = (dx_out[21:17] == mw_out[26:22]) && ~(dx_out[21:17]==5'd0) && ~(mw_out[26:22]==5'd0) && ~(mw_out[31:27] == STORE);
    assign a_select[0] = bp2 ? 1'b1 : 1'b0;
    assign a_select[1] = (~bp1 && ~bp2) ? 1'b1 : 1'b0;
    mux_4 aluA(ALUinA, a_select, xm_out[95:64], normWrite, dx_out[95:64], 32'd0);

    wire [1:0] b_select;
    wire bp3;
    assign bp3 = (dx_out[16:12] == xm_out[26:22]) && ~(dx_out[16:12]==5'd0) && ~(xm_out[26:22]==5'd0);
    wire bp4;
    assign bp4 = (dx_out[16:12] == mw_out[26:22]) && ~(dx_out[16:12]==5'd0) && ~(mw_out[26:22]==5'd0);
    assign b_select[0] = bp4 ? 1'b1 : 1'b0;
    assign b_select[1] = (~bp3 && ~bp4) ? 1'b1 : 1'b0;
    mux_4 aluB(ALUinB, b_select, xm_out[95:64], normWrite, dx_out[63:32], 32'd0);

    wire bp5;
    assign bp5 = (mw_out[26:22]== xm_out[26:22]) && ~(mw_out[26:22]==5'd0) && ~(xm_out[26:22]==5'd0);
    wire[31:0] data_intmd;
    mux_2_32bit dm_mux(data_intmd, bp5, xm_out[63:32], normWrite);

    // Lookup RegFile
    wire isBranch, isJR, isBex;
    wire[4:0] ctrl_A_Intmd, ctrl_A_Intmd2;
    assign isBranch = (fd_out[31:27] == 5'b00010 || fd_out[31:27] == 5'b00110);
    assign isJR = (fd_out[31:27] == 5'b00100);
    assign isBex = (fd_out[31:27] == 5'b10110);
    //Changes parts of instruction to lookup based on instruction type
    mux_2_5bit ABranchvNorm(ctrl_A_Intmd, (isBranch || isJR), rs, fd_out[26:22]); //Branch or JR (A)
    mux_2_5bit bexvNorm(ctrl_A_Intmd2, isBex, ctrl_A_Intmd, 5'd30); //Bex (A)
    mux_2_5bit normvssw(ctrl_readRegA, sw3, ctrl_A_Intmd2, xm_out[26:22]); //SW (A)
    mux_2_5bit BbranchvNorm(ctrl_readRegB, isBranch, rt, fd_out[21:17]); //Branch (B)

    // Decode/Execute Register (PC incremented, A, B, Instruction)
    wire[127:0] dx_out, dx_in;
    assign dx_in[127:96] = fd_out[63:32];
    assign dx_in[95:64] = data_readRegA;
    assign dx_in[63:32] = data_readRegB;

    // Flushes dx.IR if branch or Hazard

    or branch_occurence(branch, blt_true, bne_true);
    mux_2_32bit haz_nop_mux(dx_in[31:0], (hazard || branch), fd_out[31:0], nop);

    register_128 decode_execute(dx_out, dx_in, clock, enable, reset);

    // Choose between normal ALUOP and immediate (automatic add)
    mux_2_5bit aluopmux(aluop, i_type2, dx_out[6:2], 5'd0);
    assign shamt = dx_out[11:7];

    //Shifted Immediate Value
    wire[16:0] immed;
    assign immed = dx_out[16:0];
    wire[31:0] immed_extended;
    sign_extend_32 im_ext(immed_extended, immed);

    //PC branch (+N)
    wire[31:0] pc_branch_amt;
    assign pc_branch_amt = immed_extended;
    wire Cout;
    csa_32_bit jumper(branched_pc, Cout, dx_out[127:96], pc_branch_amt, 1'b0);

    // Decoded OpCodes
    decoder_32 opCode2(op2, dx_out[31:27]);
    assign alu2 = op2[0];
    assign addi2 = op2[5];
    assign sw2 = op2[7];
    assign lw2 = op2[8];
    assign jump2 = op2[1];
    assign bne2 = op2[2];
    assign jal2 = op2[3];
    assign jr2 = op2[4];
    assign blt2 = op2[6];
    assign bex2 = op2[22];
    assign setx2 = op2[21];

    assign r_type2 = alu2;
    or iType2(i_type2, addi2, sw2, lw2, bne2, blt2);
    or jiType2(ji_type2, jump2, jal2, bex2, setx2);
    assign jii_type2 = jr2;

    // ALU
    wire [31:0] aluRes;
    wire[31:0] operand_A;
    wire[31:0] operand_B;
    //out, select, data_operandB, immediate value(sign extended)
    mux_2_32bit immed_mux(operand_B, (addi2 || sw2 || lw2), dx_out[63:32], immed_extended);
    alu myALU(ALUinA, operand_B, aluop, shamt, aluRes, iNe, iLt, ovf, clock);

    // Execute/Memory Register (AluRes, B, Instruction)
    wire[95:0] xm_out, xm_in;
    assign xm_in[95:64] = aluRes;
    assign xm_in[63:32] = ALUinB;
    assign xm_in[31:0] = dx_out[31:0];
    register_96 execute_memory(xm_out, xm_in, clock, enable, reset);

    // Decoded OpCodes
    wire [31:0] op3;
    decoder_32 opCode3(op3, xm_out[31:27]);
    wire alu3, addi3, lw3, jump3, bne3, jal3, jr3, blt3, bex3, setx3;
    assign alu3 = op3[0];
    assign addi3 = op3[5];
    assign sw3 = op3[7];
    assign lw3 = op3[8];
    assign jump3 = op3[1];
    assign bne3 = op3[2];
    assign jal3 = op3[3];
    assign jr3 = op3[4];
    assign blt3 = op3[6];
    assign bex3 = op3[22];
    assign setx3 = op3[21];

    // DataMem
    assign address_dmem = xm_out[95:64];
    assign rd_xm = xm_out[26:22];
    assign rs_xm = xm_out[21:17];
    mux_2_32bit lwswmux(data, sw3, data_intmd, data_readRegA);
    // if SW called, data_mem needed
    assign wren = sw3;

    // Memory/WriteBack Register (AluRes, Data, Instruction)
    wire[95:0] mw_out, mw_in;
    assign mw_in[95:64] = xm_out[95:64];
    assign mw_in[63:32] = q_dmem;
    assign mw_in[31:0] = xm_out[31:0];
    register_96 memory_writeback(mw_out, mw_in, clock, enable, reset);

    // Decoded OpCodes
    wire [31:0] op4;
    decoder_32 opCode4(op4, mw_out[31:27]);
    wire alu4, addi4, sw4, lw4, jump4, bne4, jal4, jr4, blt4, bex4, setx4;
    wire i_type4, r_type4, ji_type4, jii_type4;
    assign alu4 = op4[0];
    assign addi4 = op4[5];
    assign sw4 = op4[7];
    assign lw4 = op4[8];
    assign jump4 = op4[1];
    assign bne4 = op4[2];
    assign jal4 = op4[3];
    assign jr4 = op4[4];
    assign blt4 = op4[6];
    assign bex4 = op4[22];
    assign setx4 = op4[21];

    assign r_type4 = alu4;
    or iType4(i_type4, addi4, sw4, lw4, bne4, blt4);
    or jiType4(ji_type4, jump4, jal4, bex4, setx4);
    assign jii_type4 = jr4;

    //Register to write to
    wire rd_written;
    or rd_write(rd_written, r_type4, addi4, lw4);
    wire[4:0] r_write;

    //Selects between rd, r31(for JAL), and r30 (setx)
    wire [4:0] rd_or_r31;
    mux_2_5bit regWriteMux(rd_or_r31, rd_written, 5'd31, mw_out[26:22]);
    mux_2_5bit rstatusmux(ctrl_writeReg, setx4, rd_or_r31, 5'd30);

    //RegFile Write Enable
    or rwe(ctrl_writeEnable, r_type4, addi4, lw4, jal4);

    // Mux to choose between ALURes and DataMem (load word)
    mux_2_32bit regWriteDataMux(normWrite, lw4, mw_out[95:64], q_dmem);

    // Muxes to choose between normal data, JAL data (PC+1), and setx data
    wire[31:0] data_WRintermed;
    mux_2_32bit regJALdatamux(data_WRintermed, jal4, normWrite, pc_inc_normal);
    wire[31:0] setx_target;
    assign setx_target[26:0] = mw_out[26:0];
    mux_2_32bit regsetxdatamux(data_writeReg, setx4, data_WRintermed, setx_target);

endmodule
