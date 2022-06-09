/*******************************************************************************
  FILE : apb_slave_driver28.sv
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV28
`define APB_SLAVE_DRIVER_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_slave_driver28 declaration28
//------------------------------------------------------------------------------

class apb_slave_driver28 extends uvm_driver #(apb_transfer28);

  // The virtual interface used to drive28 and view28 HDL signals28.
  virtual apb_if28 vif28;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils(apb_slave_driver28)

  // Constructor28
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional28 class methods28
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive28();
  extern virtual task reset_signals28();
  extern virtual task respond_to_transfer28(apb_transfer28 resp28);

endclass : apb_slave_driver28

// UVM connect_phase - gets28 the vif28 as a config property
function void apb_slave_driver28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if28)::get(this, "", "vif28", vif28))
      `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

// Externed28 virtual declaration28 of the run_phase method.  This28 method
// fork/join_none's the get_and_drive28() and reset_signals28() methods28.
task apb_slave_driver28::run_phase(uvm_phase phase);
  fork
    get_and_drive28();
    reset_signals28();
  join
endtask : run_phase

// Function28 that manages28 the interaction28 between the slave28
// sequence sequencer and this slave28 driver.
task apb_slave_driver28::get_and_drive28();
  @(posedge vif28.preset28);
  `uvm_info(get_type_name(), "Reset28 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer28(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive28

// Process28 task that assigns28 signals28 to reset state when reset signal28 set
task apb_slave_driver28::reset_signals28();
  forever begin
    @(negedge vif28.preset28);
    `uvm_info(get_type_name(), "Reset28 observed28",  UVM_MEDIUM)
    vif28.prdata28 <= 32'hzzzz_zzzz;
    vif28.pready28 <= 0;
    vif28.pslverr28 <= 0;
  end
endtask : reset_signals28

  // This28 task drives28 the response phases of a transfer28.
task apb_slave_driver28::respond_to_transfer28(apb_transfer28 resp28);
  begin
    vif28.pready28 <= 1'b1;
    if (resp28.direction28 == APB_READ28)
      vif28.prdata28 <= resp28.data;
    @(posedge vif28.pclock28);
    vif28.prdata28 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer28

`endif // APB_SLAVE_DRIVER_SV28
