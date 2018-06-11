# Power_delivery_system
System Verilog verification environment

This system can be configured to have 4, 8 or 16 ports.
each port can request power by set det to 1;
each port can ask for turn off by setting off to 1.
each port as 2 bit priority.
		00 = highest priority, 11=lowest priority.
if more than 1 port have the same priority then their phisical location sets the priority.
		location 0=highest priority n=lowest priority.
if the pds decide to turn on the port on is 1;
allocated power budjet can't change during operation.
each port consumes 4'd15 if it is on.
please refer to the attched drawing.

