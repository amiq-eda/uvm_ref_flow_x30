/******************************************************************************
  FILE : apb_master_agent19.sv
 ******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV19
`define APB_MASTER_AGENT_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_master_agent19
//------------------------------------------------------------------------------

class apb_master_agent19 extends uvm_agent;

  // This19 field determines19 whether19 an agent19 is active or passive19.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration19 information: (master_config19: name, is_active)
  apb_config19 cfg;

  apb_monitor19   monitor19;
  apb_collector19 collector19;
  apb_master_sequencer19 sequencer;
  apb_master_driver19    driver;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent19)
    `uvm_field_object(monitor19, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector19, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config19(input apb_config19 cfg);

endclass : apb_master_agent19

// UVM build_phase
function void apb_master_agent19::build_phase(uvm_phase phase);
  uvm_object config_obj19;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config19)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG19", 
          "Config19 not set for master19 agent19, using default is_active field")
    end
  else is_active = cfg.master_config19.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer19::type_id::create("sequencer",this);
    driver = apb_master_driver19::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect19 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config19() 
function void apb_master_agent19::update_config19(input apb_config19 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config19

`endif // APB_MASTER_AGENT_SV19
