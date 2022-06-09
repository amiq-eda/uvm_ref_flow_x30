/*-------------------------------------------------------------------------
File20 name   : gpio_agent20.sv
Title20       : GPIO20 SystemVerilog20 UVM OVC20
Project20     : UVM SystemVerilog20 Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV20
`define GPIO_AGENT_SV20

class gpio_agent20 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id20;

  gpio_driver20 driver;
  gpio_sequencer20 sequencer;
  gpio_monitor20 monitor20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent20)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id20, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor20 = gpio_monitor20::type_id::create("monitor20", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer20::type_id::create("sequencer", this);
      driver = gpio_driver20::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr20 of the agent20's cheldren20
  function void assign_csr20(gpio_csr_s20 csr_s20);
    monitor20.csr_s20 = csr_s20;
  endfunction : assign_csr20

endclass : gpio_agent20

`endif // GPIO_AGENT_SV20

