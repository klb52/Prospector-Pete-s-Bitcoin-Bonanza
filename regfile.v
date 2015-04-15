module regFile(in, out);
	input [31:0] in;
	output [31:0] out;

endmodule

module register(in, clr, clk, clk_en, out);
	input clr, clk, clk_en;
	input [31:0] in;
	output [31:0] out;
	
	// Loop generates one register
	genvar i;
	generate
	for(i=0; i <= 31; i=i+1) begin: loop1
		dff_b diff1(in[i], clr, clk, clk_en, out[i]); // generate dff's
	end
	endgenerate
	
endmodule

/**
This mdodule was taken from lecture 4 notes.
**/
module dff_a(d, clr, clk, q); 
	input d, clr, clk;
	output q; 
	reg q;
	
	always @(posedge clk or posedge clr) begin
		if(clr) begin 
			q = 1'b0;
		end else begin 
			q = d;
		end
	end
endmodule

module dff_b(d, clr, clk, clk_en, q); 
	input d, clr, clk, clk_en;
	output q; 
	reg q;
	
	always @(posedge clk or posedge clr) begin
		if(clr) begin 
			q = 1'b0;
		end else begin
			if(clk_en) begin
				q = d;
			end
		end
	end
endmodule