/**********************************************************************
 * Definition of an PDS driver
 *
 * Author: Shimon Cohen
 *********************************************************************/


`ifndef DRIVER__SV
`define DRIVER__SV

/////////////////////////////////////////////////////////////////////
// Driver Monitor callback class
// Called before transaction is transmitted
// Actual implementation is in environment.sv file
/////////////////////////////////////////////////////////////////////
typedef class Driver;
class Driver_cbs;
	virtual task pre_trans(input Driver drv);
		// Here you can override randomazation
		drv.send(drv.tr);		
	endtask : pre_trans
endclass : Driver_cbs

/////////////////////////////////////////////////////////////////////
class Driver;

	Driver_cbs cbsq;
	mailbox gen2drv; 		// For cells sent from generator
	Prs_trans tr;
	event drv2gen; 			// Tell generator when I am done with cell
	virtual interface Inf.DRV iprs;// Virtual interface for transmitting transactions

	
	extern function new(
			input mailbox gen2drv, input event drv2gen,
			virtual Inf.DRV iprs);
	extern task run();
	extern task send (input Prs_trans tr); 

endclass : Driver

//------------------------------------------------------------------------------
// new(): Construct a driver object
//------------------------------------------------------------------------------

function Driver::new(input mailbox gen2drv, input event drv2gen,
		virtual Inf.DRV iprs);
	this.gen2drv = gen2drv;
	this.drv2gen = drv2gen;
	this.iprs = iprs;
	tr=new();
	cbsq=new();
endfunction : new

//------------------------------------------------------------------------------
// run() : Run the driver 
// Get transaction from the generator, send it to DUT
//------------------------------------------------------------------------------

task Driver::run();
	forever begin
		// Read transaction at the front of mailbox
		gen2drv.peek(tr);

		// Send transaction
		cbsq.pre_trans(this);

		// Remove transaction from mailbox
		gen2drv.get(tr);

		// Infrom the generator the sending is done
		->drv2gen;
	end
endtask : run

//------------------------------------------------------------------------------
// send() : Send the transaction into DUT 
//------------------------------------------------------------------------------
task Driver::send(input Prs_trans tr);
	 @(iprs.cb);
	 iprs.cb.det<= tr.det;
	 iprs.cb.off<= tr.off;
	 iprs.cb.prio<= tr.prio;
	 iprs.cb.pwr_bdj<= tr.pwr_bdj;
	 iprs.cb.ports_off<= tr.ports_off;
endtask : send

`endif
