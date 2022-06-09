/*-------------------------------------------------------------------------
File6 name   : ahb_user_monitor6.sv
Title6       : 
Project6     :
Created6     :
Description6 : 
Notes6       :
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

class ahb_monitor6 extends ahb_pkg6::ahb_master_monitor6;
   
  uvm_analysis_port #(ahb_pkg6::ahb_transfer6) ahb_transfer_out6;

  `uvm_component_utils(ahb_monitor6)

  function new (string name = "ahb_monitor6", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out6 = new("ahb_transfer_out6", this);
  endfunction

  virtual protected task print_transfers6();
    uvm_object obj;
     `uvm_info("USR_MONITOR6", $psprintf("print_transfers6 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer6 ended6 |---
	  // ---------------------
	  forever begin
	    // Wait6 until transfer6 ended6, and put the ended6 transfer6 in 'obj'.
	    @transaction_ended6; 

	    // Transaction6 recording6
	    transfer6.enable_recording("AHB6 transfers6 monitor6");
	    void'(transfer6.begin_tr());
	    transfer6.end_tr();

	    // Display6 a message about6 the transfer6 that just6 ended6
 	    `uvm_info("USR_MONITOR6", $psprintf(" %s to %0h with data %0h has ended6", transfer6.direction6.name(), transfer6.address, transfer6.data), UVM_MEDIUM)
      ahb_transfer_out6.write(transfer6);
	  end
  endtask

   // run() task is called automatically6
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR6", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers6(); 
   endtask

endclass

