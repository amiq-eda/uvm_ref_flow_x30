/*-------------------------------------------------------------------------
File5 name   : ahb_user_monitor5.sv
Title5       : 
Project5     :
Created5     :
Description5 : 
Notes5       :
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

class ahb_monitor5 extends ahb_pkg5::ahb_master_monitor5;
   
  uvm_analysis_port #(ahb_pkg5::ahb_transfer5) ahb_transfer_out5;

  `uvm_component_utils(ahb_monitor5)

  function new (string name = "ahb_monitor5", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out5 = new("ahb_transfer_out5", this);
  endfunction

  virtual protected task print_transfers5();
    uvm_object obj;
     `uvm_info("USR_MONITOR5", $psprintf("print_transfers5 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer5 ended5 |---
	  // ---------------------
	  forever begin
	    // Wait5 until transfer5 ended5, and put the ended5 transfer5 in 'obj'.
	    @transaction_ended5; 

	    // Transaction5 recording5
	    transfer5.enable_recording("AHB5 transfers5 monitor5");
	    void'(transfer5.begin_tr());
	    transfer5.end_tr();

	    // Display5 a message about5 the transfer5 that just5 ended5
 	    `uvm_info("USR_MONITOR5", $psprintf(" %s to %0h with data %0h has ended5", transfer5.direction5.name(), transfer5.address, transfer5.data), UVM_MEDIUM)
      ahb_transfer_out5.write(transfer5);
	  end
  endtask

   // run() task is called automatically5
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR5", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers5(); 
   endtask

endclass

