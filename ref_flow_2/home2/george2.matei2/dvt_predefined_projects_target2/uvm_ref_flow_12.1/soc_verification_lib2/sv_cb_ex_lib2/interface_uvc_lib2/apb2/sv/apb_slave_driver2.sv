/*******************************************************************************
  FILE : apb_slave_driver2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV2
`define APB_SLAVE_DRIVER_SV2

//------------------------------------------------------------------------------
// CLASS2: apb_slave_driver2 declaration2
//------------------------------------------------------------------------------

class apb_slave_driver2 extends uvm_driver #(apb_transfer2);

  // The virtual interface used to drive2 and view2 HDL signals2.
  virtual apb_if2 vif2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils(apb_slave_driver2)

  // Constructor2
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive2();
  extern virtual task reset_signals2();
  extern virtual task respond_to_transfer2(apb_transfer2 resp2);

endclass : apb_slave_driver2

// UVM connect_phase - gets2 the vif2 as a config property
function void apb_slave_driver2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if2)::get(this, "", "vif2", vif2))
      `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

// Externed2 virtual declaration2 of the run_phase method.  This2 method
// fork/join_none's the get_and_drive2() and reset_signals2() methods2.
task apb_slave_driver2::run_phase(uvm_phase phase);
  fork
    get_and_drive2();
    reset_signals2();
  join
endtask : run_phase

// Function2 that manages2 the interaction2 between the slave2
// sequence sequencer and this slave2 driver.
task apb_slave_driver2::get_and_drive2();
  @(posedge vif2.preset2);
  `uvm_info(get_type_name(), "Reset2 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer2(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive2

// Process2 task that assigns2 signals2 to reset state when reset signal2 set
task apb_slave_driver2::reset_signals2();
  forever begin
    @(negedge vif2.preset2);
    `uvm_info(get_type_name(), "Reset2 observed2",  UVM_MEDIUM)
    vif2.prdata2 <= 32'hzzzz_zzzz;
    vif2.pready2 <= 0;
    vif2.pslverr2 <= 0;
  end
endtask : reset_signals2

  // This2 task drives2 the response phases of a transfer2.
task apb_slave_driver2::respond_to_transfer2(apb_transfer2 resp2);
  begin
    vif2.pready2 <= 1'b1;
    if (resp2.direction2 == APB_READ2)
      vif2.prdata2 <= resp2.data;
    @(posedge vif2.pclock2);
    vif2.prdata2 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer2

`endif // APB_SLAVE_DRIVER_SV2
