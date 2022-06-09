/*-------------------------------------------------------------------------
File8 name   : ahb_user_monitor8.sv
Title8       : 
Project8     :
Created8     :
Description8 : 
Notes8       :
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

class ahb_monitor8 extends ahb_pkg8::ahb_master_monitor8;
   
  uvm_analysis_port #(ahb_pkg8::ahb_transfer8) ahb_transfer_out8;

  `uvm_component_utils(ahb_monitor8)

  function new (string name = "ahb_monitor8", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out8 = new("ahb_transfer_out8", this);
  endfunction

  virtual protected task print_transfers8();
    uvm_object obj;
     `uvm_info("USR_MONITOR8", $psprintf("print_transfers8 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer8 ended8 |---
	  // ---------------------
	  forever begin
	    // Wait8 until transfer8 ended8, and put the ended8 transfer8 in 'obj'.
	    @transaction_ended8; 

	    // Transaction8 recording8
	    transfer8.enable_recording("AHB8 transfers8 monitor8");
	    void'(transfer8.begin_tr());
	    transfer8.end_tr();

	    // Display8 a message about8 the transfer8 that just8 ended8
 	    `uvm_info("USR_MONITOR8", $psprintf(" %s to %0h with data %0h has ended8", transfer8.direction8.name(), transfer8.address, transfer8.data), UVM_MEDIUM)
      ahb_transfer_out8.write(transfer8);
	  end
  endtask

   // run() task is called automatically8
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR8", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers8(); 
   endtask

endclass

