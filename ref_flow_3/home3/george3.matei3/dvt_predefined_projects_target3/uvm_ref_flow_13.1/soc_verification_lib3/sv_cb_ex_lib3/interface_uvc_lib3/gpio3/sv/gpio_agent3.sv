/*-------------------------------------------------------------------------
File3 name   : gpio_agent3.sv
Title3       : GPIO3 SystemVerilog3 UVM OVC3
Project3     : UVM SystemVerilog3 Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV3
`define GPIO_AGENT_SV3

class gpio_agent3 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id3;

  gpio_driver3 driver;
  gpio_sequencer3 sequencer;
  gpio_monitor3 monitor3;

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent3)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id3, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor3 = gpio_monitor3::type_id::create("monitor3", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer3::type_id::create("sequencer", this);
      driver = gpio_driver3::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr3 of the agent3's cheldren3
  function void assign_csr3(gpio_csr_s3 csr_s3);
    monitor3.csr_s3 = csr_s3;
  endfunction : assign_csr3

endclass : gpio_agent3

`endif // GPIO_AGENT_SV3

