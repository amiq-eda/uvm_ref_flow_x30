/*-------------------------------------------------------------------------
File30 name   : ahb_user_monitor30.sv
Title30       : 
Project30     :
Created30     :
Description30 : 
Notes30       :
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

class ahb_monitor30 extends ahb_pkg30::ahb_master_monitor30;
   
  uvm_analysis_port #(ahb_pkg30::ahb_transfer30) ahb_transfer_out30;

  `uvm_component_utils(ahb_monitor30)

  function new (string name = "ahb_monitor30", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out30 = new("ahb_transfer_out30", this);
  endfunction

  virtual protected task print_transfers30();
    uvm_object obj;
     `uvm_info("USR_MONITOR30", $psprintf("print_transfers30 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer30 ended30 |---
	  // ---------------------
	  forever begin
	    // Wait30 until transfer30 ended30, and put the ended30 transfer30 in 'obj'.
	    @transaction_ended30; 

	    // Transaction30 recording30
	    transfer30.enable_recording("AHB30 transfers30 monitor30");
	    void'(transfer30.begin_tr());
	    transfer30.end_tr();

	    // Display30 a message about30 the transfer30 that just30 ended30
 	    `uvm_info("USR_MONITOR30", $psprintf(" %s to %0h with data %0h has ended30", transfer30.direction30.name(), transfer30.address, transfer30.data), UVM_MEDIUM)
      ahb_transfer_out30.write(transfer30);
	  end
  endtask

   // run() task is called automatically30
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR30", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers30(); 
   endtask

endclass

