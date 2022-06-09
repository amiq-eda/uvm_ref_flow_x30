/*-------------------------------------------------------------------------
File14 name   : ahb_user_monitor14.sv
Title14       : 
Project14     :
Created14     :
Description14 : 
Notes14       :
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

class ahb_monitor14 extends ahb_pkg14::ahb_master_monitor14;
   
  uvm_analysis_port #(ahb_pkg14::ahb_transfer14) ahb_transfer_out14;

  `uvm_component_utils(ahb_monitor14)

  function new (string name = "ahb_monitor14", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out14 = new("ahb_transfer_out14", this);
  endfunction

  virtual protected task print_transfers14();
    uvm_object obj;
     `uvm_info("USR_MONITOR14", $psprintf("print_transfers14 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer14 ended14 |---
	  // ---------------------
	  forever begin
	    // Wait14 until transfer14 ended14, and put the ended14 transfer14 in 'obj'.
	    @transaction_ended14; 

	    // Transaction14 recording14
	    transfer14.enable_recording("AHB14 transfers14 monitor14");
	    void'(transfer14.begin_tr());
	    transfer14.end_tr();

	    // Display14 a message about14 the transfer14 that just14 ended14
 	    `uvm_info("USR_MONITOR14", $psprintf(" %s to %0h with data %0h has ended14", transfer14.direction14.name(), transfer14.address, transfer14.data), UVM_MEDIUM)
      ahb_transfer_out14.write(transfer14);
	  end
  endtask

   // run() task is called automatically14
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR14", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers14(); 
   endtask

endclass

