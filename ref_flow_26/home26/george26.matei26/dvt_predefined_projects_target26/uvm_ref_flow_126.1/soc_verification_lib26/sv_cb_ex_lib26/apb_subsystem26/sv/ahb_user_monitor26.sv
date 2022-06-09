/*-------------------------------------------------------------------------
File26 name   : ahb_user_monitor26.sv
Title26       : 
Project26     :
Created26     :
Description26 : 
Notes26       :
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

class ahb_monitor26 extends ahb_pkg26::ahb_master_monitor26;
   
  uvm_analysis_port #(ahb_pkg26::ahb_transfer26) ahb_transfer_out26;

  `uvm_component_utils(ahb_monitor26)

  function new (string name = "ahb_monitor26", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out26 = new("ahb_transfer_out26", this);
  endfunction

  virtual protected task print_transfers26();
    uvm_object obj;
     `uvm_info("USR_MONITOR26", $psprintf("print_transfers26 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer26 ended26 |---
	  // ---------------------
	  forever begin
	    // Wait26 until transfer26 ended26, and put the ended26 transfer26 in 'obj'.
	    @transaction_ended26; 

	    // Transaction26 recording26
	    transfer26.enable_recording("AHB26 transfers26 monitor26");
	    void'(transfer26.begin_tr());
	    transfer26.end_tr();

	    // Display26 a message about26 the transfer26 that just26 ended26
 	    `uvm_info("USR_MONITOR26", $psprintf(" %s to %0h with data %0h has ended26", transfer26.direction26.name(), transfer26.address, transfer26.data), UVM_MEDIUM)
      ahb_transfer_out26.write(transfer26);
	  end
  endtask

   // run() task is called automatically26
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR26", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers26(); 
   endtask

endclass

