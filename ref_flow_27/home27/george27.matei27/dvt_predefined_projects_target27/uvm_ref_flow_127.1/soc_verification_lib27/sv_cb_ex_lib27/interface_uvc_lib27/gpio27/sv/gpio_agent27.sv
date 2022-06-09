/*-------------------------------------------------------------------------
File27 name   : gpio_agent27.sv
Title27       : GPIO27 SystemVerilog27 UVM OVC27
Project27     : UVM SystemVerilog27 Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV27
`define GPIO_AGENT_SV27

class gpio_agent27 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id27;

  gpio_driver27 driver;
  gpio_sequencer27 sequencer;
  gpio_monitor27 monitor27;

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent27)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id27, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor27 = gpio_monitor27::type_id::create("monitor27", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer27::type_id::create("sequencer", this);
      driver = gpio_driver27::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr27 of the agent27's cheldren27
  function void assign_csr27(gpio_csr_s27 csr_s27);
    monitor27.csr_s27 = csr_s27;
  endfunction : assign_csr27

endclass : gpio_agent27

`endif // GPIO_AGENT_SV27

