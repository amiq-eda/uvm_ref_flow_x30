/******************************************************************************
  FILE : apb_master_agent22.sv
 ******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV22
`define APB_MASTER_AGENT_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_master_agent22
//------------------------------------------------------------------------------

class apb_master_agent22 extends uvm_agent;

  // This22 field determines22 whether22 an agent22 is active or passive22.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration22 information: (master_config22: name, is_active)
  apb_config22 cfg;

  apb_monitor22   monitor22;
  apb_collector22 collector22;
  apb_master_sequencer22 sequencer;
  apb_master_driver22    driver;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent22)
    `uvm_field_object(monitor22, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector22, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config22(input apb_config22 cfg);

endclass : apb_master_agent22

// UVM build_phase
function void apb_master_agent22::build_phase(uvm_phase phase);
  uvm_object config_obj22;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config22)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG22", 
          "Config22 not set for master22 agent22, using default is_active field")
    end
  else is_active = cfg.master_config22.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer22::type_id::create("sequencer",this);
    driver = apb_master_driver22::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect22 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config22() 
function void apb_master_agent22::update_config22(input apb_config22 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config22

`endif // APB_MASTER_AGENT_SV22
