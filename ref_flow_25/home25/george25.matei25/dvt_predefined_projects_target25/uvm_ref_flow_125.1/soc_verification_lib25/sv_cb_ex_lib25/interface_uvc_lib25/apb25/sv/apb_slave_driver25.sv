/*******************************************************************************
  FILE : apb_slave_driver25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV25
`define APB_SLAVE_DRIVER_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_slave_driver25 declaration25
//------------------------------------------------------------------------------

class apb_slave_driver25 extends uvm_driver #(apb_transfer25);

  // The virtual interface used to drive25 and view25 HDL signals25.
  virtual apb_if25 vif25;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils(apb_slave_driver25)

  // Constructor25
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive25();
  extern virtual task reset_signals25();
  extern virtual task respond_to_transfer25(apb_transfer25 resp25);

endclass : apb_slave_driver25

// UVM connect_phase - gets25 the vif25 as a config property
function void apb_slave_driver25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if25)::get(this, "", "vif25", vif25))
      `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

// Externed25 virtual declaration25 of the run_phase method.  This25 method
// fork/join_none's the get_and_drive25() and reset_signals25() methods25.
task apb_slave_driver25::run_phase(uvm_phase phase);
  fork
    get_and_drive25();
    reset_signals25();
  join
endtask : run_phase

// Function25 that manages25 the interaction25 between the slave25
// sequence sequencer and this slave25 driver.
task apb_slave_driver25::get_and_drive25();
  @(posedge vif25.preset25);
  `uvm_info(get_type_name(), "Reset25 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer25(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive25

// Process25 task that assigns25 signals25 to reset state when reset signal25 set
task apb_slave_driver25::reset_signals25();
  forever begin
    @(negedge vif25.preset25);
    `uvm_info(get_type_name(), "Reset25 observed25",  UVM_MEDIUM)
    vif25.prdata25 <= 32'hzzzz_zzzz;
    vif25.pready25 <= 0;
    vif25.pslverr25 <= 0;
  end
endtask : reset_signals25

  // This25 task drives25 the response phases of a transfer25.
task apb_slave_driver25::respond_to_transfer25(apb_transfer25 resp25);
  begin
    vif25.pready25 <= 1'b1;
    if (resp25.direction25 == APB_READ25)
      vif25.prdata25 <= resp25.data;
    @(posedge vif25.pclock25);
    vif25.prdata25 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer25

`endif // APB_SLAVE_DRIVER_SV25
