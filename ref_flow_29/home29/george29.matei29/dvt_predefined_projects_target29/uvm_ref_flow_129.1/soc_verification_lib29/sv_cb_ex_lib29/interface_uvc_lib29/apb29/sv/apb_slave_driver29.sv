/*******************************************************************************
  FILE : apb_slave_driver29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV29
`define APB_SLAVE_DRIVER_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_slave_driver29 declaration29
//------------------------------------------------------------------------------

class apb_slave_driver29 extends uvm_driver #(apb_transfer29);

  // The virtual interface used to drive29 and view29 HDL signals29.
  virtual apb_if29 vif29;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils(apb_slave_driver29)

  // Constructor29
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive29();
  extern virtual task reset_signals29();
  extern virtual task respond_to_transfer29(apb_transfer29 resp29);

endclass : apb_slave_driver29

// UVM connect_phase - gets29 the vif29 as a config property
function void apb_slave_driver29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if29)::get(this, "", "vif29", vif29))
      `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

// Externed29 virtual declaration29 of the run_phase method.  This29 method
// fork/join_none's the get_and_drive29() and reset_signals29() methods29.
task apb_slave_driver29::run_phase(uvm_phase phase);
  fork
    get_and_drive29();
    reset_signals29();
  join
endtask : run_phase

// Function29 that manages29 the interaction29 between the slave29
// sequence sequencer and this slave29 driver.
task apb_slave_driver29::get_and_drive29();
  @(posedge vif29.preset29);
  `uvm_info(get_type_name(), "Reset29 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer29(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive29

// Process29 task that assigns29 signals29 to reset state when reset signal29 set
task apb_slave_driver29::reset_signals29();
  forever begin
    @(negedge vif29.preset29);
    `uvm_info(get_type_name(), "Reset29 observed29",  UVM_MEDIUM)
    vif29.prdata29 <= 32'hzzzz_zzzz;
    vif29.pready29 <= 0;
    vif29.pslverr29 <= 0;
  end
endtask : reset_signals29

  // This29 task drives29 the response phases of a transfer29.
task apb_slave_driver29::respond_to_transfer29(apb_transfer29 resp29);
  begin
    vif29.pready29 <= 1'b1;
    if (resp29.direction29 == APB_READ29)
      vif29.prdata29 <= resp29.data;
    @(posedge vif29.pclock29);
    vif29.prdata29 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer29

`endif // APB_SLAVE_DRIVER_SV29
