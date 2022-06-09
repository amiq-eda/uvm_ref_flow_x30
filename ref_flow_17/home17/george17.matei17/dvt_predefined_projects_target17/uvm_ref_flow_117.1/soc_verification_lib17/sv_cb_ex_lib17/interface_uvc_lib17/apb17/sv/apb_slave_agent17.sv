/*******************************************************************************
  FILE : apb_slave_agent17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV17
`define APB_SLAVE_AGENT_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_slave_agent17
//------------------------------------------------------------------------------

class apb_slave_agent17 extends uvm_agent;

  // Virtual interface for this set components17. The virtual interface can
  // be set from the agent17, or set via config to each component.
  virtual apb_if17 vif17;

  // This17 field determines17 whether17 an agent17 is active or passive17.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave17 Configuration17 Information17:  name, is_active, psel_index17,
  //                                   start_address17, end_address17
  apb_slave_config17 cfg;

  apb_slave_driver17    driver;
  apb_slave_sequencer17 sequencer;
  apb_monitor17   monitor17;
  apb_collector17 collector17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent17)
    `uvm_field_object(monitor17, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector17, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config17(input apb_slave_config17 cfg);
endclass : apb_slave_agent17

// UVM build_phase
function void apb_slave_agent17::build_phase(uvm_phase phase);
  uvm_object config_obj17;
  super.build_phase(phase);
  // Get17 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config17)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG17",
         "Config17 not set for slave17 agent17 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create17 the sequencer and driver only if ACTIVE17
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer17::type_id::create("sequencer",this);
    driver = apb_slave_driver17::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config17() 
function void apb_slave_agent17::update_config17(input apb_slave_config17 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config17

// UVM connect_phase
function void apb_slave_agent17::connect_phase(uvm_phase phase);
  // Get17 the agents17 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if17)::get(this, "", "vif17", vif17))
    `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
  // If17 the vif17 was set to the agent17, apply17 it to its children
  uvm_config_db#(virtual apb_if17)::set(this, "*", "vif17", vif17);

  if (is_active == UVM_ACTIVE) begin
    // Connect17 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV17
