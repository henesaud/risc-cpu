import typedefs::*;
module control  (
  output logic      loadAc ,
  output logic      memRd   ,
  output logic      memWr   ,
  output logic      incPc   ,
  output logic      loadPc  ,
  output logic      loadIr ,
  output logic      halt    ,
  input  opcodeT    opcode  ,
  input  logic      zero    ,
  input  logic      clk     ,
  input  logic      rst_   
);
timeunit 1ns;
timeprecision 100ps;

stateT state;
logic aluop;

assign aluop = (opcode inside {ADD, AND, XOR, LDA});

always_ff @(posedge clk or negedge rst_)
  if (!rst_)
     state <= INST_ADDR;
  else
     state <= state.next();

always_comb  begin
  {memRd, loadIr, halt, incPc, loadAc, loadPc, memWr}  =  7'b000_0000;
  unique case (state)
    INST_ADDR : ;
    INST_FETCH: memRd = 1;    
    INST_LOAD : begin         
                memRd = 1;   
                loadIr = 1;  
                end
    IDLE      : begin
                memRd = 1; 
                loadIr = 1;
                end
    OP_ADDR   : begin      
                incPc = 1;
                halt = (opcode == HLT);
                end
    OP_FETCH  : memRd = aluop;
    ALU_OP    : begin          
                loadAc = aluop;
                memRd = aluop;
                incPc = ((opcode == SKZ) && zero);
                loadPc = ( opcode == JMP);
                end
    STORE     : begin
                loadAc = aluop;
                memRd = aluop;
                incPc = (opcode == JMP);
                loadPc = ( opcode == JMP);
                memWr = ( opcode == STO);
                end
  endcase
  end

endmodule
