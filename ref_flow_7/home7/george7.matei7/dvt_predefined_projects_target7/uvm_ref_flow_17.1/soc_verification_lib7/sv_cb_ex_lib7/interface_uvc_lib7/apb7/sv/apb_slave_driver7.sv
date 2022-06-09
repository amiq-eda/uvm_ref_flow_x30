/*******************************************************************************
  FILE : apb_slave_driver7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV7
`define APB_SLAVE_DRIVER_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_slave_driver7 declaration7
//------------------------------------------------------------------------------

class apb_slave_driver7 extends uvm_driver #(apb_transfer7);

  // The virtual interface used to drive7 and view7 HDL signals7.
  virtual apb_if7 vif7;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils(apb_slave_driver7)

  // Constructor7
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive7();
  extern virtual task reset_signals7();
  extern virtual task respond_to_transfer7(apb_transfer7 resp7);

endclass : apb_slave_driver7

// UVM connect_phase - gets7 the vif7 as a config property
function void apb_slave_driver7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if7)::get(this, "", "vif7", vif7))
      `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

// Externed7 virtual declaration7 of the run_phase method.  This7 method
// fork/join_none's the get_and_drive7() and reset_signals7() methods7.
task apb_slave_driver7::run_phase(uvm_phase phase);
  fork
    get_and_drive7();
    reset_signals7();
  join
endtask : run_phase

// Function7 that manages7 the interaction7 between the slave7
// sequence sequencer and this slave7 driver.
task apb_slave_driver7::get_and_drive7();
  @(posedge vif7.preset7);
  `uvm_info(get_type_name(), "Reset7 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer7(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive7

// Process7 task that assigns7 signals7 to reset state when reset signal7 set
task apb_slave_driver7::reset_signals7();
  forever begin
    @(negedge vif7.preset7);
    `uvm_info(get_type_name(), "Reset7 observed7",  UVM_MEDIUM)
    vif7.prdata7 <= 32'hzzzz_zzzz;
    vif7.pready7 <= 0;
    vif7.pslverr7 <= 0;
  end
endtask : reset_signals7

  // This7 task drives7 the response phases of a transfer7.
task apb_slave_driver7::respond_to_transfer7(apb_transfer7 resp7);
  begin
    vif7.pready7 <= 1'b1;
    if (resp7.direction7 == APB_READ7)
      vif7.prdata7 <= resp7.data;
    @(posedge vif7.pclock7);
    vif7.prdata7 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer7

`endif // APB_SLAVE_DRIVER_SV7
