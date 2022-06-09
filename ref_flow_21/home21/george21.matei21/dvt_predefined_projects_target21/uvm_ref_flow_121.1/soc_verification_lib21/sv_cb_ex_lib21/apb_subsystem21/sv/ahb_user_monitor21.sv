/*-------------------------------------------------------------------------
File21 name   : ahb_user_monitor21.sv
Title21       : 
Project21     :
Created21     :
Description21 : 
Notes21       :
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

class ahb_monitor21 extends ahb_pkg21::ahb_master_monitor21;
   
  uvm_analysis_port #(ahb_pkg21::ahb_transfer21) ahb_transfer_out21;

  `uvm_component_utils(ahb_monitor21)

  function new (string name = "ahb_monitor21", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out21 = new("ahb_transfer_out21", this);
  endfunction

  virtual protected task print_transfers21();
    uvm_object obj;
     `uvm_info("USR_MONITOR21", $psprintf("print_transfers21 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer21 ended21 |---
	  // ---------------------
	  forever begin
	    // Wait21 until transfer21 ended21, and put the ended21 transfer21 in 'obj'.
	    @transaction_ended21; 

	    // Transaction21 recording21
	    transfer21.enable_recording("AHB21 transfers21 monitor21");
	    void'(transfer21.begin_tr());
	    transfer21.end_tr();

	    // Display21 a message about21 the transfer21 that just21 ended21
 	    `uvm_info("USR_MONITOR21", $psprintf(" %s to %0h with data %0h has ended21", transfer21.direction21.name(), transfer21.address, transfer21.data), UVM_MEDIUM)
      ahb_transfer_out21.write(transfer21);
	  end
  endtask

   // run() task is called automatically21
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR21", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers21(); 
   endtask

endclass

