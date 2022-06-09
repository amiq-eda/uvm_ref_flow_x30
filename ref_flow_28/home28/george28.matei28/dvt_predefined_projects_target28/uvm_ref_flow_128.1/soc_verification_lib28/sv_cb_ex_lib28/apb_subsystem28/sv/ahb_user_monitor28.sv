/*-------------------------------------------------------------------------
File28 name   : ahb_user_monitor28.sv
Title28       : 
Project28     :
Created28     :
Description28 : 
Notes28       :
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

class ahb_monitor28 extends ahb_pkg28::ahb_master_monitor28;
   
  uvm_analysis_port #(ahb_pkg28::ahb_transfer28) ahb_transfer_out28;

  `uvm_component_utils(ahb_monitor28)

  function new (string name = "ahb_monitor28", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out28 = new("ahb_transfer_out28", this);
  endfunction

  virtual protected task print_transfers28();
    uvm_object obj;
     `uvm_info("USR_MONITOR28", $psprintf("print_transfers28 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer28 ended28 |---
	  // ---------------------
	  forever begin
	    // Wait28 until transfer28 ended28, and put the ended28 transfer28 in 'obj'.
	    @transaction_ended28; 

	    // Transaction28 recording28
	    transfer28.enable_recording("AHB28 transfers28 monitor28");
	    void'(transfer28.begin_tr());
	    transfer28.end_tr();

	    // Display28 a message about28 the transfer28 that just28 ended28
 	    `uvm_info("USR_MONITOR28", $psprintf(" %s to %0h with data %0h has ended28", transfer28.direction28.name(), transfer28.address, transfer28.data), UVM_MEDIUM)
      ahb_transfer_out28.write(transfer28);
	  end
  endtask

   // run() task is called automatically28
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR28", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers28(); 
   endtask

endclass

