/*******************************************************************************
  FILE : apb_slave_agent21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV21
`define APB_SLAVE_AGENT_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_slave_agent21
//------------------------------------------------------------------------------

class apb_slave_agent21 extends uvm_agent;

  // Virtual interface for this set components21. The virtual interface can
  // be set from the agent21, or set via config to each component.
  virtual apb_if21 vif21;

  // This21 field determines21 whether21 an agent21 is active or passive21.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave21 Configuration21 Information21:  name, is_active, psel_index21,
  //                                   start_address21, end_address21
  apb_slave_config21 cfg;

  apb_slave_driver21    driver;
  apb_slave_sequencer21 sequencer;
  apb_monitor21   monitor21;
  apb_collector21 collector21;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent21)
    `uvm_field_object(monitor21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config21(input apb_slave_config21 cfg);
endclass : apb_slave_agent21

// UVM build_phase
function void apb_slave_agent21::build_phase(uvm_phase phase);
  uvm_object config_obj21;
  super.build_phase(phase);
  // Get21 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config21)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG21",
         "Config21 not set for slave21 agent21 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create21 the sequencer and driver only if ACTIVE21
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer21::type_id::create("sequencer",this);
    driver = apb_slave_driver21::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config21() 
function void apb_slave_agent21::update_config21(input apb_slave_config21 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config21

// UVM connect_phase
function void apb_slave_agent21::connect_phase(uvm_phase phase);
  // Get21 the agents21 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if21)::get(this, "", "vif21", vif21))
    `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
  // If21 the vif21 was set to the agent21, apply21 it to its children
  uvm_config_db#(virtual apb_if21)::set(this, "*", "vif21", vif21);

  if (is_active == UVM_ACTIVE) begin
    // Connect21 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV21
