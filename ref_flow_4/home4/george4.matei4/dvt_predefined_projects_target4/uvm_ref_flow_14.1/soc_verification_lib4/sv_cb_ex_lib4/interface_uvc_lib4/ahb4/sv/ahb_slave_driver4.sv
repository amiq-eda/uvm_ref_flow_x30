// IVB4 checksum4: 519799952
/*-----------------------------------------------------------------
File4 name     : ahb_slave_driver4.sv
Created4       : Wed4 May4 19 15:42:21 2010
Description4   : This4 file implements4 the slave4 driver functionality
Notes4         : 
-----------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV4
`define AHB_SLAVE_DRIVER_SV4

//------------------------------------------------------------------------------
//
// CLASS4: ahb_slave_driver4
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB4-NOTE4 : REQUIRED4 : slave4 DRIVER4 functionality : DRIVER4
   -------------------------------------------------------------------------
   Modify4 the following4 methods4 to match your4 protocol4:
     o respond_transfer4() - response driving4
     o reset_signals4() - slave4 signals4 reset values
   Note4 that if you change/add signals4 to the physical interface, you must
   also change these4 methods4.
   ***************************************************************************/

class ahb_slave_driver4 extends uvm_driver #(ahb_transfer4);

  // The virtual interface used to drive4 and view4 HDL signals4.
  virtual interface ahb_if4 vif4;
    
  // Count4 transfer_responses4 sent4
  int num_sent4;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver4)

  // Constructor4 - required4 syntax4 for UVM automation4 and utilities4
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional4 class methods4
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive4();
  extern virtual protected task reset_signals4();
  extern virtual protected task send_response4(ahb_transfer4 response);
  extern virtual function void report();

endclass : ahb_slave_driver4

//UVM connect_phase
function void ahb_slave_driver4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if4)::get(this, "", "vif4", vif4))
   `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver4::run_phase(uvm_phase phase);
    fork
      get_and_drive4();
      reset_signals4();
    join
  endtask : run_phase

  // Continually4 detects4 transfers4
  task ahb_slave_driver4::get_and_drive4();
    @(posedge vif4.ahb_resetn4);
    `uvm_info(get_type_name(), "Reset4 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif4.ahb_clock4 iff vif4.AHB_HREADY4===1'b1);
      // Get4 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive4 the response
      send_response4(rsp);
      // Communicate4 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive4

  // Reset4 all signals4
  task ahb_slave_driver4::reset_signals4();
    forever begin
      @(negedge vif4.ahb_resetn4);
      `uvm_info(get_type_name(), "Reset4 observed4", UVM_MEDIUM)
      vif4.AHB_HREADY4      <= 0;
    end
  endtask : reset_signals4

  // Response4 to a transfer4 from the DUT
  task ahb_slave_driver4::send_response4(ahb_transfer4 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving4 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif4.AHB_HWDATA4;
    vif4.AHB_HREADY4  <= 1;
    @(posedge vif4.ahb_clock4);
    vif4.AHB_HREADY4 <= 0;
    @(posedge vif4.ahb_clock4);
    num_sent4++;
  endtask : send_response4

  // UVM report() phase
  function void ahb_slave_driver4::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport4: AHB4 slave4 driver sent4 %0d transfer4 responses4",
      num_sent4), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV4

