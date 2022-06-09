/*-------------------------------------------------------------------------
File3 name   : ahb_user_monitor3.sv
Title3       : 
Project3     :
Created3     :
Description3 : 
Notes3       :
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

class ahb_monitor3 extends ahb_pkg3::ahb_master_monitor3;
   
  uvm_analysis_port #(ahb_pkg3::ahb_transfer3) ahb_transfer_out3;

  `uvm_component_utils(ahb_monitor3)

  function new (string name = "ahb_monitor3", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out3 = new("ahb_transfer_out3", this);
  endfunction

  virtual protected task print_transfers3();
    uvm_object obj;
     `uvm_info("USR_MONITOR3", $psprintf("print_transfers3 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer3 ended3 |---
	  // ---------------------
	  forever begin
	    // Wait3 until transfer3 ended3, and put the ended3 transfer3 in 'obj'.
	    @transaction_ended3; 

	    // Transaction3 recording3
	    transfer3.enable_recording("AHB3 transfers3 monitor3");
	    void'(transfer3.begin_tr());
	    transfer3.end_tr();

	    // Display3 a message about3 the transfer3 that just3 ended3
 	    `uvm_info("USR_MONITOR3", $psprintf(" %s to %0h with data %0h has ended3", transfer3.direction3.name(), transfer3.address, transfer3.data), UVM_MEDIUM)
      ahb_transfer_out3.write(transfer3);
	  end
  endtask

   // run() task is called automatically3
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR3", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers3(); 
   endtask

endclass

