/******************************************************************************
  FILE : apb_master_agent23.sv
 ******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV23
`define APB_MASTER_AGENT_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_master_agent23
//------------------------------------------------------------------------------

class apb_master_agent23 extends uvm_agent;

  // This23 field determines23 whether23 an agent23 is active or passive23.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration23 information: (master_config23: name, is_active)
  apb_config23 cfg;

  apb_monitor23   monitor23;
  apb_collector23 collector23;
  apb_master_sequencer23 sequencer;
  apb_master_driver23    driver;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent23)
    `uvm_field_object(monitor23, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector23, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config23(input apb_config23 cfg);

endclass : apb_master_agent23

// UVM build_phase
function void apb_master_agent23::build_phase(uvm_phase phase);
  uvm_object config_obj23;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config23)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG23", 
          "Config23 not set for master23 agent23, using default is_active field")
    end
  else is_active = cfg.master_config23.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer23::type_id::create("sequencer",this);
    driver = apb_master_driver23::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect23 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config23() 
function void apb_master_agent23::update_config23(input apb_config23 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config23

`endif // APB_MASTER_AGENT_SV23
