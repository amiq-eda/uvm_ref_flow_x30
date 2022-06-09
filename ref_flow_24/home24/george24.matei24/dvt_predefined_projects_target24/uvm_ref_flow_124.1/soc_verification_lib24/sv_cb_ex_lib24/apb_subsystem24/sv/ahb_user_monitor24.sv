/*-------------------------------------------------------------------------
File24 name   : ahb_user_monitor24.sv
Title24       : 
Project24     :
Created24     :
Description24 : 
Notes24       :
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

class ahb_monitor24 extends ahb_pkg24::ahb_master_monitor24;
   
  uvm_analysis_port #(ahb_pkg24::ahb_transfer24) ahb_transfer_out24;

  `uvm_component_utils(ahb_monitor24)

  function new (string name = "ahb_monitor24", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out24 = new("ahb_transfer_out24", this);
  endfunction

  virtual protected task print_transfers24();
    uvm_object obj;
     `uvm_info("USR_MONITOR24", $psprintf("print_transfers24 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer24 ended24 |---
	  // ---------------------
	  forever begin
	    // Wait24 until transfer24 ended24, and put the ended24 transfer24 in 'obj'.
	    @transaction_ended24; 

	    // Transaction24 recording24
	    transfer24.enable_recording("AHB24 transfers24 monitor24");
	    void'(transfer24.begin_tr());
	    transfer24.end_tr();

	    // Display24 a message about24 the transfer24 that just24 ended24
 	    `uvm_info("USR_MONITOR24", $psprintf(" %s to %0h with data %0h has ended24", transfer24.direction24.name(), transfer24.address, transfer24.data), UVM_MEDIUM)
      ahb_transfer_out24.write(transfer24);
	  end
  endtask

   // run() task is called automatically24
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR24", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers24(); 
   endtask

endclass

