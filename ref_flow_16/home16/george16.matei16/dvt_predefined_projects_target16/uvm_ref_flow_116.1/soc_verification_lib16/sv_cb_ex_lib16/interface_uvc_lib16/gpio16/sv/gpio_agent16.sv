/*-------------------------------------------------------------------------
File16 name   : gpio_agent16.sv
Title16       : GPIO16 SystemVerilog16 UVM OVC16
Project16     : UVM SystemVerilog16 Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV16
`define GPIO_AGENT_SV16

class gpio_agent16 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id16;

  gpio_driver16 driver;
  gpio_sequencer16 sequencer;
  gpio_monitor16 monitor16;

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent16)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id16, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor16 = gpio_monitor16::type_id::create("monitor16", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer16::type_id::create("sequencer", this);
      driver = gpio_driver16::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr16 of the agent16's cheldren16
  function void assign_csr16(gpio_csr_s16 csr_s16);
    monitor16.csr_s16 = csr_s16;
  endfunction : assign_csr16

endclass : gpio_agent16

`endif // GPIO_AGENT_SV16

