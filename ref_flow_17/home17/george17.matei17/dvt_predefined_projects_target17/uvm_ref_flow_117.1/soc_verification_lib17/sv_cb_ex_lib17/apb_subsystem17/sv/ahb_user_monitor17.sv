/*-------------------------------------------------------------------------
File17 name   : ahb_user_monitor17.sv
Title17       : 
Project17     :
Created17     :
Description17 : 
Notes17       :
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

class ahb_monitor17 extends ahb_pkg17::ahb_master_monitor17;
   
  uvm_analysis_port #(ahb_pkg17::ahb_transfer17) ahb_transfer_out17;

  `uvm_component_utils(ahb_monitor17)

  function new (string name = "ahb_monitor17", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out17 = new("ahb_transfer_out17", this);
  endfunction

  virtual protected task print_transfers17();
    uvm_object obj;
     `uvm_info("USR_MONITOR17", $psprintf("print_transfers17 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer17 ended17 |---
	  // ---------------------
	  forever begin
	    // Wait17 until transfer17 ended17, and put the ended17 transfer17 in 'obj'.
	    @transaction_ended17; 

	    // Transaction17 recording17
	    transfer17.enable_recording("AHB17 transfers17 monitor17");
	    void'(transfer17.begin_tr());
	    transfer17.end_tr();

	    // Display17 a message about17 the transfer17 that just17 ended17
 	    `uvm_info("USR_MONITOR17", $psprintf(" %s to %0h with data %0h has ended17", transfer17.direction17.name(), transfer17.address, transfer17.data), UVM_MEDIUM)
      ahb_transfer_out17.write(transfer17);
	  end
  endtask

   // run() task is called automatically17
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR17", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers17(); 
   endtask

endclass

