/******************************************************************************
  FILE : apb_master_agent3.sv
 ******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV3
`define APB_MASTER_AGENT_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_master_agent3
//------------------------------------------------------------------------------

class apb_master_agent3 extends uvm_agent;

  // This3 field determines3 whether3 an agent3 is active or passive3.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration3 information: (master_config3: name, is_active)
  apb_config3 cfg;

  apb_monitor3   monitor3;
  apb_collector3 collector3;
  apb_master_sequencer3 sequencer;
  apb_master_driver3    driver;

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent3)
    `uvm_field_object(monitor3, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector3, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config3(input apb_config3 cfg);

endclass : apb_master_agent3

// UVM build_phase
function void apb_master_agent3::build_phase(uvm_phase phase);
  uvm_object config_obj3;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config3)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG3", 
          "Config3 not set for master3 agent3, using default is_active field")
    end
  else is_active = cfg.master_config3.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer3::type_id::create("sequencer",this);
    driver = apb_master_driver3::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect3 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config3() 
function void apb_master_agent3::update_config3(input apb_config3 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config3

`endif // APB_MASTER_AGENT_SV3
