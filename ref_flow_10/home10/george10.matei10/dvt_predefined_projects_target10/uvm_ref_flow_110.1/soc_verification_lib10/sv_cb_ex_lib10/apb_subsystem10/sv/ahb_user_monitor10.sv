/*-------------------------------------------------------------------------
File10 name   : ahb_user_monitor10.sv
Title10       : 
Project10     :
Created10     :
Description10 : 
Notes10       :
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

class ahb_monitor10 extends ahb_pkg10::ahb_master_monitor10;
   
  uvm_analysis_port #(ahb_pkg10::ahb_transfer10) ahb_transfer_out10;

  `uvm_component_utils(ahb_monitor10)

  function new (string name = "ahb_monitor10", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out10 = new("ahb_transfer_out10", this);
  endfunction

  virtual protected task print_transfers10();
    uvm_object obj;
     `uvm_info("USR_MONITOR10", $psprintf("print_transfers10 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer10 ended10 |---
	  // ---------------------
	  forever begin
	    // Wait10 until transfer10 ended10, and put the ended10 transfer10 in 'obj'.
	    @transaction_ended10; 

	    // Transaction10 recording10
	    transfer10.enable_recording("AHB10 transfers10 monitor10");
	    void'(transfer10.begin_tr());
	    transfer10.end_tr();

	    // Display10 a message about10 the transfer10 that just10 ended10
 	    `uvm_info("USR_MONITOR10", $psprintf(" %s to %0h with data %0h has ended10", transfer10.direction10.name(), transfer10.address, transfer10.data), UVM_MEDIUM)
      ahb_transfer_out10.write(transfer10);
	  end
  endtask

   // run() task is called automatically10
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR10", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers10(); 
   endtask

endclass

