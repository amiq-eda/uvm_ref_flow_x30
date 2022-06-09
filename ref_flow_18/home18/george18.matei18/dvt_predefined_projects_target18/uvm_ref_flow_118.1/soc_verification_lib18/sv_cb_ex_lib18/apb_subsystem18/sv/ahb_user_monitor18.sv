/*-------------------------------------------------------------------------
File18 name   : ahb_user_monitor18.sv
Title18       : 
Project18     :
Created18     :
Description18 : 
Notes18       :
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

class ahb_monitor18 extends ahb_pkg18::ahb_master_monitor18;
   
  uvm_analysis_port #(ahb_pkg18::ahb_transfer18) ahb_transfer_out18;

  `uvm_component_utils(ahb_monitor18)

  function new (string name = "ahb_monitor18", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out18 = new("ahb_transfer_out18", this);
  endfunction

  virtual protected task print_transfers18();
    uvm_object obj;
     `uvm_info("USR_MONITOR18", $psprintf("print_transfers18 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer18 ended18 |---
	  // ---------------------
	  forever begin
	    // Wait18 until transfer18 ended18, and put the ended18 transfer18 in 'obj'.
	    @transaction_ended18; 

	    // Transaction18 recording18
	    transfer18.enable_recording("AHB18 transfers18 monitor18");
	    void'(transfer18.begin_tr());
	    transfer18.end_tr();

	    // Display18 a message about18 the transfer18 that just18 ended18
 	    `uvm_info("USR_MONITOR18", $psprintf(" %s to %0h with data %0h has ended18", transfer18.direction18.name(), transfer18.address, transfer18.data), UVM_MEDIUM)
      ahb_transfer_out18.write(transfer18);
	  end
  endtask

   // run() task is called automatically18
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR18", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers18(); 
   endtask

endclass

