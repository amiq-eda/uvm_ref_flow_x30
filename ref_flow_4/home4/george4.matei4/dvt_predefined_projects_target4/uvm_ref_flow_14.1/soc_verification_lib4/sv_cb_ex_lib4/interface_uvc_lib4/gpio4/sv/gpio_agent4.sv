/*-------------------------------------------------------------------------
File4 name   : gpio_agent4.sv
Title4       : GPIO4 SystemVerilog4 UVM OVC4
Project4     : UVM SystemVerilog4 Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV4
`define GPIO_AGENT_SV4

class gpio_agent4 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id4;

  gpio_driver4 driver;
  gpio_sequencer4 sequencer;
  gpio_monitor4 monitor4;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent4)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id4, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor4 = gpio_monitor4::type_id::create("monitor4", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer4::type_id::create("sequencer", this);
      driver = gpio_driver4::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr4 of the agent4's cheldren4
  function void assign_csr4(gpio_csr_s4 csr_s4);
    monitor4.csr_s4 = csr_s4;
  endfunction : assign_csr4

endclass : gpio_agent4

`endif // GPIO_AGENT_SV4

