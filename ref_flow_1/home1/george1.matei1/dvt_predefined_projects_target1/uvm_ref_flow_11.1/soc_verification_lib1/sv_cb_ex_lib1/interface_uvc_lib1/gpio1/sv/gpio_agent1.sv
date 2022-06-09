/*-------------------------------------------------------------------------
File1 name   : gpio_agent1.sv
Title1       : GPIO1 SystemVerilog1 UVM OVC1
Project1     : UVM SystemVerilog1 Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV1
`define GPIO_AGENT_SV1

class gpio_agent1 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id1;

  gpio_driver1 driver;
  gpio_sequencer1 sequencer;
  gpio_monitor1 monitor1;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent1)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id1, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor1 = gpio_monitor1::type_id::create("monitor1", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer1::type_id::create("sequencer", this);
      driver = gpio_driver1::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr1 of the agent1's cheldren1
  function void assign_csr1(gpio_csr_s1 csr_s1);
    monitor1.csr_s1 = csr_s1;
  endfunction : assign_csr1

endclass : gpio_agent1

`endif // GPIO_AGENT_SV1

