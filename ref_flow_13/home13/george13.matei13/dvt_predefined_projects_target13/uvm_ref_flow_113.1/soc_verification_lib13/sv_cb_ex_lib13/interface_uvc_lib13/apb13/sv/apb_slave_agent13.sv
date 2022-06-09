/*******************************************************************************
  FILE : apb_slave_agent13.sv
*******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV13
`define APB_SLAVE_AGENT_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_slave_agent13
//------------------------------------------------------------------------------

class apb_slave_agent13 extends uvm_agent;

  // Virtual interface for this set components13. The virtual interface can
  // be set from the agent13, or set via config to each component.
  virtual apb_if13 vif13;

  // This13 field determines13 whether13 an agent13 is active or passive13.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave13 Configuration13 Information13:  name, is_active, psel_index13,
  //                                   start_address13, end_address13
  apb_slave_config13 cfg;

  apb_slave_driver13    driver;
  apb_slave_sequencer13 sequencer;
  apb_monitor13   monitor13;
  apb_collector13 collector13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent13)
    `uvm_field_object(monitor13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config13(input apb_slave_config13 cfg);
endclass : apb_slave_agent13

// UVM build_phase
function void apb_slave_agent13::build_phase(uvm_phase phase);
  uvm_object config_obj13;
  super.build_phase(phase);
  // Get13 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config13)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG13",
         "Config13 not set for slave13 agent13 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create13 the sequencer and driver only if ACTIVE13
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer13::type_id::create("sequencer",this);
    driver = apb_slave_driver13::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config13() 
function void apb_slave_agent13::update_config13(input apb_slave_config13 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config13

// UVM connect_phase
function void apb_slave_agent13::connect_phase(uvm_phase phase);
  // Get13 the agents13 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if13)::get(this, "", "vif13", vif13))
    `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
  // If13 the vif13 was set to the agent13, apply13 it to its children
  uvm_config_db#(virtual apb_if13)::set(this, "*", "vif13", vif13);

  if (is_active == UVM_ACTIVE) begin
    // Connect13 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV13
