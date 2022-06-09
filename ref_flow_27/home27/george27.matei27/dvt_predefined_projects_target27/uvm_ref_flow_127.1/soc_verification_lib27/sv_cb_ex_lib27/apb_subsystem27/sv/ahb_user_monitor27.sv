/*-------------------------------------------------------------------------
File27 name   : ahb_user_monitor27.sv
Title27       : 
Project27     :
Created27     :
Description27 : 
Notes27       :
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

class ahb_monitor27 extends ahb_pkg27::ahb_master_monitor27;
   
  uvm_analysis_port #(ahb_pkg27::ahb_transfer27) ahb_transfer_out27;

  `uvm_component_utils(ahb_monitor27)

  function new (string name = "ahb_monitor27", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out27 = new("ahb_transfer_out27", this);
  endfunction

  virtual protected task print_transfers27();
    uvm_object obj;
     `uvm_info("USR_MONITOR27", $psprintf("print_transfers27 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer27 ended27 |---
	  // ---------------------
	  forever begin
	    // Wait27 until transfer27 ended27, and put the ended27 transfer27 in 'obj'.
	    @transaction_ended27; 

	    // Transaction27 recording27
	    transfer27.enable_recording("AHB27 transfers27 monitor27");
	    void'(transfer27.begin_tr());
	    transfer27.end_tr();

	    // Display27 a message about27 the transfer27 that just27 ended27
 	    `uvm_info("USR_MONITOR27", $psprintf(" %s to %0h with data %0h has ended27", transfer27.direction27.name(), transfer27.address, transfer27.data), UVM_MEDIUM)
      ahb_transfer_out27.write(transfer27);
	  end
  endtask

   // run() task is called automatically27
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR27", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers27(); 
   endtask

endclass

