/*******************************************************************************
  FILE : apb_slave_driver23.sv
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV23
`define APB_SLAVE_DRIVER_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_slave_driver23 declaration23
//------------------------------------------------------------------------------

class apb_slave_driver23 extends uvm_driver #(apb_transfer23);

  // The virtual interface used to drive23 and view23 HDL signals23.
  virtual apb_if23 vif23;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils(apb_slave_driver23)

  // Constructor23
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional23 class methods23
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive23();
  extern virtual task reset_signals23();
  extern virtual task respond_to_transfer23(apb_transfer23 resp23);

endclass : apb_slave_driver23

// UVM connect_phase - gets23 the vif23 as a config property
function void apb_slave_driver23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if23)::get(this, "", "vif23", vif23))
      `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

// Externed23 virtual declaration23 of the run_phase method.  This23 method
// fork/join_none's the get_and_drive23() and reset_signals23() methods23.
task apb_slave_driver23::run_phase(uvm_phase phase);
  fork
    get_and_drive23();
    reset_signals23();
  join
endtask : run_phase

// Function23 that manages23 the interaction23 between the slave23
// sequence sequencer and this slave23 driver.
task apb_slave_driver23::get_and_drive23();
  @(posedge vif23.preset23);
  `uvm_info(get_type_name(), "Reset23 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer23(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive23

// Process23 task that assigns23 signals23 to reset state when reset signal23 set
task apb_slave_driver23::reset_signals23();
  forever begin
    @(negedge vif23.preset23);
    `uvm_info(get_type_name(), "Reset23 observed23",  UVM_MEDIUM)
    vif23.prdata23 <= 32'hzzzz_zzzz;
    vif23.pready23 <= 0;
    vif23.pslverr23 <= 0;
  end
endtask : reset_signals23

  // This23 task drives23 the response phases of a transfer23.
task apb_slave_driver23::respond_to_transfer23(apb_transfer23 resp23);
  begin
    vif23.pready23 <= 1'b1;
    if (resp23.direction23 == APB_READ23)
      vif23.prdata23 <= resp23.data;
    @(posedge vif23.pclock23);
    vif23.prdata23 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer23

`endif // APB_SLAVE_DRIVER_SV23
