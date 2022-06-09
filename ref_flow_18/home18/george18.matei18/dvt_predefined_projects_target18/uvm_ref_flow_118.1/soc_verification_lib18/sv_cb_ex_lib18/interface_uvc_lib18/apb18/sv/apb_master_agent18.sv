/******************************************************************************
  FILE : apb_master_agent18.sv
 ******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV18
`define APB_MASTER_AGENT_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_master_agent18
//------------------------------------------------------------------------------

class apb_master_agent18 extends uvm_agent;

  // This18 field determines18 whether18 an agent18 is active or passive18.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration18 information: (master_config18: name, is_active)
  apb_config18 cfg;

  apb_monitor18   monitor18;
  apb_collector18 collector18;
  apb_master_sequencer18 sequencer;
  apb_master_driver18    driver;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent18)
    `uvm_field_object(monitor18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config18(input apb_config18 cfg);

endclass : apb_master_agent18

// UVM build_phase
function void apb_master_agent18::build_phase(uvm_phase phase);
  uvm_object config_obj18;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config18)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG18", 
          "Config18 not set for master18 agent18, using default is_active field")
    end
  else is_active = cfg.master_config18.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer18::type_id::create("sequencer",this);
    driver = apb_master_driver18::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect18 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config18() 
function void apb_master_agent18::update_config18(input apb_config18 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config18

`endif // APB_MASTER_AGENT_SV18
