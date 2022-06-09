/*******************************************************************************
  FILE : apb_slave_driver27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV27
`define APB_SLAVE_DRIVER_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_slave_driver27 declaration27
//------------------------------------------------------------------------------

class apb_slave_driver27 extends uvm_driver #(apb_transfer27);

  // The virtual interface used to drive27 and view27 HDL signals27.
  virtual apb_if27 vif27;

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils(apb_slave_driver27)

  // Constructor27
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional27 class methods27
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive27();
  extern virtual task reset_signals27();
  extern virtual task respond_to_transfer27(apb_transfer27 resp27);

endclass : apb_slave_driver27

// UVM connect_phase - gets27 the vif27 as a config property
function void apb_slave_driver27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if27)::get(this, "", "vif27", vif27))
      `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

// Externed27 virtual declaration27 of the run_phase method.  This27 method
// fork/join_none's the get_and_drive27() and reset_signals27() methods27.
task apb_slave_driver27::run_phase(uvm_phase phase);
  fork
    get_and_drive27();
    reset_signals27();
  join
endtask : run_phase

// Function27 that manages27 the interaction27 between the slave27
// sequence sequencer and this slave27 driver.
task apb_slave_driver27::get_and_drive27();
  @(posedge vif27.preset27);
  `uvm_info(get_type_name(), "Reset27 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer27(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive27

// Process27 task that assigns27 signals27 to reset state when reset signal27 set
task apb_slave_driver27::reset_signals27();
  forever begin
    @(negedge vif27.preset27);
    `uvm_info(get_type_name(), "Reset27 observed27",  UVM_MEDIUM)
    vif27.prdata27 <= 32'hzzzz_zzzz;
    vif27.pready27 <= 0;
    vif27.pslverr27 <= 0;
  end
endtask : reset_signals27

  // This27 task drives27 the response phases of a transfer27.
task apb_slave_driver27::respond_to_transfer27(apb_transfer27 resp27);
  begin
    vif27.pready27 <= 1'b1;
    if (resp27.direction27 == APB_READ27)
      vif27.prdata27 <= resp27.data;
    @(posedge vif27.pclock27);
    vif27.prdata27 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer27

`endif // APB_SLAVE_DRIVER_SV27
