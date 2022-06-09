/*-------------------------------------------------------------------------
File12 name   : ahb_user_monitor12.sv
Title12       : 
Project12     :
Created12     :
Description12 : 
Notes12       :
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

class ahb_monitor12 extends ahb_pkg12::ahb_master_monitor12;
   
  uvm_analysis_port #(ahb_pkg12::ahb_transfer12) ahb_transfer_out12;

  `uvm_component_utils(ahb_monitor12)

  function new (string name = "ahb_monitor12", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out12 = new("ahb_transfer_out12", this);
  endfunction

  virtual protected task print_transfers12();
    uvm_object obj;
     `uvm_info("USR_MONITOR12", $psprintf("print_transfers12 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer12 ended12 |---
	  // ---------------------
	  forever begin
	    // Wait12 until transfer12 ended12, and put the ended12 transfer12 in 'obj'.
	    @transaction_ended12; 

	    // Transaction12 recording12
	    transfer12.enable_recording("AHB12 transfers12 monitor12");
	    void'(transfer12.begin_tr());
	    transfer12.end_tr();

	    // Display12 a message about12 the transfer12 that just12 ended12
 	    `uvm_info("USR_MONITOR12", $psprintf(" %s to %0h with data %0h has ended12", transfer12.direction12.name(), transfer12.address, transfer12.data), UVM_MEDIUM)
      ahb_transfer_out12.write(transfer12);
	  end
  endtask

   // run() task is called automatically12
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR12", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers12(); 
   endtask

endclass

