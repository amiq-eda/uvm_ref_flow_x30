// IVB24 checksum24: 519799952
/*-----------------------------------------------------------------
File24 name     : ahb_slave_driver24.sv
Created24       : Wed24 May24 19 15:42:21 2010
Description24   : This24 file implements24 the slave24 driver functionality
Notes24         : 
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV24
`define AHB_SLAVE_DRIVER_SV24

//------------------------------------------------------------------------------
//
// CLASS24: ahb_slave_driver24
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB24-NOTE24 : REQUIRED24 : slave24 DRIVER24 functionality : DRIVER24
   -------------------------------------------------------------------------
   Modify24 the following24 methods24 to match your24 protocol24:
     o respond_transfer24() - response driving24
     o reset_signals24() - slave24 signals24 reset values
   Note24 that if you change/add signals24 to the physical interface, you must
   also change these24 methods24.
   ***************************************************************************/

class ahb_slave_driver24 extends uvm_driver #(ahb_transfer24);

  // The virtual interface used to drive24 and view24 HDL signals24.
  virtual interface ahb_if24 vif24;
    
  // Count24 transfer_responses24 sent24
  int num_sent24;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver24)

  // Constructor24 - required24 syntax24 for UVM automation24 and utilities24
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional24 class methods24
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive24();
  extern virtual protected task reset_signals24();
  extern virtual protected task send_response24(ahb_transfer24 response);
  extern virtual function void report();

endclass : ahb_slave_driver24

//UVM connect_phase
function void ahb_slave_driver24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if24)::get(this, "", "vif24", vif24))
   `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver24::run_phase(uvm_phase phase);
    fork
      get_and_drive24();
      reset_signals24();
    join
  endtask : run_phase

  // Continually24 detects24 transfers24
  task ahb_slave_driver24::get_and_drive24();
    @(posedge vif24.ahb_resetn24);
    `uvm_info(get_type_name(), "Reset24 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif24.ahb_clock24 iff vif24.AHB_HREADY24===1'b1);
      // Get24 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive24 the response
      send_response24(rsp);
      // Communicate24 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive24

  // Reset24 all signals24
  task ahb_slave_driver24::reset_signals24();
    forever begin
      @(negedge vif24.ahb_resetn24);
      `uvm_info(get_type_name(), "Reset24 observed24", UVM_MEDIUM)
      vif24.AHB_HREADY24      <= 0;
    end
  endtask : reset_signals24

  // Response24 to a transfer24 from the DUT
  task ahb_slave_driver24::send_response24(ahb_transfer24 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving24 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif24.AHB_HWDATA24;
    vif24.AHB_HREADY24  <= 1;
    @(posedge vif24.ahb_clock24);
    vif24.AHB_HREADY24 <= 0;
    @(posedge vif24.ahb_clock24);
    num_sent24++;
  endtask : send_response24

  // UVM report() phase
  function void ahb_slave_driver24::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport24: AHB24 slave24 driver sent24 %0d transfer24 responses24",
      num_sent24), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV24

