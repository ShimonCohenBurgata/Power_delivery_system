/**********************************************************************
 * Definition of an PDS driver
 *
 * Author: Shimon Cohen
 *********************************************************************/


`ifndef DRIVER__SV
`define DRIVER__SV

/////////////////////////////////////////////////////////////////////
class Driver;
	mailbox gen2drv; 		// For cells sent from generator
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
endfunction : new

//------------------------------------------------------------------------------
// run() : Run the driver 
// Get transaction from the generator, send it to DUT
//------------------------------------------------------------------------------

task Driver::run();
	Prs_trans tr;
	tr=new();
	forever begin
		// Read transaction at the front of mailbox
		gen2drv.peek(tr);

		// Send transaction
		send(tr);

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
