/**********************************************************************
 * Definition of an PDS configuration
 *
 * Author: Shimon Cohen
 * Revision: 1.0
 * Last modified: 8/2/2011
 **********************************************************************/
`include "definitions.sv"

class Config;
	rand bit [7:0] pwr_bdj; // PDS power budjet

	// Give more weight for shortage off power
	constraint cpwr_bdj {pwr_bdj dist {[15:`numPorts*15]:=9, [0:14]:=1, [`numPorts*15+1:255]:=1};}

	int nTrans; // Number of transactions

	int nErrors; // number of errors caught

	int nPwrBdj; // number of different power budjet values

	extern function new();
	extern virtual function void display(input string prefix="");

endclass : Config
//---------------------------------------------------------------------------
function Config::new();
	this.nTrans=100;
	this.nPwrBdj=100;
	this.nErrors=0;
endfunction : new

//---------------------------------------------------------------------------
function void Config::display(input string prefix="");
	$display("@%0t power budget is %0d", $time, pwr_bdj);
endfunction : display

