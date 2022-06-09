/*******************************************************************************
  FILE : apb_slave_agent4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV4
`define APB_SLAVE_AGENT_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_slave_agent4
//------------------------------------------------------------------------------

class apb_slave_agent4 extends uvm_agent;

  // Virtual interface for this set components4. The virtual interface can
  // be set from the agent4, or set via config to each component.
  virtual apb_if4 vif4;

  // This4 field determines4 whether4 an agent4 is active or passive4.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave4 Configuration4 Information4:  name, is_active, psel_index4,
  //                                   start_address4, end_address4
  apb_slave_config4 cfg;

  apb_slave_driver4    driver;
  apb_slave_sequencer4 sequencer;
  apb_monitor4   monitor4;
  apb_collector4 collector4;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent4)
    `uvm_field_object(monitor4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config4(input apb_slave_config4 cfg);
endclass : apb_slave_agent4

// UVM build_phase
function void apb_slave_agent4::build_phase(uvm_phase phase);
  uvm_object config_obj4;
  super.build_phase(phase);
  // Get4 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config4)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG4",
         "Config4 not set for slave4 agent4 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create4 the sequencer and driver only if ACTIVE4
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer4::type_id::create("sequencer",this);
    driver = apb_slave_driver4::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config4() 
function void apb_slave_agent4::update_config4(input apb_slave_config4 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config4

// UVM connect_phase
function void apb_slave_agent4::connect_phase(uvm_phase phase);
  // Get4 the agents4 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if4)::get(this, "", "vif4", vif4))
    `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
  // If4 the vif4 was set to the agent4, apply4 it to its children
  uvm_config_db#(virtual apb_if4)::set(this, "*", "vif4", vif4);

  if (is_active == UVM_ACTIVE) begin
    // Connect4 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV4
