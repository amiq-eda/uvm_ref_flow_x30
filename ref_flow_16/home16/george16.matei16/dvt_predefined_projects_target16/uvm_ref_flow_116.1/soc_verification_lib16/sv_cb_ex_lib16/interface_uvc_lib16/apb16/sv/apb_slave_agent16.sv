/*******************************************************************************
  FILE : apb_slave_agent16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV16
`define APB_SLAVE_AGENT_SV16

//------------------------------------------------------------------------------
// CLASS16: apb_slave_agent16
//------------------------------------------------------------------------------

class apb_slave_agent16 extends uvm_agent;

  // Virtual interface for this set components16. The virtual interface can
  // be set from the agent16, or set via config to each component.
  virtual apb_if16 vif16;

  // This16 field determines16 whether16 an agent16 is active or passive16.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave16 Configuration16 Information16:  name, is_active, psel_index16,
  //                                   start_address16, end_address16
  apb_slave_config16 cfg;

  apb_slave_driver16    driver;
  apb_slave_sequencer16 sequencer;
  apb_monitor16   monitor16;
  apb_collector16 collector16;

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent16)
    `uvm_field_object(monitor16, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector16, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config16(input apb_slave_config16 cfg);
endclass : apb_slave_agent16

// UVM build_phase
function void apb_slave_agent16::build_phase(uvm_phase phase);
  uvm_object config_obj16;
  super.build_phase(phase);
  // Get16 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config16)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG16",
         "Config16 not set for slave16 agent16 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create16 the sequencer and driver only if ACTIVE16
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer16::type_id::create("sequencer",this);
    driver = apb_slave_driver16::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config16() 
function void apb_slave_agent16::update_config16(input apb_slave_config16 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config16

// UVM connect_phase
function void apb_slave_agent16::connect_phase(uvm_phase phase);
  // Get16 the agents16 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if16)::get(this, "", "vif16", vif16))
    `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
  // If16 the vif16 was set to the agent16, apply16 it to its children
  uvm_config_db#(virtual apb_if16)::set(this, "*", "vif16", vif16);

  if (is_active == UVM_ACTIVE) begin
    // Connect16 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV16
