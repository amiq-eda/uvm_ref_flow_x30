/*-------------------------------------------------------------------------
File21 name   : gpio_agent21.sv
Title21       : GPIO21 SystemVerilog21 UVM OVC21
Project21     : UVM SystemVerilog21 Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV21
`define GPIO_AGENT_SV21

class gpio_agent21 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id21;

  gpio_driver21 driver;
  gpio_sequencer21 sequencer;
  gpio_monitor21 monitor21;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent21)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id21, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor21 = gpio_monitor21::type_id::create("monitor21", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer21::type_id::create("sequencer", this);
      driver = gpio_driver21::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr21 of the agent21's cheldren21
  function void assign_csr21(gpio_csr_s21 csr_s21);
    monitor21.csr_s21 = csr_s21;
  endfunction : assign_csr21

endclass : gpio_agent21

`endif // GPIO_AGENT_SV21

