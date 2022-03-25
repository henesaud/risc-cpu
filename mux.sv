module mux #(WIDTH = 1)
                  (output logic [WIDTH-1:0] out,
                   input  logic [WIDTH-1:0] in1,
                   input  logic [WIDTH-1:0] in2,
                   input  logic sel_a);

timeunit 1ns;
timeprecision 100ps;

always_comb
  unique case (sel_a)
    1'b1: out = in1;
    1'b0: out = in2;
    default: out = 'x;
  endcase

endmodule
