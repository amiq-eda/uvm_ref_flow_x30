/*******************************************************************************
  FILE : apb_slave_agent20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV20
`define APB_SLAVE_AGENT_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_slave_agent20
//------------------------------------------------------------------------------

class apb_slave_agent20 extends uvm_agent;

  // Virtual interface for this set components20. The virtual interface can
  // be set from the agent20, or set via config to each component.
  virtual apb_if20 vif20;

  // This20 field determines20 whether20 an agent20 is active or passive20.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave20 Configuration20 Information20:  name, is_active, psel_index20,
  //                                   start_address20, end_address20
  apb_slave_config20 cfg;

  apb_slave_driver20    driver;
  apb_slave_sequencer20 sequencer;
  apb_monitor20   monitor20;
  apb_collector20 collector20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent20)
    `uvm_field_object(monitor20, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector20, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config20(input apb_slave_config20 cfg);
endclass : apb_slave_agent20

// UVM build_phase
function void apb_slave_agent20::build_phase(uvm_phase phase);
  uvm_object config_obj20;
  super.build_phase(phase);
  // Get20 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config20)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG20",
         "Config20 not set for slave20 agent20 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create20 the sequencer and driver only if ACTIVE20
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer20::type_id::create("sequencer",this);
    driver = apb_slave_driver20::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config20() 
function void apb_slave_agent20::update_config20(input apb_slave_config20 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config20

// UVM connect_phase
function void apb_slave_agent20::connect_phase(uvm_phase phase);
  // Get20 the agents20 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if20)::get(this, "", "vif20", vif20))
    `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
  // If20 the vif20 was set to the agent20, apply20 it to its children
  uvm_config_db#(virtual apb_if20)::set(this, "*", "vif20", vif20);

  if (is_active == UVM_ACTIVE) begin
    // Connect20 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV20
