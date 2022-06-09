/*-------------------------------------------------------------------------
File15 name   : ahb_user_monitor15.sv
Title15       : 
Project15     :
Created15     :
Description15 : 
Notes15       :
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

class ahb_monitor15 extends ahb_pkg15::ahb_master_monitor15;
   
  uvm_analysis_port #(ahb_pkg15::ahb_transfer15) ahb_transfer_out15;

  `uvm_component_utils(ahb_monitor15)

  function new (string name = "ahb_monitor15", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out15 = new("ahb_transfer_out15", this);
  endfunction

  virtual protected task print_transfers15();
    uvm_object obj;
     `uvm_info("USR_MONITOR15", $psprintf("print_transfers15 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer15 ended15 |---
	  // ---------------------
	  forever begin
	    // Wait15 until transfer15 ended15, and put the ended15 transfer15 in 'obj'.
	    @transaction_ended15; 

	    // Transaction15 recording15
	    transfer15.enable_recording("AHB15 transfers15 monitor15");
	    void'(transfer15.begin_tr());
	    transfer15.end_tr();

	    // Display15 a message about15 the transfer15 that just15 ended15
 	    `uvm_info("USR_MONITOR15", $psprintf(" %s to %0h with data %0h has ended15", transfer15.direction15.name(), transfer15.address, transfer15.data), UVM_MEDIUM)
      ahb_transfer_out15.write(transfer15);
	  end
  endtask

   // run() task is called automatically15
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR15", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers15(); 
   endtask

endclass

