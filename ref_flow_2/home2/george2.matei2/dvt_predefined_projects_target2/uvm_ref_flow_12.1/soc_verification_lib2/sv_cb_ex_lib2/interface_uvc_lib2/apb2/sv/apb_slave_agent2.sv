/*******************************************************************************
  FILE : apb_slave_agent2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_AGENT_SV2
`define APB_SLAVE_AGENT_SV2

//------------------------------------------------------------------------------
// CLASS2: apb_slave_agent2
//------------------------------------------------------------------------------

class apb_slave_agent2 extends uvm_agent;

  // Virtual interface for this set components2. The virtual interface can
  // be set from the agent2, or set via config to each component.
  virtual apb_if2 vif2;

  // This2 field determines2 whether2 an agent2 is active or passive2.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Slave2 Configuration2 Information2:  name, is_active, psel_index2,
  //                                   start_address2, end_address2
  apb_slave_config2 cfg;

  apb_slave_driver2    driver;
  apb_slave_sequencer2 sequencer;
  apb_monitor2   monitor2;
  apb_collector2 collector2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(apb_slave_agent2)
    `uvm_field_object(monitor2, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector2, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config2(input apb_slave_config2 cfg);
endclass : apb_slave_agent2

// UVM build_phase
function void apb_slave_agent2::build_phase(uvm_phase phase);
  uvm_object config_obj2;
  super.build_phase(phase);
  // Get2 the configuration information for this component
  if (cfg == null) begin
    if (!uvm_config_db#(apb_slave_config2)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG2",
         "Config2 not set for slave2 agent2 using default is_active")
    end
  else is_active = cfg.is_active;
  // Create2 the sequencer and driver only if ACTIVE2
  if (is_active == UVM_ACTIVE) begin
    sequencer = apb_slave_sequencer2::type_id::create("sequencer",this);
    driver = apb_slave_driver2::type_id::create("driver",this);
  end
endfunction : build_phase

// update_config2() 
function void apb_slave_agent2::update_config2(input apb_slave_config2 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
  end
endfunction : update_config2

// UVM connect_phase
function void apb_slave_agent2::connect_phase(uvm_phase phase);
  // Get2 the agents2 virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if2)::get(this, "", "vif2", vif2))
    `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
  // If2 the vif2 was set to the agent2, apply2 it to its children
  uvm_config_db#(virtual apb_if2)::set(this, "*", "vif2", vif2);

  if (is_active == UVM_ACTIVE) begin
    // Connect2 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

`endif // APB_SLAVE_AGENT_SV2
