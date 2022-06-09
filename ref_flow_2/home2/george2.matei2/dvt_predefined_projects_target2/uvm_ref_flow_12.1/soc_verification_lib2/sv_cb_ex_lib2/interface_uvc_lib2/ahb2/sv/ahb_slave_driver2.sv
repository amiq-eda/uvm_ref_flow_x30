// IVB2 checksum2: 519799952
/*-----------------------------------------------------------------
File2 name     : ahb_slave_driver2.sv
Created2       : Wed2 May2 19 15:42:21 2010
Description2   : This2 file implements2 the slave2 driver functionality
Notes2         : 
-----------------------------------------------------------------*/
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


`ifndef AHB_SLAVE_DRIVER_SV2
`define AHB_SLAVE_DRIVER_SV2

//------------------------------------------------------------------------------
//
// CLASS2: ahb_slave_driver2
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB2-NOTE2 : REQUIRED2 : slave2 DRIVER2 functionality : DRIVER2
   -------------------------------------------------------------------------
   Modify2 the following2 methods2 to match your2 protocol2:
     o respond_transfer2() - response driving2
     o reset_signals2() - slave2 signals2 reset values
   Note2 that if you change/add signals2 to the physical interface, you must
   also change these2 methods2.
   ***************************************************************************/

class ahb_slave_driver2 extends uvm_driver #(ahb_transfer2);

  // The virtual interface used to drive2 and view2 HDL signals2.
  virtual interface ahb_if2 vif2;
    
  // Count2 transfer_responses2 sent2
  int num_sent2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver2)

  // Constructor2 - required2 syntax2 for UVM automation2 and utilities2
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional2 class methods2
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive2();
  extern virtual protected task reset_signals2();
  extern virtual protected task send_response2(ahb_transfer2 response);
  extern virtual function void report();

endclass : ahb_slave_driver2

//UVM connect_phase
function void ahb_slave_driver2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if2)::get(this, "", "vif2", vif2))
   `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver2::run_phase(uvm_phase phase);
    fork
      get_and_drive2();
      reset_signals2();
    join
  endtask : run_phase

  // Continually2 detects2 transfers2
  task ahb_slave_driver2::get_and_drive2();
    @(posedge vif2.ahb_resetn2);
    `uvm_info(get_type_name(), "Reset2 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif2.ahb_clock2 iff vif2.AHB_HREADY2===1'b1);
      // Get2 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive2 the response
      send_response2(rsp);
      // Communicate2 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive2

  // Reset2 all signals2
  task ahb_slave_driver2::reset_signals2();
    forever begin
      @(negedge vif2.ahb_resetn2);
      `uvm_info(get_type_name(), "Reset2 observed2", UVM_MEDIUM)
      vif2.AHB_HREADY2      <= 0;
    end
  endtask : reset_signals2

  // Response2 to a transfer2 from the DUT
  task ahb_slave_driver2::send_response2(ahb_transfer2 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving2 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif2.AHB_HWDATA2;
    vif2.AHB_HREADY2  <= 1;
    @(posedge vif2.ahb_clock2);
    vif2.AHB_HREADY2 <= 0;
    @(posedge vif2.ahb_clock2);
    num_sent2++;
  endtask : send_response2

  // UVM report() phase
  function void ahb_slave_driver2::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport2: AHB2 slave2 driver sent2 %0d transfer2 responses2",
      num_sent2), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV2

