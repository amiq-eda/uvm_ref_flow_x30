/*******************************************************************************
  FILE : apb_slave_driver18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV18
`define APB_SLAVE_DRIVER_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_slave_driver18 declaration18
//------------------------------------------------------------------------------

class apb_slave_driver18 extends uvm_driver #(apb_transfer18);

  // The virtual interface used to drive18 and view18 HDL signals18.
  virtual apb_if18 vif18;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils(apb_slave_driver18)

  // Constructor18
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive18();
  extern virtual task reset_signals18();
  extern virtual task respond_to_transfer18(apb_transfer18 resp18);

endclass : apb_slave_driver18

// UVM connect_phase - gets18 the vif18 as a config property
function void apb_slave_driver18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if18)::get(this, "", "vif18", vif18))
      `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

// Externed18 virtual declaration18 of the run_phase method.  This18 method
// fork/join_none's the get_and_drive18() and reset_signals18() methods18.
task apb_slave_driver18::run_phase(uvm_phase phase);
  fork
    get_and_drive18();
    reset_signals18();
  join
endtask : run_phase

// Function18 that manages18 the interaction18 between the slave18
// sequence sequencer and this slave18 driver.
task apb_slave_driver18::get_and_drive18();
  @(posedge vif18.preset18);
  `uvm_info(get_type_name(), "Reset18 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer18(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive18

// Process18 task that assigns18 signals18 to reset state when reset signal18 set
task apb_slave_driver18::reset_signals18();
  forever begin
    @(negedge vif18.preset18);
    `uvm_info(get_type_name(), "Reset18 observed18",  UVM_MEDIUM)
    vif18.prdata18 <= 32'hzzzz_zzzz;
    vif18.pready18 <= 0;
    vif18.pslverr18 <= 0;
  end
endtask : reset_signals18

  // This18 task drives18 the response phases of a transfer18.
task apb_slave_driver18::respond_to_transfer18(apb_transfer18 resp18);
  begin
    vif18.pready18 <= 1'b1;
    if (resp18.direction18 == APB_READ18)
      vif18.prdata18 <= resp18.data;
    @(posedge vif18.pclock18);
    vif18.prdata18 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer18

`endif // APB_SLAVE_DRIVER_SV18
