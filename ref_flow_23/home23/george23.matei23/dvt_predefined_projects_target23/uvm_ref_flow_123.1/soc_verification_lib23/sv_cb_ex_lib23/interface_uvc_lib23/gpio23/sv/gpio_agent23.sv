/*-------------------------------------------------------------------------
File23 name   : gpio_agent23.sv
Title23       : GPIO23 SystemVerilog23 UVM OVC23
Project23     : UVM SystemVerilog23 Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV23
`define GPIO_AGENT_SV23

class gpio_agent23 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id23;

  gpio_driver23 driver;
  gpio_sequencer23 sequencer;
  gpio_monitor23 monitor23;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent23)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id23, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor23 = gpio_monitor23::type_id::create("monitor23", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer23::type_id::create("sequencer", this);
      driver = gpio_driver23::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr23 of the agent23's cheldren23
  function void assign_csr23(gpio_csr_s23 csr_s23);
    monitor23.csr_s23 = csr_s23;
  endfunction : assign_csr23

endclass : gpio_agent23

`endif // GPIO_AGENT_SV23

