/*******************************************************************************
  FILE : apb_slave_agent12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV12
`define APB_SLAVE_AGENT_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_slave_agent12
//------------------------------------------------------------------------------

class apb_slave_agent12 extends uvm_agent;

  // Virtual interface for this set components12. The virtual interface can
  // be set from the agent12, or set via config to each component.
  virtual apb_if12 vif12;

  // This12 field determines12 whether12 an agent12 is active or passive12.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave12 Configuration12 Information12:  name, is_active, psel_index12,
  //                                   start_address12, end_address12
  apb_slave_config12 cfg;

  apb_slave_driver12    driver;
  apb_slave_sequencer12 sequencer;
  apb_monitor12   monitor12;
  apb_collector12 collector12;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent12)
    `uvm_field_object(monitor12, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector12, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config12(input apb_slave_config12 cfg);
endclass : apb_slave_agent12

// UVM build_phase
function void apb_slave_agent12::build_phase(uvm_phase phase);
  uvm_object config_obj12;
  super.build_phase(phase);
  // Get12 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config12)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG12",
         "Config12 not set for slave12 agent12 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create12 the sequencer and driver only if ACTIVE12
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer12::type_id::create("sequencer",this);
    driver = apb_slave_driver12::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config12() 
function void apb_slave_agent12::update_config12(input apb_slave_config12 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config12

// UVM connect_phase
function void apb_slave_agent12::connect_phase(uvm_phase phase);
  // Get12 the agents12 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if12)::get(this, "", "vif12", vif12))
    `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
  // If12 the vif12 was set to the agent12, apply12 it to its children
  uvm_config_db#(virtual apb_if12)::set(this, "*", "vif12", vif12);

  if (is_active == UVM_ACTIVE) begin
    // Connect12 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV12
