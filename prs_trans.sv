`ifndef PRS_TRANS__SV
`define PRS_TRANS__SV
`include "definitions.sv"
class Prs_trans;
	
	parameter int numPorts=`numPorts;

	rand bit [(numPorts-1):0] det;

	rand bit [(numPorts-1):0] off;

	rand bit [(2*numPorts-1):0] prio;

	//rand bit [7:0] pwr_bdj;
	bit [7:0] pwr_bdj;

	rand bit ports_off;
	constraint cports_off {ports_off dist {0:=31, 1:=1};}

	extern function new();
	extern virtual task turn_off_ports();
	extern virtual function void display(input string prefix);
endclass : Prs_trans

function Prs_trans::new();
endfunction : new

task Prs_trans::turn_off_ports();
	ports_off = 1;
endtask : turn_off_ports

function void Prs_trans::display(input string prefix);
	$write("%s",prefix);
	$display("det=%0b, off=%0b, prio=%0b, pwr_bdj=%0b, ports_off=%0b"
	,det,off,prio,pwr_bdj,ports_off);
endfunction : display

`endif //PRS_TRANS__SV

