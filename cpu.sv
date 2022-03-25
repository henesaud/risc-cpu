import typedefs::*;
module cpu (
    output logic halt,
    output logic loadIr,
    input  logic clk,
    input  logic cntrlClk,
    input  logic aluClk,
    input  logic fetch,
    input  logic rst_
);
timeunit 1ns;
timeprecision 100ps;

logic    [7:0]   dataOut, aluOut, accum, irOut;
logic    [4:0]   pcAddr, irAddr, addr;
opcodeT  opcode;
logic loadAc, memRd, memWr, incPc, loadPc, zero;

register ac     ( .out  (accum  ),
                  .data (aluOut),
                  .clk,
                  .enable  (loadAc),
                  .rst_
                );

register ir     ( .out (irOut),
                  .data(dataOut),
                  .clk,
                  .enable (loadIr),
                  .rst_
                );

assign opcode =  opcodeT'(irOut[7:5]);

assign irAddr = irOut[4:0]; 

counter  pc     ( .count  (pcAddr),
                  .data (irAddr),
                  .clk  (clk),
                  .load (loadPc),
                  .enable (incPc),
                  .rst_
                );

alu      alu1   ( .out (aluOut),
                  .zero,
                  .clk (aluClk),
                  .accum,
                  .data(dataOut),
                  .opcode
                );

mux #5 smx( .out (addr),
                  .in1 (pcAddr),
                  .in2 (irAddr),
                  .sel_a (fetch) 
                );

mem      mem1   ( .clk(~cntrlClk),
                  .read (memRd),
                  .write (memWr), 
                  .addr  ,
                  .dataIn(aluOut) ,
                  .dataOut(dataOut)
                );


control  cntl   ( .loadAc,
                  .memRd,
                  .memWr,
                  .incPc,
                  .loadPc,
                  .loadIr,
                  .halt,
                  .opcode,
                  .zero,
                  .clk(cntrlClk),
                  .rst_
                );

endmodule
