/*-------------------------------------------------------------------------
File16 name   : ahb_user_monitor16.sv
Title16       : 
Project16     :
Created16     :
Description16 : 
Notes16       :
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

class ahb_monitor16 extends ahb_pkg16::ahb_master_monitor16;
   
  uvm_analysis_port #(ahb_pkg16::ahb_transfer16) ahb_transfer_out16;

  `uvm_component_utils(ahb_monitor16)

  function new (string name = "ahb_monitor16", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out16 = new("ahb_transfer_out16", this);
  endfunction

  virtual protected task print_transfers16();
    uvm_object obj;
     `uvm_info("USR_MONITOR16", $psprintf("print_transfers16 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer16 ended16 |---
	  // ---------------------
	  forever begin
	    // Wait16 until transfer16 ended16, and put the ended16 transfer16 in 'obj'.
	    @transaction_ended16; 

	    // Transaction16 recording16
	    transfer16.enable_recording("AHB16 transfers16 monitor16");
	    void'(transfer16.begin_tr());
	    transfer16.end_tr();

	    // Display16 a message about16 the transfer16 that just16 ended16
 	    `uvm_info("USR_MONITOR16", $psprintf(" %s to %0h with data %0h has ended16", transfer16.direction16.name(), transfer16.address, transfer16.data), UVM_MEDIUM)
      ahb_transfer_out16.write(transfer16);
	  end
  endtask

   // run() task is called automatically16
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR16", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers16(); 
   endtask

endclass

