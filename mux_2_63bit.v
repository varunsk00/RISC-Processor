module mux_2_63bit(out, select, in0, in1);
	input select;
	input [62:0] in0, in1;
	output [62:0] out;
	assign out = select ? in1 : in0;
endmodule