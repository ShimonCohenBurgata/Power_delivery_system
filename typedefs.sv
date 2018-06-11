`include "definitions.sv"
package typedefs;
	typedef struct{
	bit [(`numPorts-1):0] det;
	bit [(`numPorts-1):0] off;
	bit [(`numPorts-1):0] on;
	bit [(`numPorts*2-1):0] prio;
	bit [7:0] pwr_bdj;
	bit ports_off;} prs_struct_t;
endpackage : typedefs
