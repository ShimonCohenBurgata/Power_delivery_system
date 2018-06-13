/**********************************************************************
 * Functional coverage code
 *
 * Author: Shimon Cohen
 *********************************************************************/
//`ifndef COVERAGE__SV
//`define COVERAGE__SV
`include "definitions.sv"

class Coverage;
	bit [(`numPorts-1):0] det;
	bit [(`numPorts-1):0] off;
	bit [(2*`numPorts-1):0] prio;
	bit [7:0] pwr_bdj;

	covergroup prs_trans;
		cdet : coverpoint det;
		coff : coverpoint off;
		cprio: coverpoint prio;
		cpwr_bdj: coverpoint pwr_bdj;
		cross det, off;
	endgroup : prs_trans

	function new;
		prs_trans=new;
	endfunction : new

	function void sample(input Monitor mon);
		$display("@%0t: Coverage: det=%d, off=%d, prio=%d, pwr_bdg=%d",
			$time, mon.qtprs.det, mon.qtprs.off, mon.qtprs.prio, mon.qtprs.pwr_bdj );
		this.det=mon.qtprs.det;
		this.off=mon.qtprs.off;
		this.prio=mon.qtprs.prio;
		this.pwr_bdj=mon.qtprs.pwr_bdj;
		prs_trans.sample();
	endfunction : sample

endclass : Coverage
//`endif COVERAGE__SV
