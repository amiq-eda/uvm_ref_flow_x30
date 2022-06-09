/******************************************************************************
  FILE : apb_master_agent11.sv
 ******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV11
`define APB_MASTER_AGENT_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_master_agent11
//------------------------------------------------------------------------------

class apb_master_agent11 extends uvm_agent;

  // This11 field determines11 whether11 an agent11 is active or passive11.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration11 information: (master_config11: name, is_active)
  apb_config11 cfg;

  apb_monitor11   monitor11;
  apb_collector11 collector11;
  apb_master_sequencer11 sequencer;
  apb_master_driver11    driver;

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent11)
    `uvm_field_object(monitor11, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector11, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config11(input apb_config11 cfg);

endclass : apb_master_agent11

// UVM build_phase
function void apb_master_agent11::build_phase(uvm_phase phase);
  uvm_object config_obj11;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config11)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG11", 
          "Config11 not set for master11 agent11, using default is_active field")
    end
  else is_active = cfg.master_config11.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer11::type_id::create("sequencer",this);
    driver = apb_master_driver11::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect11 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config11() 
function void apb_master_agent11::update_config11(input apb_config11 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config11

`endif // APB_MASTER_AGENT_SV11
