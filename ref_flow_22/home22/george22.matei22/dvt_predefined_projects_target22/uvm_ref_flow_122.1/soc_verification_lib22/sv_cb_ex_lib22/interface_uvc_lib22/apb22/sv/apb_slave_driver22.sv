/*******************************************************************************
  FILE : apb_slave_driver22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV22
`define APB_SLAVE_DRIVER_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_slave_driver22 declaration22
//------------------------------------------------------------------------------

class apb_slave_driver22 extends uvm_driver #(apb_transfer22);

  // The virtual interface used to drive22 and view22 HDL signals22.
  virtual apb_if22 vif22;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils(apb_slave_driver22)

  // Constructor22
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional22 class methods22
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive22();
  extern virtual task reset_signals22();
  extern virtual task respond_to_transfer22(apb_transfer22 resp22);

endclass : apb_slave_driver22

// UVM connect_phase - gets22 the vif22 as a config property
function void apb_slave_driver22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if22)::get(this, "", "vif22", vif22))
      `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

// Externed22 virtual declaration22 of the run_phase method.  This22 method
// fork/join_none's the get_and_drive22() and reset_signals22() methods22.
task apb_slave_driver22::run_phase(uvm_phase phase);
  fork
    get_and_drive22();
    reset_signals22();
  join
endtask : run_phase

// Function22 that manages22 the interaction22 between the slave22
// sequence sequencer and this slave22 driver.
task apb_slave_driver22::get_and_drive22();
  @(posedge vif22.preset22);
  `uvm_info(get_type_name(), "Reset22 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer22(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive22

// Process22 task that assigns22 signals22 to reset state when reset signal22 set
task apb_slave_driver22::reset_signals22();
  forever begin
    @(negedge vif22.preset22);
    `uvm_info(get_type_name(), "Reset22 observed22",  UVM_MEDIUM)
    vif22.prdata22 <= 32'hzzzz_zzzz;
    vif22.pready22 <= 0;
    vif22.pslverr22 <= 0;
  end
endtask : reset_signals22

  // This22 task drives22 the response phases of a transfer22.
task apb_slave_driver22::respond_to_transfer22(apb_transfer22 resp22);
  begin
    vif22.pready22 <= 1'b1;
    if (resp22.direction22 == APB_READ22)
      vif22.prdata22 <= resp22.data;
    @(posedge vif22.pclock22);
    vif22.prdata22 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer22

`endif // APB_SLAVE_DRIVER_SV22
