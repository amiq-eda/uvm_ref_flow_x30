/*-------------------------------------------------------------------------
File24 name   : gpio_agent24.sv
Title24       : GPIO24 SystemVerilog24 UVM OVC24
Project24     : UVM SystemVerilog24 Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV24
`define GPIO_AGENT_SV24

class gpio_agent24 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id24;

  gpio_driver24 driver;
  gpio_sequencer24 sequencer;
  gpio_monitor24 monitor24;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent24)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id24, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor24 = gpio_monitor24::type_id::create("monitor24", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer24::type_id::create("sequencer", this);
      driver = gpio_driver24::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr24 of the agent24's cheldren24
  function void assign_csr24(gpio_csr_s24 csr_s24);
    monitor24.csr_s24 = csr_s24;
  endfunction : assign_csr24

endclass : gpio_agent24

`endif // GPIO_AGENT_SV24

