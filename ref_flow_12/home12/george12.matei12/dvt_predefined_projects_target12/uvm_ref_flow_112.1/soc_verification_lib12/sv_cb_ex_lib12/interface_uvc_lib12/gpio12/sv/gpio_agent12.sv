/*-------------------------------------------------------------------------
File12 name   : gpio_agent12.sv
Title12       : GPIO12 SystemVerilog12 UVM OVC12
Project12     : UVM SystemVerilog12 Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV12
`define GPIO_AGENT_SV12

class gpio_agent12 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id12;

  gpio_driver12 driver;
  gpio_sequencer12 sequencer;
  gpio_monitor12 monitor12;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent12)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id12, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor12 = gpio_monitor12::type_id::create("monitor12", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer12::type_id::create("sequencer", this);
      driver = gpio_driver12::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr12 of the agent12's cheldren12
  function void assign_csr12(gpio_csr_s12 csr_s12);
    monitor12.csr_s12 = csr_s12;
  endfunction : assign_csr12

endclass : gpio_agent12

`endif // GPIO_AGENT_SV12

