/*******************************************************************************
  FILE : apb_slave_driver3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV3
`define APB_SLAVE_DRIVER_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_slave_driver3 declaration3
//------------------------------------------------------------------------------

class apb_slave_driver3 extends uvm_driver #(apb_transfer3);

  // The virtual interface used to drive3 and view3 HDL signals3.
  virtual apb_if3 vif3;

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils(apb_slave_driver3)

  // Constructor3
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional3 class methods3
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive3();
  extern virtual task reset_signals3();
  extern virtual task respond_to_transfer3(apb_transfer3 resp3);

endclass : apb_slave_driver3

// UVM connect_phase - gets3 the vif3 as a config property
function void apb_slave_driver3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if3)::get(this, "", "vif3", vif3))
      `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

// Externed3 virtual declaration3 of the run_phase method.  This3 method
// fork/join_none's the get_and_drive3() and reset_signals3() methods3.
task apb_slave_driver3::run_phase(uvm_phase phase);
  fork
    get_and_drive3();
    reset_signals3();
  join
endtask : run_phase

// Function3 that manages3 the interaction3 between the slave3
// sequence sequencer and this slave3 driver.
task apb_slave_driver3::get_and_drive3();
  @(posedge vif3.preset3);
  `uvm_info(get_type_name(), "Reset3 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer3(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive3

// Process3 task that assigns3 signals3 to reset state when reset signal3 set
task apb_slave_driver3::reset_signals3();
  forever begin
    @(negedge vif3.preset3);
    `uvm_info(get_type_name(), "Reset3 observed3",  UVM_MEDIUM)
    vif3.prdata3 <= 32'hzzzz_zzzz;
    vif3.pready3 <= 0;
    vif3.pslverr3 <= 0;
  end
endtask : reset_signals3

  // This3 task drives3 the response phases of a transfer3.
task apb_slave_driver3::respond_to_transfer3(apb_transfer3 resp3);
  begin
    vif3.pready3 <= 1'b1;
    if (resp3.direction3 == APB_READ3)
      vif3.prdata3 <= resp3.data;
    @(posedge vif3.pclock3);
    vif3.prdata3 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer3

`endif // APB_SLAVE_DRIVER_SV3
