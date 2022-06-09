/******************************************************************************
  FILE : apb_master_agent5.sv
 ******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_MASTER_AGENT_SV5
`define APB_MASTER_AGENT_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_master_agent5
//------------------------------------------------------------------------------

class apb_master_agent5 extends uvm_agent;

  // This5 field determines5 whether5 an agent5 is active or passive5.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Configuration5 information: (master_config5: name, is_active)
  apb_config5 cfg;

  apb_monitor5   monitor5;
  apb_collector5 collector5;
  apb_master_sequencer5 sequencer;
  apb_master_driver5    driver;

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(apb_master_agent5)
    `uvm_field_object(monitor5, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(collector5, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config5(input apb_config5 cfg);

endclass : apb_master_agent5

// UVM build_phase
function void apb_master_agent5::build_phase(uvm_phase phase);
  uvm_object config_obj5;
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(apb_config5)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG5", 
          "Config5 not set for master5 agent5, using default is_active field")
    end
  else is_active = cfg.master_config5.is_active;
  
  if(is_active == UVM_ACTIVE) begin
    sequencer = apb_master_sequencer5::type_id::create("sequencer",this);
    driver = apb_master_driver5::type_id::create("driver",this);
  end
endfunction : build_phase

// UVM connect_phase
function void apb_master_agent5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (is_active == UVM_ACTIVE) begin
    // Connect5 the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// update_config5() 
function void apb_master_agent5::update_config5(input apb_config5 cfg);
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config5

`endif // APB_MASTER_AGENT_SV5
