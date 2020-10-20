module sync_up_counter(out, clock, enable, clr);
	input enable;
	input clock, clr;
	output [5:0] out;

    wire w1, w2, w3, w4, w5, w6, a1, a2, a3, a4, a5, a6;
    xor x1(w1, out[0], enable);
    and and1(a1, enable, out[0]);
    
    xor x2(w2, out[1], a1);
    and and2(a2, a1, out[1]);

    xor x3(w3, out[2], a2);
    and and3(a3, a2, out[2]);

    xor x4(w4, out[3], a3);
    and and4(a4, a3, out[3]);

	xor x5(w5, out[4], a4);
    and and5(a5, a4, out[4]);

	xor x6(w6, out[5], a5);
    and and6(a6, a5, out[5]);
	// flip-flops
	dffe_ref flip0(out[0], w1, clock, enable, clr);
	dffe_ref flip1(out[1], w2, clock, enable, clr);
	dffe_ref flip2(out[2], w3, clock, enable, clr);
	dffe_ref flip3(out[3], w4, clock, enable, clr);
	dffe_ref flip4(out[4], w5, clock, enable, clr);
	dffe_ref flip5(out[5], w6, clock, enable, clr);
endmodule