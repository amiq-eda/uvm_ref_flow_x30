/*******************************************************************************
  FILE : apb_slave_driver30.sv
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV30
`define APB_SLAVE_DRIVER_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_slave_driver30 declaration30
//------------------------------------------------------------------------------

class apb_slave_driver30 extends uvm_driver #(apb_transfer30);

  // The virtual interface used to drive30 and view30 HDL signals30.
  virtual apb_if30 vif30;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils(apb_slave_driver30)

  // Constructor30
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional30 class methods30
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive30();
  extern virtual task reset_signals30();
  extern virtual task respond_to_transfer30(apb_transfer30 resp30);

endclass : apb_slave_driver30

// UVM connect_phase - gets30 the vif30 as a config property
function void apb_slave_driver30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if30)::get(this, "", "vif30", vif30))
      `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

// Externed30 virtual declaration30 of the run_phase method.  This30 method
// fork/join_none's the get_and_drive30() and reset_signals30() methods30.
task apb_slave_driver30::run_phase(uvm_phase phase);
  fork
    get_and_drive30();
    reset_signals30();
  join
endtask : run_phase

// Function30 that manages30 the interaction30 between the slave30
// sequence sequencer and this slave30 driver.
task apb_slave_driver30::get_and_drive30();
  @(posedge vif30.preset30);
  `uvm_info(get_type_name(), "Reset30 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer30(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive30

// Process30 task that assigns30 signals30 to reset state when reset signal30 set
task apb_slave_driver30::reset_signals30();
  forever begin
    @(negedge vif30.preset30);
    `uvm_info(get_type_name(), "Reset30 observed30",  UVM_MEDIUM)
    vif30.prdata30 <= 32'hzzzz_zzzz;
    vif30.pready30 <= 0;
    vif30.pslverr30 <= 0;
  end
endtask : reset_signals30

  // This30 task drives30 the response phases of a transfer30.
task apb_slave_driver30::respond_to_transfer30(apb_transfer30 resp30);
  begin
    vif30.pready30 <= 1'b1;
    if (resp30.direction30 == APB_READ30)
      vif30.prdata30 <= resp30.data;
    @(posedge vif30.pclock30);
    vif30.prdata30 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer30

`endif // APB_SLAVE_DRIVER_SV30
