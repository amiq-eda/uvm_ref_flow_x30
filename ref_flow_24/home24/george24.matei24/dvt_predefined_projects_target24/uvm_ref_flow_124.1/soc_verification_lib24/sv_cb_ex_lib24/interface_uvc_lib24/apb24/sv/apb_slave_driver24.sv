/*******************************************************************************
  FILE : apb_slave_driver24.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_DRIVER_SV24
`define APB_SLAVE_DRIVER_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_slave_driver24 declaration24
//------------------------------------------------------------------------------

class apb_slave_driver24 extends uvm_driver #(apb_transfer24);

  // The virtual interface used to drive24 and view24 HDL signals24.
  virtual apb_if24 vif24;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils(apb_slave_driver24)

  // Constructor24
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive24();
  extern virtual task reset_signals24();
  extern virtual task respond_to_transfer24(apb_transfer24 resp24);

endclass : apb_slave_driver24

// UVM connect_phase - gets24 the vif24 as a config property
function void apb_slave_driver24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if24)::get(this, "", "vif24", vif24))
      `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

// Externed24 virtual declaration24 of the run_phase method.  This24 method
// fork/join_none's the get_and_drive24() and reset_signals24() methods24.
task apb_slave_driver24::run_phase(uvm_phase phase);
  fork
    get_and_drive24();
    reset_signals24();
  join
endtask : run_phase

// Function24 that manages24 the interaction24 between the slave24
// sequence sequencer and this slave24 driver.
task apb_slave_driver24::get_and_drive24();
  @(posedge vif24.preset24);
  `uvm_info(get_type_name(), "Reset24 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer24(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive24

// Process24 task that assigns24 signals24 to reset state when reset signal24 set
task apb_slave_driver24::reset_signals24();
  forever begin
    @(negedge vif24.preset24);
    `uvm_info(get_type_name(), "Reset24 observed24",  UVM_MEDIUM)
    vif24.prdata24 <= 32'hzzzz_zzzz;
    vif24.pready24 <= 0;
    vif24.pslverr24 <= 0;
  end
endtask : reset_signals24

  // This24 task drives24 the response phases of a transfer24.
task apb_slave_driver24::respond_to_transfer24(apb_transfer24 resp24);
  begin
    vif24.pready24 <= 1'b1;
    if (resp24.direction24 == APB_READ24)
      vif24.prdata24 <= resp24.data;
    @(posedge vif24.pclock24);
    vif24.prdata24 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer24

`endif // APB_SLAVE_DRIVER_SV24
