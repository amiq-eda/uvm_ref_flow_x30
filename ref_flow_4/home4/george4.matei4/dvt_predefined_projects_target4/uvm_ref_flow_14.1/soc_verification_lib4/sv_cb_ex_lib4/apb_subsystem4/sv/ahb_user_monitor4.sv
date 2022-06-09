/*-------------------------------------------------------------------------
File4 name   : ahb_user_monitor4.sv
Title4       : 
Project4     :
Created4     :
Description4 : 
Notes4       :
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

class ahb_monitor4 extends ahb_pkg4::ahb_master_monitor4;
   
  uvm_analysis_port #(ahb_pkg4::ahb_transfer4) ahb_transfer_out4;

  `uvm_component_utils(ahb_monitor4)

  function new (string name = "ahb_monitor4", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out4 = new("ahb_transfer_out4", this);
  endfunction

  virtual protected task print_transfers4();
    uvm_object obj;
     `uvm_info("USR_MONITOR4", $psprintf("print_transfers4 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer4 ended4 |---
	  // ---------------------
	  forever begin
	    // Wait4 until transfer4 ended4, and put the ended4 transfer4 in 'obj'.
	    @transaction_ended4; 

	    // Transaction4 recording4
	    transfer4.enable_recording("AHB4 transfers4 monitor4");
	    void'(transfer4.begin_tr());
	    transfer4.end_tr();

	    // Display4 a message about4 the transfer4 that just4 ended4
 	    `uvm_info("USR_MONITOR4", $psprintf(" %s to %0h with data %0h has ended4", transfer4.direction4.name(), transfer4.address, transfer4.data), UVM_MEDIUM)
      ahb_transfer_out4.write(transfer4);
	  end
  endtask

   // run() task is called automatically4
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR4", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers4(); 
   endtask

endclass

