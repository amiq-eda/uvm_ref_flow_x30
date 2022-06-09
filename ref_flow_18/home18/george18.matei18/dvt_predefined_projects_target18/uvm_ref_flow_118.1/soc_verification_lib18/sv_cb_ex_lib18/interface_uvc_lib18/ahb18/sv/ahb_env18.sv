// IVB18 checksum18: 2064975656
/*-----------------------------------------------------------------
File18 name     : ahb_env18.sv
Created18       : Wed18 May18 19 15:42:20 2010
Description18   : This18 file implements18 the OVC18 env18.
Notes18         :
-----------------------------------------------------------------*/
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


`ifndef AHB_ENV_SV18
`define AHB_ENV_SV18

//------------------------------------------------------------------------------
//
// CLASS18: ahb_env18
//
//------------------------------------------------------------------------------

class ahb_env18 extends uvm_env;

  // Virtual Interface18 variable
  protected virtual interface ahb_if18 vif18;
 
  // The following18 two18 bits are used to control18 whether18 checks18 and coverage18 are
  // done both in the bus monitor18 class and the interface.
  bit checks_enable18 = 1; 
  bit coverage_enable18 = 1;

  // Components of the environment18
  ahb_master_agent18 master_agent18;
  ahb_slave_agent18 slave_agent18;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(ahb_env18)
    `uvm_field_int(checks_enable18, UVM_ALL_ON)
    `uvm_field_int(coverage_enable18, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor18 - required18 syntax18 for UVM automation18 and utilities18
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables18();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env18

  // UVM build() phase
  function void ahb_env18::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent18 = ahb_master_agent18::type_id::create("master_agent18", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if18)::get(this, "", "vif18", vif18))
   `uvm_fatal("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

  // Function18 to assign the checks18 and coverage18 bits
  task ahb_env18::update_vif_enables18();
    // Make18 assignments18 at time zero based upon18 config
    vif18.has_checks18 <= checks_enable18;
    vif18.has_coverage <= coverage_enable18;
    forever begin
      // Make18 assignments18 whenever18 enables18 change after time zero
      @(checks_enable18 || coverage_enable18);
      vif18.has_checks18 <= checks_enable18;
      vif18.has_coverage <= coverage_enable18;
    end
  endtask : update_vif_enables18

  // UVM run() phase
  task ahb_env18::run_phase(uvm_phase phase);
    fork
      update_vif_enables18();
    join_none
  endtask

`endif // AHB_ENV_SV18

