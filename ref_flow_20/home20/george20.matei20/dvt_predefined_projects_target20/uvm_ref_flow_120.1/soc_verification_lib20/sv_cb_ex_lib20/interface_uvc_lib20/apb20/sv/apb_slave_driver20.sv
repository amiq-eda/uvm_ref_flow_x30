/*******************************************************************************
  FILE : apb_slave_driver20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV20
`define APB_SLAVE_DRIVER_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_slave_driver20 declaration20
//------------------------------------------------------------------------------

class apb_slave_driver20 extends uvm_driver #(apb_transfer20);

  // The virtual interface used to drive20 and view20 HDL signals20.
  virtual apb_if20 vif20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils(apb_slave_driver20)

  // Constructor20
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive20();
  extern virtual task reset_signals20();
  extern virtual task respond_to_transfer20(apb_transfer20 resp20);

endclass : apb_slave_driver20

// UVM connect_phase - gets20 the vif20 as a config property
function void apb_slave_driver20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if20)::get(this, "", "vif20", vif20))
      `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

// Externed20 virtual declaration20 of the run_phase method.  This20 method
// fork/join_none's the get_and_drive20() and reset_signals20() methods20.
task apb_slave_driver20::run_phase(uvm_phase phase);
  fork
    get_and_drive20();
    reset_signals20();
  join
endtask : run_phase

// Function20 that manages20 the interaction20 between the slave20
// sequence sequencer and this slave20 driver.
task apb_slave_driver20::get_and_drive20();
  @(posedge vif20.preset20);
  `uvm_info(get_type_name(), "Reset20 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer20(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive20

// Process20 task that assigns20 signals20 to reset state when reset signal20 set
task apb_slave_driver20::reset_signals20();
  forever begin
    @(negedge vif20.preset20);
    `uvm_info(get_type_name(), "Reset20 observed20",  UVM_MEDIUM)
    vif20.prdata20 <= 32'hzzzz_zzzz;
    vif20.pready20 <= 0;
    vif20.pslverr20 <= 0;
  end
endtask : reset_signals20

  // This20 task drives20 the response phases of a transfer20.
task apb_slave_driver20::respond_to_transfer20(apb_transfer20 resp20);
  begin
    vif20.pready20 <= 1'b1;
    if (resp20.direction20 == APB_READ20)
      vif20.prdata20 <= resp20.data;
    @(posedge vif20.pclock20);
    vif20.prdata20 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer20

`endif // APB_SLAVE_DRIVER_SV20
