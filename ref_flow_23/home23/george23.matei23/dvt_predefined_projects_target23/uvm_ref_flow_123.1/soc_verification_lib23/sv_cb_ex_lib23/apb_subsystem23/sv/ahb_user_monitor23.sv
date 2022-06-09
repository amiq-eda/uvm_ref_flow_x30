/*-------------------------------------------------------------------------
File23 name   : ahb_user_monitor23.sv
Title23       : 
Project23     :
Created23     :
Description23 : 
Notes23       :
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

class ahb_monitor23 extends ahb_pkg23::ahb_master_monitor23;
   
  uvm_analysis_port #(ahb_pkg23::ahb_transfer23) ahb_transfer_out23;

  `uvm_component_utils(ahb_monitor23)

  function new (string name = "ahb_monitor23", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out23 = new("ahb_transfer_out23", this);
  endfunction

  virtual protected task print_transfers23();
    uvm_object obj;
     `uvm_info("USR_MONITOR23", $psprintf("print_transfers23 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer23 ended23 |---
	  // ---------------------
	  forever begin
	    // Wait23 until transfer23 ended23, and put the ended23 transfer23 in 'obj'.
	    @transaction_ended23; 

	    // Transaction23 recording23
	    transfer23.enable_recording("AHB23 transfers23 monitor23");
	    void'(transfer23.begin_tr());
	    transfer23.end_tr();

	    // Display23 a message about23 the transfer23 that just23 ended23
 	    `uvm_info("USR_MONITOR23", $psprintf(" %s to %0h with data %0h has ended23", transfer23.direction23.name(), transfer23.address, transfer23.data), UVM_MEDIUM)
      ahb_transfer_out23.write(transfer23);
	  end
  endtask

   // run() task is called automatically23
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR23", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers23(); 
   endtask

endclass

