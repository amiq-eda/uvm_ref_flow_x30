/*-------------------------------------------------------------------------
File18 name   : gpio_agent18.sv
Title18       : GPIO18 SystemVerilog18 UVM OVC18
Project18     : UVM SystemVerilog18 Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV18
`define GPIO_AGENT_SV18

class gpio_agent18 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id18;

  gpio_driver18 driver;
  gpio_sequencer18 sequencer;
  gpio_monitor18 monitor18;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent18)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id18, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor18 = gpio_monitor18::type_id::create("monitor18", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer18::type_id::create("sequencer", this);
      driver = gpio_driver18::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr18 of the agent18's cheldren18
  function void assign_csr18(gpio_csr_s18 csr_s18);
    monitor18.csr_s18 = csr_s18;
  endfunction : assign_csr18

endclass : gpio_agent18

`endif // GPIO_AGENT_SV18

