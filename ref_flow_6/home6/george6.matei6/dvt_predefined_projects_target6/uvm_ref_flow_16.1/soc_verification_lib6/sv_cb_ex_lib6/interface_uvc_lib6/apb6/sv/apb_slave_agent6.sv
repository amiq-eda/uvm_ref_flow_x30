/*******************************************************************************
  FILE : apb_slave_agent6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV6
`define APB_SLAVE_AGENT_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_slave_agent6
//------------------------------------------------------------------------------

class apb_slave_agent6 extends uvm_agent;

  // Virtual interface for this set components6. The virtual interface can
  // be set from the agent6, or set via config to each component.
  virtual apb_if6 vif6;

  // This6 field determines6 whether6 an agent6 is active or passive6.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave6 Configuration6 Information6:  name, is_active, psel_index6,
  //                                   start_address6, end_address6
  apb_slave_config6 cfg;

  apb_slave_driver6    driver;
  apb_slave_sequencer6 sequencer;
  apb_monitor6   monitor6;
  apb_collector6 collector6;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent6)
    `uvm_field_object(monitor6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config6(input apb_slave_config6 cfg);
endclass : apb_slave_agent6

// UVM build_phase
function void apb_slave_agent6::build_phase(uvm_phase phase);
  uvm_object config_obj6;
  super.build_phase(phase);
  // Get6 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config6)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG6",
         "Config6 not set for slave6 agent6 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create6 the sequencer and driver only if ACTIVE6
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer6::type_id::create("sequencer",this);
    driver = apb_slave_driver6::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config6() 
function void apb_slave_agent6::update_config6(input apb_slave_config6 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config6

// UVM connect_phase
function void apb_slave_agent6::connect_phase(uvm_phase phase);
  // Get6 the agents6 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if6)::get(this, "", "vif6", vif6))
    `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
  // If6 the vif6 was set to the agent6, apply6 it to its children
  uvm_config_db#(virtual apb_if6)::set(this, "*", "vif6", vif6);

  if (is_active == UVM_ACTIVE) begin
    // Connect6 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV6
