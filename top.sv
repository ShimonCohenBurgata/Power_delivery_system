`include "definitions.sv"

module top;

 parameter int numPorts=`numPorts;
 timeunit 1ns;
 timeprecision 100ps;
 logic rst_n, clk;

 initial begin
  clk=0;
  forever
   #5 clk = ~clk;
 end


 Inf #(numPorts) busa (clk);
 pds #(numPorts) dut(.busa(busa.DUT));
 test #(numPorts) tdut(.busa(busa.DRV), .imon(busa.MON));
endmodule
