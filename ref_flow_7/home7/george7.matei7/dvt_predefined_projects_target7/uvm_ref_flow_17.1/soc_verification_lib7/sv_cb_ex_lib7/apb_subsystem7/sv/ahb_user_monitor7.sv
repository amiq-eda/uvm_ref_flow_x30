/*-------------------------------------------------------------------------
File7 name   : ahb_user_monitor7.sv
Title7       : 
Project7     :
Created7     :
Description7 : 
Notes7       :
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

class ahb_monitor7 extends ahb_pkg7::ahb_master_monitor7;
   
  uvm_analysis_port #(ahb_pkg7::ahb_transfer7) ahb_transfer_out7;

  `uvm_component_utils(ahb_monitor7)

  function new (string name = "ahb_monitor7", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out7 = new("ahb_transfer_out7", this);
  endfunction

  virtual protected task print_transfers7();
    uvm_object obj;
     `uvm_info("USR_MONITOR7", $psprintf("print_transfers7 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer7 ended7 |---
	  // ---------------------
	  forever begin
	    // Wait7 until transfer7 ended7, and put the ended7 transfer7 in 'obj'.
	    @transaction_ended7; 

	    // Transaction7 recording7
	    transfer7.enable_recording("AHB7 transfers7 monitor7");
	    void'(transfer7.begin_tr());
	    transfer7.end_tr();

	    // Display7 a message about7 the transfer7 that just7 ended7
 	    `uvm_info("USR_MONITOR7", $psprintf(" %s to %0h with data %0h has ended7", transfer7.direction7.name(), transfer7.address, transfer7.data), UVM_MEDIUM)
      ahb_transfer_out7.write(transfer7);
	  end
  endtask

   // run() task is called automatically7
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR7", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers7(); 
   endtask

endclass

