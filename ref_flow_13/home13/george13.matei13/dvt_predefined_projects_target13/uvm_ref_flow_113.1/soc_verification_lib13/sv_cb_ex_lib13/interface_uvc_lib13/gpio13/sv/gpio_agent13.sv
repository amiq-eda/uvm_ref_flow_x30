/*-------------------------------------------------------------------------
File13 name   : gpio_agent13.sv
Title13       : GPIO13 SystemVerilog13 UVM OVC13
Project13     : UVM SystemVerilog13 Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV13
`define GPIO_AGENT_SV13

class gpio_agent13 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id13;

  gpio_driver13 driver;
  gpio_sequencer13 sequencer;
  gpio_monitor13 monitor13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent13)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id13, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor13 = gpio_monitor13::type_id::create("monitor13", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer13::type_id::create("sequencer", this);
      driver = gpio_driver13::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr13 of the agent13's cheldren13
  function void assign_csr13(gpio_csr_s13 csr_s13);
    monitor13.csr_s13 = csr_s13;
  endfunction : assign_csr13

endclass : gpio_agent13

`endif // GPIO_AGENT_SV13

