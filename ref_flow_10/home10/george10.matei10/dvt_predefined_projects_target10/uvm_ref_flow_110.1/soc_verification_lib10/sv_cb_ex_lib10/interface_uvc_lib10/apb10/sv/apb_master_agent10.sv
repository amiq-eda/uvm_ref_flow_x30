/******************************************************************************
  FILE : apb_master_agent10.sv
 ******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV10
`define APB_MASTER_AGENT_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_master_agent10
//------------------------------------------------------------------------------

class apb_master_agent10 extends uvm_agent;

  // This10 field determines10 whether10 an agent10 is active or passive10.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration10 information: (master_config10: name, is_active)
  apb_config10 cfg;

  apb_monitor10   monitor10;
  apb_collector10 collector10;
  apb_master_sequencer10 sequencer;
  apb_master_driver10    driver;

  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent10)
    `uvm_field_object(monitor10, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector10, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config10(input apb_config10 cfg);

endclass : apb_master_agent10

// UVM build_phase
function void apb_master_agent10::build_phase(uvm_phase phase);
  uvm_object config_obj10;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config10)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG10", 
          "Config10 not set for master10 agent10, using default is_active field")
    end
  else is_active = cfg.master_config10.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer10::type_id::create("sequencer",this);
    driver = apb_master_driver10::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect10 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config10() 
function void apb_master_agent10::update_config10(input apb_config10 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config10

`endif // APB_MASTER_AGENT_SV10
