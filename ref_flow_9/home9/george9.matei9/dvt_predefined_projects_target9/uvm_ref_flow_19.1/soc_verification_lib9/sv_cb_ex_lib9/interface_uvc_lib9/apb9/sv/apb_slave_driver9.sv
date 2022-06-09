/*******************************************************************************
  FILE : apb_slave_driver9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV9
`define APB_SLAVE_DRIVER_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_slave_driver9 declaration9
//------------------------------------------------------------------------------

class apb_slave_driver9 extends uvm_driver #(apb_transfer9);

  // The virtual interface used to drive9 and view9 HDL signals9.
  virtual apb_if9 vif9;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils(apb_slave_driver9)

  // Constructor9
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive9();
  extern virtual task reset_signals9();
  extern virtual task respond_to_transfer9(apb_transfer9 resp9);

endclass : apb_slave_driver9

// UVM connect_phase - gets9 the vif9 as a config property
function void apb_slave_driver9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if9)::get(this, "", "vif9", vif9))
      `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

// Externed9 virtual declaration9 of the run_phase method.  This9 method
// fork/join_none's the get_and_drive9() and reset_signals9() methods9.
task apb_slave_driver9::run_phase(uvm_phase phase);
  fork
    get_and_drive9();
    reset_signals9();
  join
endtask : run_phase

// Function9 that manages9 the interaction9 between the slave9
// sequence sequencer and this slave9 driver.
task apb_slave_driver9::get_and_drive9();
  @(posedge vif9.preset9);
  `uvm_info(get_type_name(), "Reset9 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer9(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive9

// Process9 task that assigns9 signals9 to reset state when reset signal9 set
task apb_slave_driver9::reset_signals9();
  forever begin
    @(negedge vif9.preset9);
    `uvm_info(get_type_name(), "Reset9 observed9",  UVM_MEDIUM)
    vif9.prdata9 <= 32'hzzzz_zzzz;
    vif9.pready9 <= 0;
    vif9.pslverr9 <= 0;
  end
endtask : reset_signals9

  // This9 task drives9 the response phases of a transfer9.
task apb_slave_driver9::respond_to_transfer9(apb_transfer9 resp9);
  begin
    vif9.pready9 <= 1'b1;
    if (resp9.direction9 == APB_READ9)
      vif9.prdata9 <= resp9.data;
    @(posedge vif9.pclock9);
    vif9.prdata9 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer9

`endif // APB_SLAVE_DRIVER_SV9
