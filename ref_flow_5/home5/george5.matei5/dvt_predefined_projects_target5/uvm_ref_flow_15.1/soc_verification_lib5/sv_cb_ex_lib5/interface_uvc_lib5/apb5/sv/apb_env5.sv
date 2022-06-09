/*******************************************************************************
  FILE : apb_env5.sv
*******************************************************************************/
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

`ifndef APB_ENV_SV5
`define APB_ENV_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_env5
//------------------------------------------------------------------------------

class apb_env5 extends uvm_env;

  // Virtual interface for this environment5. This5 should only be done if the
  // same interface is used for all masters5/slaves5 in the environment5. Otherwise5,
  // Each agent5 should have its interface independently5 set.
  protected virtual interface apb_if5 vif5;

  // Environment5 Configuration5 Parameters5
  apb_config5 cfg;     // APB5 configuration object

  // The following5 two5 bits are used to control5 whether5 checks5 and coverage5 are
  // done both in the bus monitor5 class and the interface.
  bit checks_enable5 = 1; 
  bit coverage_enable5 = 1;

  // Components of the environment5
  apb_monitor5 bus_monitor5;
  apb_collector5 bus_collector5;
  apb_master_agent5 master5;
  apb_slave_agent5 slaves5[];

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(apb_env5)
    `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_field_int(checks_enable5, UVM_DEFAULT)
    `uvm_field_int(coverage_enable5, UVM_DEFAULT)
  `uvm_component_utils_end

  // Constructor5 - Required5 UVM syntax5
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config5(apb_config5 cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables5();

endclass : apb_env5

// UVM build_phase
function void apb_env5::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Create5 the APB5 UVC5 configuration class if it has not been set
  if(cfg == null) //begin
    if (!uvm_config_db#(apb_config5)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG5", "Using default_apb_config5", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_apb_config5","cfg"));
  end
  // set the master5 config
  uvm_config_object::set(this, "*", "cfg", cfg); 
  // set the slave5 configs5
  foreach(cfg.slave_configs5[i]) begin
    string sname;
    sname = $psprintf("slave5[%0d]*", i); 
    uvm_config_object::set(this, sname, "cfg", cfg.slave_configs5[i]);
  end

  bus_monitor5 = apb_monitor5::type_id::create("bus_monitor5",this);
  bus_collector5 = apb_collector5::type_id::create("bus_collector5",this);
  master5 = apb_master_agent5::type_id::create(cfg.master_config5.name,this);
  slaves5 = new[cfg.slave_configs5.size()];
  for(int i = 0; i < cfg.slave_configs5.size(); i++) begin
    slaves5[i] = apb_slave_agent5::type_id::create($psprintf("slave5[%0d]", i), this);
  end

endfunction : build_phase

// UVM connect_phase
function void apb_env5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // Get5 the virtual interface if set via get_config
  if (!uvm_config_db#(virtual apb_if5)::get(this, "", "vif5", vif5))
    `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
  bus_collector5.item_collected_port5.connect(bus_monitor5.coll_mon_port5);
  bus_monitor5.addr_trans_port5.connect(bus_collector5.addr_trans_export5);
  master5.monitor5 = bus_monitor5;
  master5.collector5 = bus_collector5;
  foreach(slaves5[i]) begin
    slaves5[i].monitor5 = bus_monitor5;
    slaves5[i].collector5 = bus_collector5;
    if (slaves5[i].is_active == UVM_ACTIVE)
      slaves5[i].sequencer.addr_trans_port5.connect(bus_monitor5.addr_trans_export5);
  end
endfunction : connect_phase

// UVM start_of_simulation_phase
function void apb_env5::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR5", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET5", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config5() method
function void apb_env5::update_config5(apb_config5 cfg);
  bus_monitor5.cfg = cfg;
  bus_collector5.cfg = cfg;
  master5.update_config5(cfg);
  foreach(slaves5[i])
    slaves5[i].update_config5(cfg.slave_configs5[i]);
endfunction : update_config5

// update_vif_enables5
task apb_env5::update_vif_enables5();
  vif5.has_checks5 <= checks_enable5;
  vif5.has_coverage <= coverage_enable5;
  forever begin
    @(checks_enable5 || coverage_enable5);
    vif5.has_checks5 <= checks_enable5;
    vif5.has_coverage <= coverage_enable5;
  end
endtask : update_vif_enables5

//UVM run_phase()
task apb_env5::run_phase(uvm_phase phase);
  fork
    update_vif_enables5();
  join
endtask : run_phase

`endif // APB_ENV_SV5
