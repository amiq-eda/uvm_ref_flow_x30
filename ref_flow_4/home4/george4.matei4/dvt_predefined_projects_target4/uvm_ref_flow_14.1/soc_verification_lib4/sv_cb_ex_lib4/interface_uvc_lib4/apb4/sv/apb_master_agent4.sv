/******************************************************************************
  FILE : apb_master_agent4.sv
 ******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV4
`define APB_MASTER_AGENT_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_master_agent4
//------------------------------------------------------------------------------

class apb_master_agent4 extends uvm_agent;

  // This4 field determines4 whether4 an agent4 is active or passive4.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration4 information: (master_config4: name, is_active)
  apb_config4 cfg;

  apb_monitor4   monitor4;
  apb_collector4 collector4;
  apb_master_sequencer4 sequencer;
  apb_master_driver4    driver;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent4)
    `uvm_field_object(monitor4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config4(input apb_config4 cfg);

endclass : apb_master_agent4

// UVM build_phase
function void apb_master_agent4::build_phase(uvm_phase phase);
  uvm_object config_obj4;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config4)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG4", 
          "Config4 not set for master4 agent4, using default is_active field")
    end
  else is_active = cfg.master_config4.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer4::type_id::create("sequencer",this);
    driver = apb_master_driver4::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect4 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config4() 
function void apb_master_agent4::update_config4(input apb_config4 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config4

`endif // APB_MASTER_AGENT_SV4
