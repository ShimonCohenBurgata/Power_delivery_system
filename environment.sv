/**********************************************************************
 * Definition of the environment class for the PDS testbench
 *
 * Author: Shimon Cohen
 *********************************************************************/

`ifndef ENVIRONMENT__SV
`define ENVIRONMENT__SV

/////////////////////////////////////////////////////////
// Call scoreboard from Monitor using callbacks
/////////////////////////////////////////////////////////
class Scb_Monitor_cbs extends Monitor_cbs;
	Scoreboard scb;

	function new(Scoreboard scb);
		this.scb = scb;
	endfunction : new

	virtual task post_trans(input Monitor mon);
		scb.check_actual(mon);	
	endtask : post_trans
endclass : Scb_Monitor_cbs


/////////////////////////////////////////////////////////
class Environment;

	mailbox gen2drv;	// Mailbox from generator to driver
	event drv2gen;		// Event from driver to generator	
	Driver drv;		// Driver object
	Prs_generator gen;	// Generator object
	Monitor mon;		// Monitor object
	Scoreboard scb;		// Scoreboard object
	virtual Inf.MON imon;	// Virtual interface for monitor object
	virtual Inf.DRV idrv;	// Virtual interface for driver object
	Config cfg;		// Configuration object
	int numPorts;


	extern function new(input virtual Inf.MON imon,
			input virtual Inf.DRV idrv, input int numPorts);
	extern virtual function void gen_cfg();
	extern virtual function void build();
	extern virtual task run();
	extern virtual function void wrap_up();
endclass : Environment

//---------------------------------------------------------------------------
// Construct an environment instance
//---------------------------------------------------------------------------
function Environment::new(input virtual Inf.MON imon,
			input virtual Inf.DRV idrv, input int numPorts);

		this.imon=imon;
		this.idrv=idrv;
		this.numPorts=numPorts;
		cfg=new();
endfunction : new


//---------------------------------------------------------------------------
// Randomize the configuration descriptor
//---------------------------------------------------------------------------
function void Environment::gen_cfg();
	assert(cfg.randomize());
	cfg.display();
endfunction :gen_cfg

//---------------------------------------------------------------------------
// Build the environment objects for this test
//---------------------------------------------------------------------------
function void Environment::build();
	gen2drv=new();
	gen=new(gen2drv, drv2gen, cfg);
	drv=new(gen2drv, drv2gen, idrv);
	mon=new(imon);
	scb=new(numPorts,cfg);

	// Connect the scoreboard with callbacks
	begin
		Scb_Monitor_cbs smc = new(scb);
		mon.cbsq=smc;
	end
	
endfunction : build

//---------------------------------------------------------------------------
// Start the transactors (generators, drivers, monitors) in the environment
//---------------------------------------------------------------------------
task Environment::run();
	fork
		gen.run();
		drv.run();
		mon.run();
	join_any
endtask : run


//---------------------------------------------------------------------------
// Post-run reporting
//---------------------------------------------------------------------------
function void Environment::wrap_up();
	$display("Number of errors are %0d", cfg.nErrors);
	$finish;
endfunction : wrap_up

`endif


