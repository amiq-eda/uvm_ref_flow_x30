/*******************************************************************************
  FILE : apb_slave_driver5.sv
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV5
`define APB_SLAVE_DRIVER_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_slave_driver5 declaration5
//------------------------------------------------------------------------------

class apb_slave_driver5 extends uvm_driver #(apb_transfer5);

  // The virtual interface used to drive5 and view5 HDL signals5.
  virtual apb_if5 vif5;

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils(apb_slave_driver5)

  // Constructor5
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional5 class methods5
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive5();
  extern virtual task reset_signals5();
  extern virtual task respond_to_transfer5(apb_transfer5 resp5);

endclass : apb_slave_driver5

// UVM connect_phase - gets5 the vif5 as a config property
function void apb_slave_driver5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if5)::get(this, "", "vif5", vif5))
      `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

// Externed5 virtual declaration5 of the run_phase method.  This5 method
// fork/join_none's the get_and_drive5() and reset_signals5() methods5.
task apb_slave_driver5::run_phase(uvm_phase phase);
  fork
    get_and_drive5();
    reset_signals5();
  join
endtask : run_phase

// Function5 that manages5 the interaction5 between the slave5
// sequence sequencer and this slave5 driver.
task apb_slave_driver5::get_and_drive5();
  @(posedge vif5.preset5);
  `uvm_info(get_type_name(), "Reset5 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer5(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive5

// Process5 task that assigns5 signals5 to reset state when reset signal5 set
task apb_slave_driver5::reset_signals5();
  forever begin
    @(negedge vif5.preset5);
    `uvm_info(get_type_name(), "Reset5 observed5",  UVM_MEDIUM)
    vif5.prdata5 <= 32'hzzzz_zzzz;
    vif5.pready5 <= 0;
    vif5.pslverr5 <= 0;
  end
endtask : reset_signals5

  // This5 task drives5 the response phases of a transfer5.
task apb_slave_driver5::respond_to_transfer5(apb_transfer5 resp5);
  begin
    vif5.pready5 <= 1'b1;
    if (resp5.direction5 == APB_READ5)
      vif5.prdata5 <= resp5.data;
    @(posedge vif5.pclock5);
    vif5.prdata5 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer5

`endif // APB_SLAVE_DRIVER_SV5
