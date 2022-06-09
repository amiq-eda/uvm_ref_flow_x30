/*-------------------------------------------------------------------------
File1 name   : ahb_user_monitor1.sv
Title1       : 
Project1     :
Created1     :
Description1 : 
Notes1       :
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

class ahb_monitor1 extends ahb_pkg1::ahb_master_monitor1;
   
  uvm_analysis_port #(ahb_pkg1::ahb_transfer1) ahb_transfer_out1;

  `uvm_component_utils(ahb_monitor1)

  function new (string name = "ahb_monitor1", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out1 = new("ahb_transfer_out1", this);
  endfunction

  virtual protected task print_transfers1();
    uvm_object obj;
     `uvm_info("USR_MONITOR1", $psprintf("print_transfers1 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer1 ended1 |---
	  // ---------------------
	  forever begin
	    // Wait1 until transfer1 ended1, and put the ended1 transfer1 in 'obj'.
	    @transaction_ended1; 

	    // Transaction1 recording1
	    transfer1.enable_recording("AHB1 transfers1 monitor1");
	    void'(transfer1.begin_tr());
	    transfer1.end_tr();

	    // Display1 a message about1 the transfer1 that just1 ended1
 	    `uvm_info("USR_MONITOR1", $psprintf(" %s to %0h with data %0h has ended1", transfer1.direction1.name(), transfer1.address, transfer1.data), UVM_MEDIUM)
      ahb_transfer_out1.write(transfer1);
	  end
  endtask

   // run() task is called automatically1
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR1", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers1(); 
   endtask

endclass

