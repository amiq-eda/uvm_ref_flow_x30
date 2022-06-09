/*-------------------------------------------------------------------------
File13 name   : ahb_user_monitor13.sv
Title13       : 
Project13     :
Created13     :
Description13 : 
Notes13       :
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

class ahb_monitor13 extends ahb_pkg13::ahb_master_monitor13;
   
  uvm_analysis_port #(ahb_pkg13::ahb_transfer13) ahb_transfer_out13;

  `uvm_component_utils(ahb_monitor13)

  function new (string name = "ahb_monitor13", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out13 = new("ahb_transfer_out13", this);
  endfunction

  virtual protected task print_transfers13();
    uvm_object obj;
     `uvm_info("USR_MONITOR13", $psprintf("print_transfers13 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer13 ended13 |---
	  // ---------------------
	  forever begin
	    // Wait13 until transfer13 ended13, and put the ended13 transfer13 in 'obj'.
	    @transaction_ended13; 

	    // Transaction13 recording13
	    transfer13.enable_recording("AHB13 transfers13 monitor13");
	    void'(transfer13.begin_tr());
	    transfer13.end_tr();

	    // Display13 a message about13 the transfer13 that just13 ended13
 	    `uvm_info("USR_MONITOR13", $psprintf(" %s to %0h with data %0h has ended13", transfer13.direction13.name(), transfer13.address, transfer13.data), UVM_MEDIUM)
      ahb_transfer_out13.write(transfer13);
	  end
  endtask

   // run() task is called automatically13
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR13", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers13(); 
   endtask

endclass

