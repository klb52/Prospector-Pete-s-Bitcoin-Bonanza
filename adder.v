module adder(in_A, in_B, sum);
	input [31:0] in_A, in_B;
	output [31:0] sum;
	wire [7:0]carry_in;
	wire carry_c = 1'b0; 

	bit4_adder my_0adder(in_A[3:0], in_B[3:0], carry_c, carry_in[0], sum[3:0]);
	bit4_adder my_1adder(in_A[7:4], in_B[7:4], carry_in[0], carry_in[1], sum[7:4]);
	bit4_adder my_2adder(in_A[11:8], in_B[11:8], carry_in[1], carry_in[2], sum[11:8]);
	bit4_adder my_3adder(in_A[15:12], in_B[15:12], carry_in[2], carry_in[3], sum[15:12]);
	bit4_adder my_4adder(in_A[19:16], in_B[19:16], carry_in[3], carry_in[4], sum[19:16]);
	bit4_adder my_5adder(in_A[23:20], in_B[23:20], carry_in[4], carry_in[5], sum[23:20]);
	bit4_adder my_6adder(in_A[27:24], in_B[27:24], carry_in[5], carry_in[6], sum[27:24]);
	bit4_adder my_7adder(in_A[31:28], in_B[31:28], carry_in[6], carry_in[7], sum[31:28]);
endmodule

module bit4_adder(in_A, in_B, carry_in, carry_out, sum);
	input [3:0] in_A, in_B;
	output [3:0] sum;
	input carry_in;
	output carry_out;
	wire carry_1 = 1'b1;
	wire carry_0 = 1'b0;
	wire [3:0] carry_1out, carry_0out; 
	wire [3:0] temp_0, temp_1;  
	bit1_adder mybit_0adder(in_A[0], in_B[0], carry_0, carry_0out[0], temp_0[0]);
	bit1_adder mybit_1adder(in_A[1], in_B[1], carry_0out[0], carry_0out[1], temp_0[1]);
	bit1_adder mybit_2adder(in_A[2], in_B[2], carry_0out[1], carry_0out[2], temp_0[2]);
	bit1_adder mybit_3adder(in_A[3], in_B[3], carry_0out[2], carry_0out[3], temp_0[3]);

	bit1_adder mybit_4adder(in_A[0], in_B[0], carry_1, carry_1out[0], temp_1[0]);
	bit1_adder mybit_5adder(in_A[1], in_B[1], carry_1out[0], carry_1out[1], temp_1[1]);
	bit1_adder mybit_6adder(in_A[2], in_B[2], carry_1out[1], carry_1out[2], temp_1[2]);
	bit1_adder mybit_7adder(in_A[3], in_B[3], carry_1out[2], carry_1out[3], temp_1[3]);  
	assign sum = carry_in ? temp_1 : temp_0;
	assign carry_out = carry_in ? carry_1out[3] : carry_0out[3]; 
   
endmodule

module bit1_adder(in_A, in_B, carry_in, carry_out, sum);
	input in_A, in_B, carry_in;
	output sum, carry_out;
	
	wire temp[2:0];
	xor(sum, in_A, in_B, carry_in);
	and(temp[0], in_A, in_B);
	and(temp[1], in_A, carry_in);
	and(temp[2], in_B, carry_in);
	or(carry_out, temp[0], temp[1], temp[2]);
	
endmodule

module my_3xor(ina, inb, inc, out);
	input [31:0] ina, inb, inc;
	output [31:0] out;
	
	genvar c;
	generate
	for(c=0; c<32; c=c+1) begin: loop1
	assign out[c] = ina[c]^inb[c]^inc[c];
	end
	endgenerate

endmodule

module my_rr(data_in, sel, data_out);
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

module my_sra(data_in, sel, data_out);
	input [31:0] data_in;
	input [4:0] sel;
	output [31:0] data_out;
	
	// Mux level 0
	wire [31:0] level_0, level_1, level_2, level_3;
	genvar c;
	generate
		for(c=0; c<31; c=c+1) begin: loop1
			usr_mux m(data_in[c], data_in[c+1], sel[0], level_0[c]);
		end
	endgenerate
	usr_mux m0(data_in[31], data_in[31], sel[0], level_0[31]);
	
	// Mux level 1
	generate
		for(c=0; c<30; c=c+1) begin: loop2
			usr_mux m(level_0[c], level_0[c+2], sel[1], level_1[c]);
		end
	endgenerate
	
	generate
		for(c=30; c<=31; c=c+1) begin: loop3
			usr_mux m(level_0[c], data_in[31], sel[1], level_1[c]);
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
			usr_mux m(level_1[c], data_in[31], sel[2], level_2[c]);
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
			usr_mux m(level_2[c], data_in[31], sel[3], level_3[c]);
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
			usr_mux m(level_3[c], data_in[31], sel[4], data_out[c]);
		end
	endgenerate

endmodule

// my mux used throughout
module usr_mux(x1, x2, sel, out);
	input x1, x2, sel;
	output out;
	
	assign out = (x1&~sel)||(x2&sel);

endmodule