module mux_2_8bit(out, select, in0, in1);
	input select;
	input [7:0] in0, in1;
	output [7:0] out;
	assign out = select ? in1 : in0;
endmodule