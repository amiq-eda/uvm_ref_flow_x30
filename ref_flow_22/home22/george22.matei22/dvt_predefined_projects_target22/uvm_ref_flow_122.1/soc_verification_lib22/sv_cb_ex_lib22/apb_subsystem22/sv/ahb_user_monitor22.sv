/*-------------------------------------------------------------------------
File22 name   : ahb_user_monitor22.sv
Title22       : 
Project22     :
Created22     :
Description22 : 
Notes22       :
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

class ahb_monitor22 extends ahb_pkg22::ahb_master_monitor22;
   
  uvm_analysis_port #(ahb_pkg22::ahb_transfer22) ahb_transfer_out22;

  `uvm_component_utils(ahb_monitor22)

  function new (string name = "ahb_monitor22", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out22 = new("ahb_transfer_out22", this);
  endfunction

  virtual protected task print_transfers22();
    uvm_object obj;
     `uvm_info("USR_MONITOR22", $psprintf("print_transfers22 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer22 ended22 |---
	  // ---------------------
	  forever begin
	    // Wait22 until transfer22 ended22, and put the ended22 transfer22 in 'obj'.
	    @transaction_ended22; 

	    // Transaction22 recording22
	    transfer22.enable_recording("AHB22 transfers22 monitor22");
	    void'(transfer22.begin_tr());
	    transfer22.end_tr();

	    // Display22 a message about22 the transfer22 that just22 ended22
 	    `uvm_info("USR_MONITOR22", $psprintf(" %s to %0h with data %0h has ended22", transfer22.direction22.name(), transfer22.address, transfer22.data), UVM_MEDIUM)
      ahb_transfer_out22.write(transfer22);
	  end
  endtask

   // run() task is called automatically22
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR22", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers22(); 
   endtask

endclass

