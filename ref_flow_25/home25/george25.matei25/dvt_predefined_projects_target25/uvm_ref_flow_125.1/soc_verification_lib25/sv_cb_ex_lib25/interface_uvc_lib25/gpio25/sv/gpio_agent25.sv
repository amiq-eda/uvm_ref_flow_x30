/*-------------------------------------------------------------------------
File25 name   : gpio_agent25.sv
Title25       : GPIO25 SystemVerilog25 UVM OVC25
Project25     : UVM SystemVerilog25 Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV25
`define GPIO_AGENT_SV25

class gpio_agent25 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id25;

  gpio_driver25 driver;
  gpio_sequencer25 sequencer;
  gpio_monitor25 monitor25;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent25)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id25, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor25 = gpio_monitor25::type_id::create("monitor25", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer25::type_id::create("sequencer", this);
      driver = gpio_driver25::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr25 of the agent25's cheldren25
  function void assign_csr25(gpio_csr_s25 csr_s25);
    monitor25.csr_s25 = csr_s25;
  endfunction : assign_csr25

endclass : gpio_agent25

`endif // GPIO_AGENT_SV25

