/*-------------------------------------------------------------------------
File2 name   : ahb_user_monitor2.sv
Title2       : 
Project2     :
Created2     :
Description2 : 
Notes2       :
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

class ahb_monitor2 extends ahb_pkg2::ahb_master_monitor2;
   
  uvm_analysis_port #(ahb_pkg2::ahb_transfer2) ahb_transfer_out2;

  `uvm_component_utils(ahb_monitor2)

  function new (string name = "ahb_monitor2", uvm_component parent);
    super.new(name, parent);
    ahb_transfer_out2 = new("ahb_transfer_out2", this);
  endfunction

  virtual protected task print_transfers2();
    uvm_object obj;
     `uvm_info("USR_MONITOR2", $psprintf("print_transfers2 called"), UVM_MEDIUM)
		
	  // ---------------------
	  // ---| transfer2 ended2 |---
	  // ---------------------
	  forever begin
	    // Wait2 until transfer2 ended2, and put the ended2 transfer2 in 'obj'.
	    @transaction_ended2; 

	    // Transaction2 recording2
	    transfer2.enable_recording("AHB2 transfers2 monitor2");
	    void'(transfer2.begin_tr());
	    transfer2.end_tr();

	    // Display2 a message about2 the transfer2 that just2 ended2
 	    `uvm_info("USR_MONITOR2", $psprintf(" %s to %0h with data %0h has ended2", transfer2.direction2.name(), transfer2.address, transfer2.data), UVM_MEDIUM)
      ahb_transfer_out2.write(transfer2);
	  end
  endtask

   // run() task is called automatically2
   virtual task run_phase(uvm_phase phase);
     `uvm_info("USR_MONITOR2", $psprintf("run started"), UVM_LOW)
     super.run_phase(phase);
     print_transfers2(); 
   endtask

endclass

