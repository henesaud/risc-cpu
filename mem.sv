module mem (
  input  logic clk,
	input  logic read,
	input  logic write, 
	input  logic [4:0] addr,
	input  logic [7:0] dataIn,
  output logic [7:0] dataOut
);
timeunit 1ns;
timeprecision 1ns;


logic [7:0] memory [0:31];
  
always @(posedge clk)
  if (write && !read) #1 memory[addr] <= dataIn;

always_ff @(posedge clk iff ((read == '1)&&(write == '0)) )
  dataOut <= memory[addr];

endmodule
