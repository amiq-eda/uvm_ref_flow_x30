/*-------------------------------------------------------------------------
File15 name   : gpio_agent15.sv
Title15       : GPIO15 SystemVerilog15 UVM OVC15
Project15     : UVM SystemVerilog15 Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV15
`define GPIO_AGENT_SV15

class gpio_agent15 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id15;

  gpio_driver15 driver;
  gpio_sequencer15 sequencer;
  gpio_monitor15 monitor15;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent15)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id15, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor15 = gpio_monitor15::type_id::create("monitor15", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer15::type_id::create("sequencer", this);
      driver = gpio_driver15::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr15 of the agent15's cheldren15
  function void assign_csr15(gpio_csr_s15 csr_s15);
    monitor15.csr_s15 = csr_s15;
  endfunction : assign_csr15

endclass : gpio_agent15

`endif // GPIO_AGENT_SV15

