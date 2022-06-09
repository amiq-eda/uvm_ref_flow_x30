/*-------------------------------------------------------------------------
File11 name   : gpio_agent11.sv
Title11       : GPIO11 SystemVerilog11 UVM OVC11
Project11     : UVM SystemVerilog11 Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV11
`define GPIO_AGENT_SV11

class gpio_agent11 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id11;

  gpio_driver11 driver;
  gpio_sequencer11 sequencer;
  gpio_monitor11 monitor11;

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent11)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id11, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor11 = gpio_monitor11::type_id::create("monitor11", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer11::type_id::create("sequencer", this);
      driver = gpio_driver11::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr11 of the agent11's cheldren11
  function void assign_csr11(gpio_csr_s11 csr_s11);
    monitor11.csr_s11 = csr_s11;
  endfunction : assign_csr11

endclass : gpio_agent11

`endif // GPIO_AGENT_SV11

