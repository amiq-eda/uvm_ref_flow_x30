/*-------------------------------------------------------------------------
File22 name   : gpio_agent22.sv
Title22       : GPIO22 SystemVerilog22 UVM OVC22
Project22     : UVM SystemVerilog22 Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV22
`define GPIO_AGENT_SV22

class gpio_agent22 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id22;

  gpio_driver22 driver;
  gpio_sequencer22 sequencer;
  gpio_monitor22 monitor22;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent22)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id22, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor22 = gpio_monitor22::type_id::create("monitor22", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer22::type_id::create("sequencer", this);
      driver = gpio_driver22::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr22 of the agent22's cheldren22
  function void assign_csr22(gpio_csr_s22 csr_s22);
    monitor22.csr_s22 = csr_s22;
  endfunction : assign_csr22

endclass : gpio_agent22

`endif // GPIO_AGENT_SV22

