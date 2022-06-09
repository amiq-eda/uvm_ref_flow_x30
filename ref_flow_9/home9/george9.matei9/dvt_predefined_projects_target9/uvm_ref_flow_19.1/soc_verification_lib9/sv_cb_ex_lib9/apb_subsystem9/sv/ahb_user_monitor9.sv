/*-------------------------------------------------------------------------
File9 name   : ahb_user_monitor9.sv
Title9       : 
Project9     :
Created9     :
Description9 : 
Notes9       :
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

class ahb_monitor9 extends ahb_pkg9::ahb_master_monitor9;
   
  uvm_analysis_port #(ahb_pkg9::ahb_transfer9) ahb_transfer_out9;

  `uvm_component_utils(ahb_monitor9)

  function new (string name = "ahb_monitor9", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out9 = new("ahb_transfer_out9", this);
  endfunction

  virtual protected task print_transfers9();
    uvm_object obj;
     `uvm_info("USR_MONITOR9", $psprintf("print_transfers9 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer9 ended9 |---
	  // ---------------------
	  forever begin
	    // Wait9 until transfer9 ended9, and put the ended9 transfer9 in 'obj'.
	    @transaction_ended9; 

	    // Transaction9 recording9
	    transfer9.enable_recording(.stream("AHB transfers9 monitor9"));
	    void'(transfer9.begin_tr());
	    transfer9.end_tr();

	    // Display9 a message about9 the transfer9 that just9 ended9
 	    `uvm_info("USR_MONITOR9", $psprintf(" %s to %0h with data %0h has ended9", transfer9.direction9.name(), transfer9.address, transfer9.data), UVM_MEDIUM)
      ahb_transfer_out9.write(transfer9);
	  end
  endtask

   // run() task is called automatically9
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR9", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers9(); 
   endtask

endclass

