/******************************************************************************
  FILE : apb_master_agent27.sv
 ******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV27
`define APB_MASTER_AGENT_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_master_agent27
//------------------------------------------------------------------------------

class apb_master_agent27 extends uvm_agent;

  // This27 field determines27 whether27 an agent27 is active or passive27.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration27 information: (master_config27: name, is_active)
  apb_config27 cfg;

  apb_monitor27   monitor27;
  apb_collector27 collector27;
  apb_master_sequencer27 sequencer;
  apb_master_driver27    driver;

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent27)
    `uvm_field_object(monitor27, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector27, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config27(input apb_config27 cfg);

endclass : apb_master_agent27

// UVM build_phase
function void apb_master_agent27::build_phase(uvm_phase phase);
  uvm_object config_obj27;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config27)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG27", 
          "Config27 not set for master27 agent27, using default is_active field")
    end
  else is_active = cfg.master_config27.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer27::type_id::create("sequencer",this);
    driver = apb_master_driver27::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect27 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config27() 
function void apb_master_agent27::update_config27(input apb_config27 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config27

`endif // APB_MASTER_AGENT_SV27
