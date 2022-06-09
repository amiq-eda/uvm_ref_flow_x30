/*******************************************************************************
  FILE : apb_slave_agent25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV25
`define APB_SLAVE_AGENT_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_slave_agent25
//------------------------------------------------------------------------------

class apb_slave_agent25 extends uvm_agent;

  // Virtual interface for this set components25. The virtual interface can
  // be set from the agent25, or set via config to each component.
  virtual apb_if25 vif25;

  // This25 field determines25 whether25 an agent25 is active or passive25.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave25 Configuration25 Information25:  name, is_active, psel_index25,
  //                                   start_address25, end_address25
  apb_slave_config25 cfg;

  apb_slave_driver25    driver;
  apb_slave_sequencer25 sequencer;
  apb_monitor25   monitor25;
  apb_collector25 collector25;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent25)
    `uvm_field_object(monitor25, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector25, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config25(input apb_slave_config25 cfg);
endclass : apb_slave_agent25

// UVM build_phase
function void apb_slave_agent25::build_phase(uvm_phase phase);
  uvm_object config_obj25;
  super.build_phase(phase);
  // Get25 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config25)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG25",
         "Config25 not set for slave25 agent25 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create25 the sequencer and driver only if ACTIVE25
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer25::type_id::create("sequencer",this);
    driver = apb_slave_driver25::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config25() 
function void apb_slave_agent25::update_config25(input apb_slave_config25 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config25

// UVM connect_phase
function void apb_slave_agent25::connect_phase(uvm_phase phase);
  // Get25 the agents25 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if25)::get(this, "", "vif25", vif25))
    `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
  // If25 the vif25 was set to the agent25, apply25 it to its children
  uvm_config_db#(virtual apb_if25)::set(this, "*", "vif25", vif25);

  if (is_active == UVM_ACTIVE) begin
    // Connect25 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV25
