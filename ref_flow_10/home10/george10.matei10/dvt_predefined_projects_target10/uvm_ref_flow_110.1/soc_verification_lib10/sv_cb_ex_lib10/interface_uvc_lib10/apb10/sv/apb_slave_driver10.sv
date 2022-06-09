/*******************************************************************************
  FILE : apb_slave_driver10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV10
`define APB_SLAVE_DRIVER_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_slave_driver10 declaration10
//------------------------------------------------------------------------------

class apb_slave_driver10 extends uvm_driver #(apb_transfer10);

  // The virtual interface used to drive10 and view10 HDL signals10.
  virtual apb_if10 vif10;

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils(apb_slave_driver10)

  // Constructor10
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional10 class methods10
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive10();
  extern virtual task reset_signals10();
  extern virtual task respond_to_transfer10(apb_transfer10 resp10);

endclass : apb_slave_driver10

// UVM connect_phase - gets10 the vif10 as a config property
function void apb_slave_driver10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if10)::get(this, "", "vif10", vif10))
      `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

// Externed10 virtual declaration10 of the run_phase method.  This10 method
// fork/join_none's the get_and_drive10() and reset_signals10() methods10.
task apb_slave_driver10::run_phase(uvm_phase phase);
  fork
    get_and_drive10();
    reset_signals10();
  join
endtask : run_phase

// Function10 that manages10 the interaction10 between the slave10
// sequence sequencer and this slave10 driver.
task apb_slave_driver10::get_and_drive10();
  @(posedge vif10.preset10);
  `uvm_info(get_type_name(), "Reset10 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer10(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive10

// Process10 task that assigns10 signals10 to reset state when reset signal10 set
task apb_slave_driver10::reset_signals10();
  forever begin
    @(negedge vif10.preset10);
    `uvm_info(get_type_name(), "Reset10 observed10",  UVM_MEDIUM)
    vif10.prdata10 <= 32'hzzzz_zzzz;
    vif10.pready10 <= 0;
    vif10.pslverr10 <= 0;
  end
endtask : reset_signals10

  // This10 task drives10 the response phases of a transfer10.
task apb_slave_driver10::respond_to_transfer10(apb_transfer10 resp10);
  begin
    vif10.pready10 <= 1'b1;
    if (resp10.direction10 == APB_READ10)
      vif10.prdata10 <= resp10.data;
    @(posedge vif10.pclock10);
    vif10.prdata10 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer10

`endif // APB_SLAVE_DRIVER_SV10
