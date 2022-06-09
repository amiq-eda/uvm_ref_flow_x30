/*******************************************************************************
  FILE : apb_slave_driver16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV16
`define APB_SLAVE_DRIVER_SV16

//------------------------------------------------------------------------------
// CLASS16: apb_slave_driver16 declaration16
//------------------------------------------------------------------------------

class apb_slave_driver16 extends uvm_driver #(apb_transfer16);

  // The virtual interface used to drive16 and view16 HDL signals16.
  virtual apb_if16 vif16;

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils(apb_slave_driver16)

  // Constructor16
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive16();
  extern virtual task reset_signals16();
  extern virtual task respond_to_transfer16(apb_transfer16 resp16);

endclass : apb_slave_driver16

// UVM connect_phase - gets16 the vif16 as a config property
function void apb_slave_driver16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if16)::get(this, "", "vif16", vif16))
      `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

// Externed16 virtual declaration16 of the run_phase method.  This16 method
// fork/join_none's the get_and_drive16() and reset_signals16() methods16.
task apb_slave_driver16::run_phase(uvm_phase phase);
  fork
    get_and_drive16();
    reset_signals16();
  join
endtask : run_phase

// Function16 that manages16 the interaction16 between the slave16
// sequence sequencer and this slave16 driver.
task apb_slave_driver16::get_and_drive16();
  @(posedge vif16.preset16);
  `uvm_info(get_type_name(), "Reset16 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer16(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive16

// Process16 task that assigns16 signals16 to reset state when reset signal16 set
task apb_slave_driver16::reset_signals16();
  forever begin
    @(negedge vif16.preset16);
    `uvm_info(get_type_name(), "Reset16 observed16",  UVM_MEDIUM)
    vif16.prdata16 <= 32'hzzzz_zzzz;
    vif16.pready16 <= 0;
    vif16.pslverr16 <= 0;
  end
endtask : reset_signals16

  // This16 task drives16 the response phases of a transfer16.
task apb_slave_driver16::respond_to_transfer16(apb_transfer16 resp16);
  begin
    vif16.pready16 <= 1'b1;
    if (resp16.direction16 == APB_READ16)
      vif16.prdata16 <= resp16.data;
    @(posedge vif16.pclock16);
    vif16.prdata16 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer16

`endif // APB_SLAVE_DRIVER_SV16
