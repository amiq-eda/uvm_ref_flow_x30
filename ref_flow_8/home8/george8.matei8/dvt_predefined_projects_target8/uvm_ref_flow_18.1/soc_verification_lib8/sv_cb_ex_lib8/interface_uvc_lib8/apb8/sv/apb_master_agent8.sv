/******************************************************************************
  FILE : apb_master_agent8.sv
 ******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV8
`define APB_MASTER_AGENT_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_master_agent8
//------------------------------------------------------------------------------

class apb_master_agent8 extends uvm_agent;

  // This8 field determines8 whether8 an agent8 is active or passive8.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration8 information: (master_config8: name, is_active)
  apb_config8 cfg;

  apb_monitor8   monitor8;
  apb_collector8 collector8;
  apb_master_sequencer8 sequencer;
  apb_master_driver8    driver;

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent8)
    `uvm_field_object(monitor8, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector8, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config8(input apb_config8 cfg);

endclass : apb_master_agent8

// UVM build_phase
function void apb_master_agent8::build_phase(uvm_phase phase);
  uvm_object config_obj8;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config8)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG8", 
          "Config8 not set for master8 agent8, using default is_active field")
    end
  else is_active = cfg.master_config8.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer8::type_id::create("sequencer",this);
    driver = apb_master_driver8::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect8 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config8() 
function void apb_master_agent8::update_config8(input apb_config8 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config8

`endif // APB_MASTER_AGENT_SV8
