module test #(parameter int numPorts=4)(Inf.DRV busa, Inf.MON imon);
timeunit 1ns;
timeprecision 100ps;




Environment env;

initial begin
  busa.rst_n=0;
  @(busa.cb);
  busa.rst_n=1;
 end



initial begin
	env=new(imon,busa, numPorts);
	env.gen_cfg();
	env.build();
	env.run();
	env.wrap_up();
end
endmodule
