/******************************************************************************
  FILE : apb_master_agent1.sv
 ******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV1
`define APB_MASTER_AGENT_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_master_agent1
//------------------------------------------------------------------------------

class apb_master_agent1 extends uvm_agent;

  // This1 field determines1 whether1 an agent1 is active or passive1.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration1 information: (master_config1: name, is_active)
  apb_config1 cfg;

  apb_monitor1   monitor1;
  apb_collector1 collector1;
  apb_master_sequencer1 sequencer;
  apb_master_driver1    driver;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent1)
    `uvm_field_object(monitor1, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector1, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config1(input apb_config1 cfg);

endclass : apb_master_agent1

// UVM build_phase
function void apb_master_agent1::build_phase(uvm_phase phase);
  uvm_object config_obj1;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config1)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG1", 
          "Config1 not set for master1 agent1, using default is_active field")
    end
  else is_active = cfg.master_config1.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer1::type_id::create("sequencer",this);
    driver = apb_master_driver1::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect1 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config1() 
function void apb_master_agent1::update_config1(input apb_config1 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config1

`endif // APB_MASTER_AGENT_SV1
