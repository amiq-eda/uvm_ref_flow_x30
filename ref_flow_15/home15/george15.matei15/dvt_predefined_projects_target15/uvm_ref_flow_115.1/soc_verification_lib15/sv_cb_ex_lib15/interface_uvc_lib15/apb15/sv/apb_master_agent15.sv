/******************************************************************************
  FILE : apb_master_agent15.sv
 ******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV15
`define APB_MASTER_AGENT_SV15

//------------------------------------------------------------------------------
// CLASS15: apb_master_agent15
//------------------------------------------------------------------------------

class apb_master_agent15 extends uvm_agent;

  // This15 field determines15 whether15 an agent15 is active or passive15.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration15 information: (master_config15: name, is_active)
  apb_config15 cfg;

  apb_monitor15   monitor15;
  apb_collector15 collector15;
  apb_master_sequencer15 sequencer;
  apb_master_driver15    driver;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent15)
    `uvm_field_object(monitor15, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector15, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config15(input apb_config15 cfg);

endclass : apb_master_agent15

// UVM build_phase
function void apb_master_agent15::build_phase(uvm_phase phase);
  uvm_object config_obj15;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config15)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG15", 
          "Config15 not set for master15 agent15, using default is_active field")
    end
  else is_active = cfg.master_config15.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer15::type_id::create("sequencer",this);
    driver = apb_master_driver15::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect15 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config15() 
function void apb_master_agent15::update_config15(input apb_config15 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config15

`endif // APB_MASTER_AGENT_SV15
