/*******************************************************************************
  FILE : apb_slave_agent24.sv
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV24
`define APB_SLAVE_AGENT_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_slave_agent24
//------------------------------------------------------------------------------

class apb_slave_agent24 extends uvm_agent;

  // Virtual interface for this set components24. The virtual interface can
  // be set from the agent24, or set via config to each component.
  virtual apb_if24 vif24;

  // This24 field determines24 whether24 an agent24 is active or passive24.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave24 Configuration24 Information24:  name, is_active, psel_index24,
  //                                   start_address24, end_address24
  apb_slave_config24 cfg;

  apb_slave_driver24    driver;
  apb_slave_sequencer24 sequencer;
  apb_monitor24   monitor24;
  apb_collector24 collector24;

  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent24)
    `uvm_field_object(monitor24, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector24, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config24(input apb_slave_config24 cfg);
endclass : apb_slave_agent24

// UVM build_phase
function void apb_slave_agent24::build_phase(uvm_phase phase);
  uvm_object config_obj24;
  super.build_phase(phase);
  // Get24 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config24)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG24",
         "Config24 not set for slave24 agent24 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create24 the sequencer and driver only if ACTIVE24
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer24::type_id::create("sequencer",this);
    driver = apb_slave_driver24::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config24() 
function void apb_slave_agent24::update_config24(input apb_slave_config24 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config24

// UVM connect_phase
function void apb_slave_agent24::connect_phase(uvm_phase phase);
  // Get24 the agents24 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if24)::get(this, "", "vif24", vif24))
    `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
  // If24 the vif24 was set to the agent24, apply24 it to its children
  uvm_config_db#(virtual apb_if24)::set(this, "*", "vif24", vif24);

  if (is_active == UVM_ACTIVE) begin
    // Connect24 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV24
