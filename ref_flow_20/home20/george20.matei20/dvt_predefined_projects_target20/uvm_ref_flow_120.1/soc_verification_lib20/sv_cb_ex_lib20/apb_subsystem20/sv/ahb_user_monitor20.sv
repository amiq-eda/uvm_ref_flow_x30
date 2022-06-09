/*-------------------------------------------------------------------------
File20 name   : ahb_user_monitor20.sv
Title20       : 
Project20     :
Created20     :
Description20 : 
Notes20       :
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

class ahb_monitor20 extends ahb_pkg20::ahb_master_monitor20;
   
  uvm_analysis_port #(ahb_pkg20::ahb_transfer20) ahb_transfer_out20;

  `uvm_component_utils(ahb_monitor20)

  function new (string name = "ahb_monitor20", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out20 = new("ahb_transfer_out20", this);
  endfunction

  virtual protected task print_transfers20();
    uvm_object obj;
     `uvm_info("USR_MONITOR20", $psprintf("print_transfers20 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer20 ended20 |---
	  // ---------------------
	  forever begin
	    // Wait20 until transfer20 ended20, and put the ended20 transfer20 in 'obj'.
	    @transaction_ended20; 

	    // Transaction20 recording20
	    transfer20.enable_recording("AHB20 transfers20 monitor20");
	    void'(transfer20.begin_tr());
	    transfer20.end_tr();

	    // Display20 a message about20 the transfer20 that just20 ended20
 	    `uvm_info("USR_MONITOR20", $psprintf(" %s to %0h with data %0h has ended20", transfer20.direction20.name(), transfer20.address, transfer20.data), UVM_MEDIUM)
      ahb_transfer_out20.write(transfer20);
	  end
  endtask

   // run() task is called automatically20
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR20", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers20(); 
   endtask

endclass

