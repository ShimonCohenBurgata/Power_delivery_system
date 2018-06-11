/**********************************************************************
 * Definition of the monitor class for the PDS testbench
 *
 * Author: Shimon Cohen
 *********************************************************************/

`ifndef MONITOR__SV
`define MONITOR__SV
import typedefs::*;

typedef class Monitor;


////////////////////////////////////////////////////////////////////
// Monitor callback class
// called after transaction is transmitted
// Actual implementation is in environment.sv file
class Monitor_cbs;
	virtual task post_trans(input Monitor mon);
	endtask : post_trans
endclass : Monitor_cbs


//////////////////////////////////////////////////////////////////////////////////////////////////////////
class Monitor;
	prs_struct_t qtprs;	// object transaction
	Monitor_cbs cbsq;	// callback objecti
	virtual interface Inf.MON imon;

	extern function new(virtual Inf.MON imon);
	extern task run();
	extern task receive(output  prs_struct_t tprs);
	extern function void display(input  prs_struct_t tprs);
endclass : Monitor

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// new() : construct the monitor object
//////////////////////////////////////////////////////////////////////////////////////////////////////////
function Monitor::new(virtual Inf.MON imon);
	this.imon=imon;
endfunction


//---------------------------------------------------------------------------
// run(): Run the monitor
//---------------------------------------------------------------------------
task Monitor::run();
	forever begin
		prs_struct_t tprs;
		receive(tprs);
		display(tprs);
		this.qtprs=tprs;
		cbsq.post_trans(this);

	end
endtask : run

//---------------------------------------------------------------------------
// receive(): Read a transaction from the DUT output
//---------------------------------------------------------------------------
task Monitor::receive(output prs_struct_t tprs);

	@(imon.cbm);
	tprs.det = imon.cbm.det;
	tprs.off = imon.cbm.off;
	tprs.prio = imon.cbm.prio;
	tprs.pwr_bdj = imon.cbm.pwr_bdj;
	tprs.ports_off = imon.cbm.ports_off;
	tprs.on = imon.cbm.on;

endtask : receive


//---------------------------------------------------------------------------
// display(): Display the transaction
//---------------------------------------------------------------------------
function void Monitor::display(input  prs_struct_t tprs);
	$display("From monitor @%0t det=%b, off=%b, prio=%b, pwr_bdj=%0d, ports_off=%b, on=%b"
	,$time, tprs.det, tprs.off, tprs.prio,
		tprs.pwr_bdj, tprs.ports_off, tprs.on);
endfunction : display

`endif

