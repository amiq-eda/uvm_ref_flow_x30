/*******************************************************************************
  FILE : apb_slave_agent9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV9
`define APB_SLAVE_AGENT_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_slave_agent9
//------------------------------------------------------------------------------

class apb_slave_agent9 extends uvm_agent;

  // Virtual interface for this set components9. The virtual interface can
  // be set from the agent9, or set via config to each component.
  virtual apb_if9 vif9;

  // This9 field determines9 whether9 an agent9 is active or passive9.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave9 Configuration9 Information9:  name, is_active, psel_index9,
  //                                   start_address9, end_address9
  apb_slave_config9 cfg;

  apb_slave_driver9    driver;
  apb_slave_sequencer9 sequencer;
  apb_monitor9   monitor9;
  apb_collector9 collector9;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent9)
    `uvm_field_object(monitor9, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector9, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config9(input apb_slave_config9 cfg);
endclass : apb_slave_agent9

// UVM build_phase
function void apb_slave_agent9::build_phase(uvm_phase phase);
  uvm_object config_obj9;
  super.build_phase(phase);
  // Get9 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config9)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG9",
         "Config9 not set for slave9 agent9 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create9 the sequencer and driver only if ACTIVE9
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer9::type_id::create("sequencer",this);
    driver = apb_slave_driver9::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config9() 
function void apb_slave_agent9::update_config9(input apb_slave_config9 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config9

// UVM connect_phase
function void apb_slave_agent9::connect_phase(uvm_phase phase);
  // Get9 the agents9 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if9)::get(this, "", "vif9", vif9))
    `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
  // If9 the vif9 was set to the agent9, apply9 it to its children
  uvm_config_db#(virtual apb_if9)::set(this, "*", "vif9", vif9);

  if (is_active == UVM_ACTIVE) begin
    // Connect9 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV9
