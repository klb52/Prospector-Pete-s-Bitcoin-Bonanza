module bitcoin_miner(in, sel, out);
	input [31:0] in;
	input [4:0] sel;
	output [31:0] out;

	rotate_r myr(in, sel, out);

endmodule


module rotate_r(data_in, sel, data_out);
	input [31:0] data_in;
	input [4:0] sel;
	output [31:0] data_out;
	
	wire [31:0] level_0, level_1, level_2, level_3;
	
	// Mux level 0
	genvar c;
	generate
		for(c=0; c<31; c=c+1) begin: loop1
			usr_mux m(data_in[c], data_in[c+1], sel[0], level_0[c]);
		end
	endgenerate
	usr_mux m0(data_in[31], data_in[0], sel[0], level_0[31]);
	
	// Mux level 1
	generate
		for(c=0; c<30; c=c+1) begin: loop2
			usr_mux m(level_0[c], level_0[c+2], sel[1], level_1[c]);
		end
	endgenerate
	
	generate
		for(c=30; c<=31; c=c+1) begin: loop3
			usr_mux m(level_0[c], level_0[c-30], sel[1], level_1[c]);
		end
	endgenerate
	
	// Mux level 2
	generate
		for(c=0; c<=27; c=c+1) begin: loop4
			usr_mux m(level_1[c], level_1[c+4], sel[2], level_2[c]);
		end
	endgenerate
	
	generate
		for(c=28; c<=31; c=c+1) begin: loop5
			usr_mux m(level_1[c], level_1[c-28], sel[2], level_2[c]);
		end
	endgenerate
	
	// Mux level 3
	generate
		for(c=0; c<=23; c=c+1) begin: loop6
			usr_mux m(level_2[c], level_2[c+8], sel[3], level_3[c]);
		end
	endgenerate
	
	generate
		for(c=24; c<=31; c=c+1) begin: loop7
			usr_mux m(level_2[c], level_2[c-24], sel[3], level_3[c]);
		end
	endgenerate
	
	// Mux level 4
	generate
		for(c=0; c<=15; c=c+1) begin: loop8
			usr_mux m(level_3[c], level_3[c+16], sel[4], data_out[c]);
		end
	endgenerate
	
	generate
		for(c=16; c<=31; c=c+1) begin: loop9
			usr_mux m(level_3[c], level_3[c-16], sel[4], data_out[c]);
		end
	endgenerate

endmodule

// my mux used throughout
module usr_mux(x1, x2, sel, out);
	input x1, x2, sel;
	output out;
	
	assign out = (x1&~sel)||(x2&sel);

endmodule