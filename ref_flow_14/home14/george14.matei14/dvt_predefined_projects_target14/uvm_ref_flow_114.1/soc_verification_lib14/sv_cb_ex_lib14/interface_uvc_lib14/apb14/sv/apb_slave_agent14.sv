/*******************************************************************************
  FILE : apb_slave_agent14.sv
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV14
`define APB_SLAVE_AGENT_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_slave_agent14
//------------------------------------------------------------------------------

class apb_slave_agent14 extends uvm_agent;

  // Virtual interface for this set components14. The virtual interface can
  // be set from the agent14, or set via config to each component.
  virtual apb_if14 vif14;

  // This14 field determines14 whether14 an agent14 is active or passive14.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave14 Configuration14 Information14:  name, is_active, psel_index14,
  //                                   start_address14, end_address14
  apb_slave_config14 cfg;

  apb_slave_driver14    driver;
  apb_slave_sequencer14 sequencer;
  apb_monitor14   monitor14;
  apb_collector14 collector14;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent14)
    `uvm_field_object(monitor14, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector14, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config14(input apb_slave_config14 cfg);
endclass : apb_slave_agent14

// UVM build_phase
function void apb_slave_agent14::build_phase(uvm_phase phase);
  uvm_object config_obj14;
  super.build_phase(phase);
  // Get14 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config14)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG14",
         "Config14 not set for slave14 agent14 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create14 the sequencer and driver only if ACTIVE14
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer14::type_id::create("sequencer",this);
    driver = apb_slave_driver14::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config14() 
function void apb_slave_agent14::update_config14(input apb_slave_config14 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config14

// UVM connect_phase
function void apb_slave_agent14::connect_phase(uvm_phase phase);
  // Get14 the agents14 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if14)::get(this, "", "vif14", vif14))
    `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
  // If14 the vif14 was set to the agent14, apply14 it to its children
  uvm_config_db#(virtual apb_if14)::set(this, "*", "vif14", vif14);

  if (is_active == UVM_ACTIVE) begin
    // Connect14 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV14
