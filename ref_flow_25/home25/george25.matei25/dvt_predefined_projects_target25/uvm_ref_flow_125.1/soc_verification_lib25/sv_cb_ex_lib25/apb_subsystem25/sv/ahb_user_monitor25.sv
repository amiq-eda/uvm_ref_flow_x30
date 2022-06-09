/*-------------------------------------------------------------------------
File25 name   : ahb_user_monitor25.sv
Title25       : 
Project25     :
Created25     :
Description25 : 
Notes25       :
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

class ahb_monitor25 extends ahb_pkg25::ahb_master_monitor25;
   
  uvm_analysis_port #(ahb_pkg25::ahb_transfer25) ahb_transfer_out25;

  `uvm_component_utils(ahb_monitor25)

  function new (string name = "ahb_monitor25", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out25 = new("ahb_transfer_out25", this);
  endfunction

  virtual protected task print_transfers25();
    uvm_object obj;
     `uvm_info("USR_MONITOR25", $psprintf("print_transfers25 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer25 ended25 |---
	  // ---------------------
	  forever begin
	    // Wait25 until transfer25 ended25, and put the ended25 transfer25 in 'obj'.
	    @transaction_ended25; 

	    // Transaction25 recording25
	    transfer25.enable_recording("AHB25 transfers25 monitor25");
	    void'(transfer25.begin_tr());
	    transfer25.end_tr();

	    // Display25 a message about25 the transfer25 that just25 ended25
 	    `uvm_info("USR_MONITOR25", $psprintf(" %s to %0h with data %0h has ended25", transfer25.direction25.name(), transfer25.address, transfer25.data), UVM_MEDIUM)
      ahb_transfer_out25.write(transfer25);
	  end
  endtask

   // run() task is called automatically25
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR25", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers25(); 
   endtask

endclass

