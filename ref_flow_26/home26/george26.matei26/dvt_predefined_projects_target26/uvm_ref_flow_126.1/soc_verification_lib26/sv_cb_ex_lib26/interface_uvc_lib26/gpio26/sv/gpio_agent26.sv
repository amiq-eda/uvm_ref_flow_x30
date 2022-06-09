/*-------------------------------------------------------------------------
File26 name   : gpio_agent26.sv
Title26       : GPIO26 SystemVerilog26 UVM OVC26
Project26     : UVM SystemVerilog26 Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV26
`define GPIO_AGENT_SV26

class gpio_agent26 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id26;

  gpio_driver26 driver;
  gpio_sequencer26 sequencer;
  gpio_monitor26 monitor26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent26)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id26, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor26 = gpio_monitor26::type_id::create("monitor26", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer26::type_id::create("sequencer", this);
      driver = gpio_driver26::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr26 of the agent26's cheldren26
  function void assign_csr26(gpio_csr_s26 csr_s26);
    monitor26.csr_s26 = csr_s26;
  endfunction : assign_csr26

endclass : gpio_agent26

`endif // GPIO_AGENT_SV26

