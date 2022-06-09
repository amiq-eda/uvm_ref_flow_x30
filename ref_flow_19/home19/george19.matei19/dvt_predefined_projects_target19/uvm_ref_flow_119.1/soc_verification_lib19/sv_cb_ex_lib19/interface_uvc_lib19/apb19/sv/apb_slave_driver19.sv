/*******************************************************************************
  FILE : apb_slave_driver19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV19
`define APB_SLAVE_DRIVER_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_slave_driver19 declaration19
//------------------------------------------------------------------------------

class apb_slave_driver19 extends uvm_driver #(apb_transfer19);

  // The virtual interface used to drive19 and view19 HDL signals19.
  virtual apb_if19 vif19;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils(apb_slave_driver19)

  // Constructor19
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional19 class methods19
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive19();
  extern virtual task reset_signals19();
  extern virtual task respond_to_transfer19(apb_transfer19 resp19);

endclass : apb_slave_driver19

// UVM connect_phase - gets19 the vif19 as a config property
function void apb_slave_driver19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if19)::get(this, "", "vif19", vif19))
      `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

// Externed19 virtual declaration19 of the run_phase method.  This19 method
// fork/join_none's the get_and_drive19() and reset_signals19() methods19.
task apb_slave_driver19::run_phase(uvm_phase phase);
  fork
    get_and_drive19();
    reset_signals19();
  join
endtask : run_phase

// Function19 that manages19 the interaction19 between the slave19
// sequence sequencer and this slave19 driver.
task apb_slave_driver19::get_and_drive19();
  @(posedge vif19.preset19);
  `uvm_info(get_type_name(), "Reset19 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer19(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive19

// Process19 task that assigns19 signals19 to reset state when reset signal19 set
task apb_slave_driver19::reset_signals19();
  forever begin
    @(negedge vif19.preset19);
    `uvm_info(get_type_name(), "Reset19 observed19",  UVM_MEDIUM)
    vif19.prdata19 <= 32'hzzzz_zzzz;
    vif19.pready19 <= 0;
    vif19.pslverr19 <= 0;
  end
endtask : reset_signals19

  // This19 task drives19 the response phases of a transfer19.
task apb_slave_driver19::respond_to_transfer19(apb_transfer19 resp19);
  begin
    vif19.pready19 <= 1'b1;
    if (resp19.direction19 == APB_READ19)
      vif19.prdata19 <= resp19.data;
    @(posedge vif19.pclock19);
    vif19.prdata19 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer19

`endif // APB_SLAVE_DRIVER_SV19
