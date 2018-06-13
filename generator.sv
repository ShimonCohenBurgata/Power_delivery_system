/**********************************************************************
 * Definition of the generator class for the PDS testbench
 *
 * Author: Shimon Cohen
 * 
 *********************************************************************/

`ifndef GENERATOR__SV
`define GENERATOR__SV
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Prs_generator;
	Prs_trans blueprint;	// Blueprint for generator
	mailbox gen2drv;	// Mailbox to driver for transaction
	event drv2gen;		// Event from driver when done with transaction
	bit[7:0] pwr_bdj;	// Power budjet value
	Config cfg;		// Configure object

	extern function new(input mailbox gen2drv, input event drv2gen,
			Config cfg);
	extern task run();
endclass : Prs_generator

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// New() : constract a generator object
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Prs_generator::new(input mailbox gen2drv, input event drv2gen,
			Config cfg);
		this.gen2drv=gen2drv;
		this.drv2gen=drv2gen;
		this.cfg=cfg;
endfunction : new

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Run() : Run the generator
// Send transactions into driver mail box is the agent
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task Prs_generator::run();
	// Loop over all powrbudjet values
	int ok;
	repeat (cfg.nPwrBdj) begin
		ok=randomize(cfg);
		if(!ok)
			$fatal("Config object randomize was faild");
		pwr_bdj = cfg.pwr_bdj;
		blueprint=new();
		blueprint.turn_off_ports();
		gen2drv.put(blueprint);
		@drv2gen;
		
		// Loop over all number of transaction
		repeat(cfg.nTrans) begin
			blueprint=new();
			ok=blueprint.randomize();
			if(!ok)
				$fatal("Config object randomize was faild");
			blueprint.pwr_bdj=pwr_bdj;
			blueprint.display($sformatf("@%0t: ", $time));
			gen2drv.put(blueprint);
			@drv2gen;
		end
	end
endtask : run

`endif
