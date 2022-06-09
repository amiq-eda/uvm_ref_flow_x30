/*******************************************************************************
  FILE : apb_slave_driver21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV21
`define APB_SLAVE_DRIVER_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_slave_driver21 declaration21
//------------------------------------------------------------------------------

class apb_slave_driver21 extends uvm_driver #(apb_transfer21);

  // The virtual interface used to drive21 and view21 HDL signals21.
  virtual apb_if21 vif21;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils(apb_slave_driver21)

  // Constructor21
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive21();
  extern virtual task reset_signals21();
  extern virtual task respond_to_transfer21(apb_transfer21 resp21);

endclass : apb_slave_driver21

// UVM connect_phase - gets21 the vif21 as a config property
function void apb_slave_driver21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if21)::get(this, "", "vif21", vif21))
      `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

// Externed21 virtual declaration21 of the run_phase method.  This21 method
// fork/join_none's the get_and_drive21() and reset_signals21() methods21.
task apb_slave_driver21::run_phase(uvm_phase phase);
  fork
    get_and_drive21();
    reset_signals21();
  join
endtask : run_phase

// Function21 that manages21 the interaction21 between the slave21
// sequence sequencer and this slave21 driver.
task apb_slave_driver21::get_and_drive21();
  @(posedge vif21.preset21);
  `uvm_info(get_type_name(), "Reset21 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer21(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive21

// Process21 task that assigns21 signals21 to reset state when reset signal21 set
task apb_slave_driver21::reset_signals21();
  forever begin
    @(negedge vif21.preset21);
    `uvm_info(get_type_name(), "Reset21 observed21",  UVM_MEDIUM)
    vif21.prdata21 <= 32'hzzzz_zzzz;
    vif21.pready21 <= 0;
    vif21.pslverr21 <= 0;
  end
endtask : reset_signals21

  // This21 task drives21 the response phases of a transfer21.
task apb_slave_driver21::respond_to_transfer21(apb_transfer21 resp21);
  begin
    vif21.pready21 <= 1'b1;
    if (resp21.direction21 == APB_READ21)
      vif21.prdata21 <= resp21.data;
    @(posedge vif21.pclock21);
    vif21.prdata21 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer21

`endif // APB_SLAVE_DRIVER_SV21
