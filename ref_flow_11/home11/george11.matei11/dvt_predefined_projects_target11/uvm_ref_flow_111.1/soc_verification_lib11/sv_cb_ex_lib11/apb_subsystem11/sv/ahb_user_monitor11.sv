/*-------------------------------------------------------------------------
File11 name   : ahb_user_monitor11.sv
Title11       : 
Project11     :
Created11     :
Description11 : 
Notes11       :
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

class ahb_monitor11 extends ahb_pkg11::ahb_master_monitor11;
   
  uvm_analysis_port #(ahb_pkg11::ahb_transfer11) ahb_transfer_out11;

  `uvm_component_utils(ahb_monitor11)

  function new (string name = "ahb_monitor11", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out11 = new("ahb_transfer_out11", this);
  endfunction

  virtual protected task print_transfers11();
    uvm_object obj;
     `uvm_info("USR_MONITOR11", $psprintf("print_transfers11 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer11 ended11 |---
	  // ---------------------
	  forever begin
	    // Wait11 until transfer11 ended11, and put the ended11 transfer11 in 'obj'.
	    @transaction_ended11; 

	    // Transaction11 recording11
	    transfer11.enable_recording("AHB11 transfers11 monitor11");
	    void'(transfer11.begin_tr());
	    transfer11.end_tr();

	    // Display11 a message about11 the transfer11 that just11 ended11
 	    `uvm_info("USR_MONITOR11", $psprintf(" %s to %0h with data %0h has ended11", transfer11.direction11.name(), transfer11.address, transfer11.data), UVM_MEDIUM)
      ahb_transfer_out11.write(transfer11);
	  end
  endtask

   // run() task is called automatically11
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR11", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers11(); 
   endtask

endclass

