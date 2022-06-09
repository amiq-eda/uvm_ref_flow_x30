/*******************************************************************************
  FILE : apb_slave_driver17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV17
`define APB_SLAVE_DRIVER_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_slave_driver17 declaration17
//------------------------------------------------------------------------------

class apb_slave_driver17 extends uvm_driver #(apb_transfer17);

  // The virtual interface used to drive17 and view17 HDL signals17.
  virtual apb_if17 vif17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils(apb_slave_driver17)

  // Constructor17
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive17();
  extern virtual task reset_signals17();
  extern virtual task respond_to_transfer17(apb_transfer17 resp17);

endclass : apb_slave_driver17

// UVM connect_phase - gets17 the vif17 as a config property
function void apb_slave_driver17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if17)::get(this, "", "vif17", vif17))
      `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

// Externed17 virtual declaration17 of the run_phase method.  This17 method
// fork/join_none's the get_and_drive17() and reset_signals17() methods17.
task apb_slave_driver17::run_phase(uvm_phase phase);
  fork
    get_and_drive17();
    reset_signals17();
  join
endtask : run_phase

// Function17 that manages17 the interaction17 between the slave17
// sequence sequencer and this slave17 driver.
task apb_slave_driver17::get_and_drive17();
  @(posedge vif17.preset17);
  `uvm_info(get_type_name(), "Reset17 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer17(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive17

// Process17 task that assigns17 signals17 to reset state when reset signal17 set
task apb_slave_driver17::reset_signals17();
  forever begin
    @(negedge vif17.preset17);
    `uvm_info(get_type_name(), "Reset17 observed17",  UVM_MEDIUM)
    vif17.prdata17 <= 32'hzzzz_zzzz;
    vif17.pready17 <= 0;
    vif17.pslverr17 <= 0;
  end
endtask : reset_signals17

  // This17 task drives17 the response phases of a transfer17.
task apb_slave_driver17::respond_to_transfer17(apb_transfer17 resp17);
  begin
    vif17.pready17 <= 1'b1;
    if (resp17.direction17 == APB_READ17)
      vif17.prdata17 <= resp17.data;
    @(posedge vif17.pclock17);
    vif17.prdata17 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer17

`endif // APB_SLAVE_DRIVER_SV17
