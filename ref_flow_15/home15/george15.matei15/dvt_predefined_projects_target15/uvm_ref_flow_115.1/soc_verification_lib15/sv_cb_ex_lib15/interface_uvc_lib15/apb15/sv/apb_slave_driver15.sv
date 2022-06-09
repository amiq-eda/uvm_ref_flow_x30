/*******************************************************************************
  FILE : apb_slave_driver15.sv
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV15
`define APB_SLAVE_DRIVER_SV15

//------------------------------------------------------------------------------
// CLASS15: apb_slave_driver15 declaration15
//------------------------------------------------------------------------------

class apb_slave_driver15 extends uvm_driver #(apb_transfer15);

  // The virtual interface used to drive15 and view15 HDL signals15.
  virtual apb_if15 vif15;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils(apb_slave_driver15)

  // Constructor15
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional15 class methods15
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive15();
  extern virtual task reset_signals15();
  extern virtual task respond_to_transfer15(apb_transfer15 resp15);

endclass : apb_slave_driver15

// UVM connect_phase - gets15 the vif15 as a config property
function void apb_slave_driver15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if15)::get(this, "", "vif15", vif15))
      `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

// Externed15 virtual declaration15 of the run_phase method.  This15 method
// fork/join_none's the get_and_drive15() and reset_signals15() methods15.
task apb_slave_driver15::run_phase(uvm_phase phase);
  fork
    get_and_drive15();
    reset_signals15();
  join
endtask : run_phase

// Function15 that manages15 the interaction15 between the slave15
// sequence sequencer and this slave15 driver.
task apb_slave_driver15::get_and_drive15();
  @(posedge vif15.preset15);
  `uvm_info(get_type_name(), "Reset15 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer15(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive15

// Process15 task that assigns15 signals15 to reset state when reset signal15 set
task apb_slave_driver15::reset_signals15();
  forever begin
    @(negedge vif15.preset15);
    `uvm_info(get_type_name(), "Reset15 observed15",  UVM_MEDIUM)
    vif15.prdata15 <= 32'hzzzz_zzzz;
    vif15.pready15 <= 0;
    vif15.pslverr15 <= 0;
  end
endtask : reset_signals15

  // This15 task drives15 the response phases of a transfer15.
task apb_slave_driver15::respond_to_transfer15(apb_transfer15 resp15);
  begin
    vif15.pready15 <= 1'b1;
    if (resp15.direction15 == APB_READ15)
      vif15.prdata15 <= resp15.data;
    @(posedge vif15.pclock15);
    vif15.prdata15 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer15

`endif // APB_SLAVE_DRIVER_SV15
