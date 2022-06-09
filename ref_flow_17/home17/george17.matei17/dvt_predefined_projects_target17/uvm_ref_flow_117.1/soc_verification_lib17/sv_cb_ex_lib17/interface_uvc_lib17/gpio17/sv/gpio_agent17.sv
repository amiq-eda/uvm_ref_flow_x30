/*-------------------------------------------------------------------------
File17 name   : gpio_agent17.sv
Title17       : GPIO17 SystemVerilog17 UVM OVC17
Project17     : UVM SystemVerilog17 Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV17
`define GPIO_AGENT_SV17

class gpio_agent17 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id17;

  gpio_driver17 driver;
  gpio_sequencer17 sequencer;
  gpio_monitor17 monitor17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent17)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id17, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor17 = gpio_monitor17::type_id::create("monitor17", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer17::type_id::create("sequencer", this);
      driver = gpio_driver17::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr17 of the agent17's cheldren17
  function void assign_csr17(gpio_csr_s17 csr_s17);
    monitor17.csr_s17 = csr_s17;
  endfunction : assign_csr17

endclass : gpio_agent17

`endif // GPIO_AGENT_SV17

