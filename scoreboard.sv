/**********************************************************************
 * Definition of the scoreboard class for the PDS testbench
 *
 * Author: Shimon Cohen
 *********************************************************************/

`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV

`include "prs_trans.sv"
`include "definitions.sv"
import typedefs::*;

class Scoreboard;
	parameter int numPorts=`numPorts;
	bit [(numPorts-1):0] qon_expected[$];
	bit [(numPorts-1):0] qon_actual[$];
	Config cfg;


	extern function new(input int numPorts, Config cfg);
	extern function void check_actual(Monitor mon);
	extern function bit [(numPorts-1):0] on_expected(input prs_struct_t tprs);
	
endclass : Scoreboard

function Scoreboard::new(int numPorts, Config cfg);
	this.cfg=cfg;
endfunction : new

function void Scoreboard::check_actual(Monitor mon);
	prs_struct_t tprs;
	bit [(numPorts-1):0] on_expected;
	bit [(numPorts-1):0] on_actual;
	tprs=mon.qtprs;
	on_actual=tprs.on; 
	on_expected=this.on_expected(tprs);
	qon_actual.push_back(on_actual);
	qon_expected.push_back(on_expected);
	if(qon_actual.size()>=2)begin
		on_expected=qon_expected.pop_front;
		on_actual=qon_actual.pop_back;
		if(on_expected!=on_actual) begin
			cfg.nErrors++;
			$display("@%t no match",$time);
			$display("@%t on_actual=%b, on_expected=%b",
				$time ,on_actual, on_expected);

		end
		$display("@%t on_actual=%b, on_expected=%b",
				$time ,on_actual, on_expected);

	end
endfunction : check_actual


function bit [(numPorts-1):0] Scoreboard::on_expected(input prs_struct_t tprs);
	

	// Packed array tp hold priority per port
	logic [(numPorts-1):0][1:0] iprio;

	// Unpacked array to hold priority per port
	logic [1:0] iprioa [(numPorts-1):0],
		
		// Unpacked array to old sorted priority
		iprioa_sorted[(numPorts-1):0],
			
		//list of unique priorities 
		prio_unique[$];
		
	// hold the index for each priority
	int prio_index[$];

		
	int sorted_index[$];
			
	// Hold the port to turn on
	logic [(numPorts-1):0] turn_on;

	// hold the availble power
	integer power_avail;

	// holds the number of ports we can turn on with regurds to
	// avail power
	integer num_ports;	
	
	// sample priority
	iprio=tprs.prio;

	// Set avail power to maximum
	power_avail = tprs.pwr_bdj;

	// calcultates the remining power
	foreach(tprs.on[i])
		power_avail -= 15*tprs.on[i];
		
	//Calculates the number of ports taht can be turned on;
	num_ports = (power_avail - power_avail%15)/15;
	
	// Pcked to unpacked
	foreach(iprio[i]) begin
		iprioa_sorted[i]=iprio[i];
		iprioa[i]=iprio[i];
	end

	//Sort priorities
	iprioa_sorted.sort();

	// Find uniqueness
	prio_unique=iprioa_sorted.unique();

	// Loop over all unique priorites
	foreach(prio_unique[i])begin
			
		// Find the index according to priority
		prio_index=iprioa.find_index with(item==prio_unique[i]);

		//Reverse the list
		prio_index.reverse();
		
		// Loop over all indexes
		foreach(prio_index[j]) begin
			sorted_index.push_front(prio_index[j]);
		end
	end

	// Calculate which port to turn on;
	for(int i=0; i<numPorts; i++) begin
			
		// Check for user ports_off
		if(tprs.ports_off)
			turn_on[sorted_index[i]]=0;
		
		// Check for off request
		else if(tprs.off[sorted_index[i]])
			turn_on[sorted_index[i]]=0;

		// Check if the port is already onn
		else if(tprs.on[sorted_index[i]])
			turn_on[sorted_index[i]]=1;
			
		//turn on the remining port according to priority
		else if(num_ports>0 && tprs.det[sorted_index[i]])begin
			turn_on[sorted_index[i]] = 1;
			num_ports--;
		end
			
		// leave the port off if no det request or no more
		// power
		else
			turn_on[sorted_index[i]] = 0;
	end
	on_expected=turn_on;
endfunction : on_expected

`endif // SCOREBOARD__SV
