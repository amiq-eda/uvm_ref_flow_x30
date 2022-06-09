/*-------------------------------------------------------------------------
File19 name   : ahb_user_monitor19.sv
Title19       : 
Project19     :
Created19     :
Description19 : 
Notes19       :
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

class ahb_monitor19 extends ahb_pkg19::ahb_master_monitor19;
   
  uvm_analysis_port #(ahb_pkg19::ahb_transfer19) ahb_transfer_out19;

  `uvm_component_utils(ahb_monitor19)

  function new (string name = "ahb_monitor19", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out19 = new("ahb_transfer_out19", this);
  endfunction

  virtual protected task print_transfers19();
    uvm_object obj;
     `uvm_info("USR_MONITOR19", $psprintf("print_transfers19 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer19 ended19 |---
	  // ---------------------
	  forever begin
	    // Wait19 until transfer19 ended19, and put the ended19 transfer19 in 'obj'.
	    @transaction_ended19; 

	    // Transaction19 recording19
	    transfer19.enable_recording("AHB19 transfers19 monitor19");
	    void'(transfer19.begin_tr());
	    transfer19.end_tr();

	    // Display19 a message about19 the transfer19 that just19 ended19
 	    `uvm_info("USR_MONITOR19", $psprintf(" %s to %0h with data %0h has ended19", transfer19.direction19.name(), transfer19.address, transfer19.data), UVM_MEDIUM)
      ahb_transfer_out19.write(transfer19);
	  end
  endtask

   // run() task is called automatically19
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR19", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers19(); 
   endtask

endclass

