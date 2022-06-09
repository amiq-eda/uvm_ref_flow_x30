/*******************************************************************************
  FILE : apb_slave_agent26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV26
`define APB_SLAVE_AGENT_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_slave_agent26
//------------------------------------------------------------------------------

class apb_slave_agent26 extends uvm_agent;

  // Virtual interface for this set components26. The virtual interface can
  // be set from the agent26, or set via config to each component.
  virtual apb_if26 vif26;

  // This26 field determines26 whether26 an agent26 is active or passive26.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave26 Configuration26 Information26:  name, is_active, psel_index26,
  //                                   start_address26, end_address26
  apb_slave_config26 cfg;

  apb_slave_driver26    driver;
  apb_slave_sequencer26 sequencer;
  apb_monitor26   monitor26;
  apb_collector26 collector26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent26)
    `uvm_field_object(monitor26, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector26, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config26(input apb_slave_config26 cfg);
endclass : apb_slave_agent26

// UVM build_phase
function void apb_slave_agent26::build_phase(uvm_phase phase);
  uvm_object config_obj26;
  super.build_phase(phase);
  // Get26 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config26)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG26",
         "Config26 not set for slave26 agent26 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create26 the sequencer and driver only if ACTIVE26
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer26::type_id::create("sequencer",this);
    driver = apb_slave_driver26::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config26() 
function void apb_slave_agent26::update_config26(input apb_slave_config26 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config26

// UVM connect_phase
function void apb_slave_agent26::connect_phase(uvm_phase phase);
  // Get26 the agents26 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if26)::get(this, "", "vif26", vif26))
    `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
  // If26 the vif26 was set to the agent26, apply26 it to its children
  uvm_config_db#(virtual apb_if26)::set(this, "*", "vif26", vif26);

  if (is_active == UVM_ACTIVE) begin
    // Connect26 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV26
