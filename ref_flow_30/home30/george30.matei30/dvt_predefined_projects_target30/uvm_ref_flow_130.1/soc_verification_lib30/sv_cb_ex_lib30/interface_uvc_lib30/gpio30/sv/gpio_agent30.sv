/*-------------------------------------------------------------------------
File30 name   : gpio_agent30.sv
Title30       : GPIO30 SystemVerilog30 UVM OVC30
Project30     : UVM SystemVerilog30 Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV30
`define GPIO_AGENT_SV30

class gpio_agent30 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id30;

  gpio_driver30 driver;
  gpio_sequencer30 sequencer;
  gpio_monitor30 monitor30;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent30)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id30, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor30 = gpio_monitor30::type_id::create("monitor30", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer30::type_id::create("sequencer", this);
      driver = gpio_driver30::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr30 of the agent30's cheldren30
  function void assign_csr30(gpio_csr_s30 csr_s30);
    monitor30.csr_s30 = csr_s30;
  endfunction : assign_csr30

endclass : gpio_agent30

`endif // GPIO_AGENT_SV30

