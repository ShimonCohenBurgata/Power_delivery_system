/**********************************************************************
*
* PDS interface, modeled as a SystemVerilog interface
*
* Author: Shimon Cohen
* *******************************************************************/
`include "definitions.sv"
interface Inf (input logic clk);
	parameter int numPorts=`numPorts;
	timeunit 1ns;
	timeprecision 100ps;
	logic [(numPorts-1):0] det;
	logic [(numPorts-1):0] off;
	logic [(numPorts-1):0] on;
	logic [(2*numPorts-1):0] prio;
	logic [7:0] pwr_bdj;
	logic ports_off;
	logic rst_n;

	clocking cb @(posedge clk);
		output det, off, prio, pwr_bdj, ports_off;
	endclocking : cb

	clocking cbm @(negedge clk);
		input on, det, off, prio, pwr_bdj, ports_off;
	endclocking : cbm


	

	modport DRV (clocking cb, output rst_n);
	modport DUT (input det, off, prio, pwr_bdj, ports_off, rst_n, clk, output on);
	modport MON (clocking cbm);

endinterface

