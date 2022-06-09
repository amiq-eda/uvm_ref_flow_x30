/*******************************************************************************
  FILE : apb_slave_driver26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV26
`define APB_SLAVE_DRIVER_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_slave_driver26 declaration26
//------------------------------------------------------------------------------

class apb_slave_driver26 extends uvm_driver #(apb_transfer26);

  // The virtual interface used to drive26 and view26 HDL signals26.
  virtual apb_if26 vif26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils(apb_slave_driver26)

  // Constructor26
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive26();
  extern virtual task reset_signals26();
  extern virtual task respond_to_transfer26(apb_transfer26 resp26);

endclass : apb_slave_driver26

// UVM connect_phase - gets26 the vif26 as a config property
function void apb_slave_driver26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if26)::get(this, "", "vif26", vif26))
      `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

// Externed26 virtual declaration26 of the run_phase method.  This26 method
// fork/join_none's the get_and_drive26() and reset_signals26() methods26.
task apb_slave_driver26::run_phase(uvm_phase phase);
  fork
    get_and_drive26();
    reset_signals26();
  join
endtask : run_phase

// Function26 that manages26 the interaction26 between the slave26
// sequence sequencer and this slave26 driver.
task apb_slave_driver26::get_and_drive26();
  @(posedge vif26.preset26);
  `uvm_info(get_type_name(), "Reset26 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer26(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive26

// Process26 task that assigns26 signals26 to reset state when reset signal26 set
task apb_slave_driver26::reset_signals26();
  forever begin
    @(negedge vif26.preset26);
    `uvm_info(get_type_name(), "Reset26 observed26",  UVM_MEDIUM)
    vif26.prdata26 <= 32'hzzzz_zzzz;
    vif26.pready26 <= 0;
    vif26.pslverr26 <= 0;
  end
endtask : reset_signals26

  // This26 task drives26 the response phases of a transfer26.
task apb_slave_driver26::respond_to_transfer26(apb_transfer26 resp26);
  begin
    vif26.pready26 <= 1'b1;
    if (resp26.direction26 == APB_READ26)
      vif26.prdata26 <= resp26.data;
    @(posedge vif26.pclock26);
    vif26.prdata26 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer26

`endif // APB_SLAVE_DRIVER_SV26
