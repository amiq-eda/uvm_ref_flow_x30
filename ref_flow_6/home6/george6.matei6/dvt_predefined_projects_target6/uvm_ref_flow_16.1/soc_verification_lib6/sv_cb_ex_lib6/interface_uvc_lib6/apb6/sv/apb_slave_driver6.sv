/*******************************************************************************
  FILE : apb_slave_driver6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV6
`define APB_SLAVE_DRIVER_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_slave_driver6 declaration6
//------------------------------------------------------------------------------

class apb_slave_driver6 extends uvm_driver #(apb_transfer6);

  // The virtual interface used to drive6 and view6 HDL signals6.
  virtual apb_if6 vif6;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils(apb_slave_driver6)

  // Constructor6
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive6();
  extern virtual task reset_signals6();
  extern virtual task respond_to_transfer6(apb_transfer6 resp6);

endclass : apb_slave_driver6

// UVM connect_phase - gets6 the vif6 as a config property
function void apb_slave_driver6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if6)::get(this, "", "vif6", vif6))
      `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

// Externed6 virtual declaration6 of the run_phase method.  This6 method
// fork/join_none's the get_and_drive6() and reset_signals6() methods6.
task apb_slave_driver6::run_phase(uvm_phase phase);
  fork
    get_and_drive6();
    reset_signals6();
  join
endtask : run_phase

// Function6 that manages6 the interaction6 between the slave6
// sequence sequencer and this slave6 driver.
task apb_slave_driver6::get_and_drive6();
  @(posedge vif6.preset6);
  `uvm_info(get_type_name(), "Reset6 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer6(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive6

// Process6 task that assigns6 signals6 to reset state when reset signal6 set
task apb_slave_driver6::reset_signals6();
  forever begin
    @(negedge vif6.preset6);
    `uvm_info(get_type_name(), "Reset6 observed6",  UVM_MEDIUM)
    vif6.prdata6 <= 32'hzzzz_zzzz;
    vif6.pready6 <= 0;
    vif6.pslverr6 <= 0;
  end
endtask : reset_signals6

  // This6 task drives6 the response phases of a transfer6.
task apb_slave_driver6::respond_to_transfer6(apb_transfer6 resp6);
  begin
    vif6.pready6 <= 1'b1;
    if (resp6.direction6 == APB_READ6)
      vif6.prdata6 <= resp6.data;
    @(posedge vif6.pclock6);
    vif6.prdata6 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer6

`endif // APB_SLAVE_DRIVER_SV6
