/*-------------------------------------------------------------------------
File5 name   : gpio_agent5.sv
Title5       : GPIO5 SystemVerilog5 UVM OVC5
Project5     : UVM SystemVerilog5 Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV5
`define GPIO_AGENT_SV5

class gpio_agent5 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id5;

  gpio_driver5 driver;
  gpio_sequencer5 sequencer;
  gpio_monitor5 monitor5;

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent5)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id5, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor5 = gpio_monitor5::type_id::create("monitor5", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer5::type_id::create("sequencer", this);
      driver = gpio_driver5::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr5 of the agent5's cheldren5
  function void assign_csr5(gpio_csr_s5 csr_s5);
    monitor5.csr_s5 = csr_s5;
  endfunction : assign_csr5

endclass : gpio_agent5

`endif // GPIO_AGENT_SV5

