/*******************************************************************************
  FILE : apb_slave_agent18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV18
`define APB_SLAVE_AGENT_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_slave_agent18
//------------------------------------------------------------------------------

class apb_slave_agent18 extends uvm_agent;

  // Virtual interface for this set components18. The virtual interface can
  // be set from the agent18, or set via config to each component.
  virtual apb_if18 vif18;

  // This18 field determines18 whether18 an agent18 is active or passive18.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave18 Configuration18 Information18:  name, is_active, psel_index18,
  //                                   start_address18, end_address18
  apb_slave_config18 cfg;

  apb_slave_driver18    driver;
  apb_slave_sequencer18 sequencer;
  apb_monitor18   monitor18;
  apb_collector18 collector18;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent18)
    `uvm_field_object(monitor18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config18(input apb_slave_config18 cfg);
endclass : apb_slave_agent18

// UVM build_phase
function void apb_slave_agent18::build_phase(uvm_phase phase);
  uvm_object config_obj18;
  super.build_phase(phase);
  // Get18 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config18)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG18",
         "Config18 not set for slave18 agent18 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create18 the sequencer and driver only if ACTIVE18
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer18::type_id::create("sequencer",this);
    driver = apb_slave_driver18::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config18() 
function void apb_slave_agent18::update_config18(input apb_slave_config18 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config18

// UVM connect_phase
function void apb_slave_agent18::connect_phase(uvm_phase phase);
  // Get18 the agents18 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if18)::get(this, "", "vif18", vif18))
    `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
  // If18 the vif18 was set to the agent18, apply18 it to its children
  uvm_config_db#(virtual apb_if18)::set(this, "*", "vif18", vif18);

  if (is_active == UVM_ACTIVE) begin
    // Connect18 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV18
