/*******************************************************************************
  FILE : apb_slave_agent29.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_AGENT_SV29
`define APB_SLAVE_AGENT_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_slave_agent29
//------------------------------------------------------------------------------

class apb_slave_agent29 extends uvm_agent;

  // Virtual interface for this set components29. The virtual interface can
  // be set from the agent29, or set via config to each component.
  virtual apb_if29 vif29;

  // This29 field determines29 whether29 an agent29 is active or passive29.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave29 Configuration29 Information29:  name, is_active, psel_index29,
  //                                   start_address29, end_address29
  apb_slave_config29 cfg;

  apb_slave_driver29    driver;
  apb_slave_sequencer29 sequencer;
  apb_monitor29   monitor29;
  apb_collector29 collector29;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent29)
    `uvm_field_object(monitor29, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector29, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config29(input apb_slave_config29 cfg);
endclass : apb_slave_agent29

// UVM build_phase
function void apb_slave_agent29::build_phase(uvm_phase phase);
  uvm_object config_obj29;
  super.build_phase(phase);
  // Get29 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config29)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG29",
         "Config29 not set for slave29 agent29 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create29 the sequencer and driver only if ACTIVE29
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer29::type_id::create("sequencer",this);
    driver = apb_slave_driver29::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config29() 
function void apb_slave_agent29::update_config29(input apb_slave_config29 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config29

// UVM connect_phase
function void apb_slave_agent29::connect_phase(uvm_phase phase);
  // Get29 the agents29 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if29)::get(this, "", "vif29", vif29))
    `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
  // If29 the vif29 was set to the agent29, apply29 it to its children
  uvm_config_db#(virtual apb_if29)::set(this, "*", "vif29", vif29);

  if (is_active == UVM_ACTIVE) begin
    // Connect29 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV29
