/*-------------------------------------------------------------------------
File29 name   : gpio_agent29.sv
Title29       : GPIO29 SystemVerilog29 UVM OVC29
Project29     : UVM SystemVerilog29 Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_AGENT_SV29
`define GPIO_AGENT_SV29

class gpio_agent29 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id29;

  gpio_driver29 driver;
  gpio_sequencer29 sequencer;
  gpio_monitor29 monitor29;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(gpio_agent29)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id29, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor29 = gpio_monitor29::type_id::create("monitor29", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = gpio_sequencer29::type_id::create("sequencer", this);
      driver = gpio_driver29::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr29 of the agent29's cheldren29
  function void assign_csr29(gpio_csr_s29 csr_s29);
    monitor29.csr_s29 = csr_s29;
  endfunction : assign_csr29

endclass : gpio_agent29

`endif // GPIO_AGENT_SV29

