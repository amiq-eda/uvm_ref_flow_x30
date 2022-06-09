/*-------------------------------------------------------------------------
File29 name   : ahb_user_monitor29.sv
Title29       : 
Project29     :
Created29     :
Description29 : 
Notes29       :
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

class ahb_monitor29 extends ahb_pkg29::ahb_master_monitor29;
   
  uvm_analysis_port #(ahb_pkg29::ahb_transfer29) ahb_transfer_out29;

  `uvm_component_utils(ahb_monitor29)

  function new (string name = "ahb_monitor29", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out29 = new("ahb_transfer_out29", this);
  endfunction

  virtual protected task print_transfers29();
    uvm_object obj;
     `uvm_info("USR_MONITOR29", $psprintf("print_transfers29 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer29 ended29 |---
	  // ---------------------
	  forever begin
	    // Wait29 until transfer29 ended29, and put the ended29 transfer29 in 'obj'.
	    @transaction_ended29; 

	    // Transaction29 recording29
	    transfer29.enable_recording("AHB29 transfers29 monitor29");
	    void'(transfer29.begin_tr());
	    transfer29.end_tr();

	    // Display29 a message about29 the transfer29 that just29 ended29
 	    `uvm_info("USR_MONITOR29", $psprintf(" %s to %0h with data %0h has ended29", transfer29.direction29.name(), transfer29.address, transfer29.data), UVM_MEDIUM)
      ahb_transfer_out29.write(transfer29);
	  end
  endtask

   // run() task is called automatically29
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR29", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers29(); 
   endtask

endclass

