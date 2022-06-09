/*******************************************************************************
  FILE : apb_slave_driver8.sv
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV8
`define APB_SLAVE_DRIVER_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_slave_driver8 declaration8
//------------------------------------------------------------------------------

class apb_slave_driver8 extends uvm_driver #(apb_transfer8);

  // The virtual interface used to drive8 and view8 HDL signals8.
  virtual apb_if8 vif8;

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils(apb_slave_driver8)

  // Constructor8
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional8 class methods8
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive8();
  extern virtual task reset_signals8();
  extern virtual task respond_to_transfer8(apb_transfer8 resp8);

endclass : apb_slave_driver8

// UVM connect_phase - gets8 the vif8 as a config property
function void apb_slave_driver8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if8)::get(this, "", "vif8", vif8))
      `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

// Externed8 virtual declaration8 of the run_phase method.  This8 method
// fork/join_none's the get_and_drive8() and reset_signals8() methods8.
task apb_slave_driver8::run_phase(uvm_phase phase);
  fork
    get_and_drive8();
    reset_signals8();
  join
endtask : run_phase

// Function8 that manages8 the interaction8 between the slave8
// sequence sequencer and this slave8 driver.
task apb_slave_driver8::get_and_drive8();
  @(posedge vif8.preset8);
  `uvm_info(get_type_name(), "Reset8 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer8(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive8

// Process8 task that assigns8 signals8 to reset state when reset signal8 set
task apb_slave_driver8::reset_signals8();
  forever begin
    @(negedge vif8.preset8);
    `uvm_info(get_type_name(), "Reset8 observed8",  UVM_MEDIUM)
    vif8.prdata8 <= 32'hzzzz_zzzz;
    vif8.pready8 <= 0;
    vif8.pslverr8 <= 0;
  end
endtask : reset_signals8

  // This8 task drives8 the response phases of a transfer8.
task apb_slave_driver8::respond_to_transfer8(apb_transfer8 resp8);
  begin
    vif8.pready8 <= 1'b1;
    if (resp8.direction8 == APB_READ8)
      vif8.prdata8 <= resp8.data;
    @(posedge vif8.pclock8);
    vif8.prdata8 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer8

`endif // APB_SLAVE_DRIVER_SV8
