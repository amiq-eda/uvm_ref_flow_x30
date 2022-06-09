/*******************************************************************************
  FILE : apb_slave_agent7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV7
`define APB_SLAVE_AGENT_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_slave_agent7
//------------------------------------------------------------------------------

class apb_slave_agent7 extends uvm_agent;

  // Virtual interface for this set components7. The virtual interface can
  // be set from the agent7, or set via config to each component.
  virtual apb_if7 vif7;

  // This7 field determines7 whether7 an agent7 is active or passive7.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave7 Configuration7 Information7:  name, is_active, psel_index7,
  //                                   start_address7, end_address7
  apb_slave_config7 cfg;

  apb_slave_driver7    driver;
  apb_slave_sequencer7 sequencer;
  apb_monitor7   monitor7;
  apb_collector7 collector7;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent7)
    `uvm_field_object(monitor7, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector7, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config7(input apb_slave_config7 cfg);
endclass : apb_slave_agent7

// UVM build_phase
function void apb_slave_agent7::build_phase(uvm_phase phase);
  uvm_object config_obj7;
  super.build_phase(phase);
  // Get7 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config7)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG7",
         "Config7 not set for slave7 agent7 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create7 the sequencer and driver only if ACTIVE7
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer7::type_id::create("sequencer",this);
    driver = apb_slave_driver7::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config7() 
function void apb_slave_agent7::update_config7(input apb_slave_config7 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config7

// UVM connect_phase
function void apb_slave_agent7::connect_phase(uvm_phase phase);
  // Get7 the agents7 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if7)::get(this, "", "vif7", vif7))
    `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
  // If7 the vif7 was set to the agent7, apply7 it to its children
  uvm_config_db#(virtual apb_if7)::set(this, "*", "vif7", vif7);

  if (is_active == UVM_ACTIVE) begin
    // Connect7 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV7
