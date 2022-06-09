/*******************************************************************************
  FILE : apb_slave_driver11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV11
`define APB_SLAVE_DRIVER_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_slave_driver11 declaration11
//------------------------------------------------------------------------------

class apb_slave_driver11 extends uvm_driver #(apb_transfer11);

  // The virtual interface used to drive11 and view11 HDL signals11.
  virtual apb_if11 vif11;

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils(apb_slave_driver11)

  // Constructor11
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional11 class methods11
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive11();
  extern virtual task reset_signals11();
  extern virtual task respond_to_transfer11(apb_transfer11 resp11);

endclass : apb_slave_driver11

// UVM connect_phase - gets11 the vif11 as a config property
function void apb_slave_driver11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if11)::get(this, "", "vif11", vif11))
      `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

// Externed11 virtual declaration11 of the run_phase method.  This11 method
// fork/join_none's the get_and_drive11() and reset_signals11() methods11.
task apb_slave_driver11::run_phase(uvm_phase phase);
  fork
    get_and_drive11();
    reset_signals11();
  join
endtask : run_phase

// Function11 that manages11 the interaction11 between the slave11
// sequence sequencer and this slave11 driver.
task apb_slave_driver11::get_and_drive11();
  @(posedge vif11.preset11);
  `uvm_info(get_type_name(), "Reset11 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer11(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive11

// Process11 task that assigns11 signals11 to reset state when reset signal11 set
task apb_slave_driver11::reset_signals11();
  forever begin
    @(negedge vif11.preset11);
    `uvm_info(get_type_name(), "Reset11 observed11",  UVM_MEDIUM)
    vif11.prdata11 <= 32'hzzzz_zzzz;
    vif11.pready11 <= 0;
    vif11.pslverr11 <= 0;
  end
endtask : reset_signals11

  // This11 task drives11 the response phases of a transfer11.
task apb_slave_driver11::respond_to_transfer11(apb_transfer11 resp11);
  begin
    vif11.pready11 <= 1'b1;
    if (resp11.direction11 == APB_READ11)
      vif11.prdata11 <= resp11.data;
    @(posedge vif11.pclock11);
    vif11.prdata11 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer11

`endif // APB_SLAVE_DRIVER_SV11
