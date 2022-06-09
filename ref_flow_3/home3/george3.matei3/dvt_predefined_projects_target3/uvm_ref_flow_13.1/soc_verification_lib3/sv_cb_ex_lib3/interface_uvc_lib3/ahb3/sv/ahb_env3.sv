// IVB3 checksum3: 2064975656
/*-----------------------------------------------------------------
File3 name     : ahb_env3.sv
Created3       : Wed3 May3 19 15:42:20 2010
Description3   : This3 file implements3 the OVC3 env3.
Notes3         :
-----------------------------------------------------------------*/
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


`ifndef AHB_ENV_SV3
`define AHB_ENV_SV3

//------------------------------------------------------------------------------
//
// CLASS3: ahb_env3
//
//------------------------------------------------------------------------------

class ahb_env3 extends uvm_env;

  // Virtual Interface3 variable
  protected virtual interface ahb_if3 vif3;
 
  // The following3 two3 bits are used to control3 whether3 checks3 and coverage3 are
  // done both in the bus monitor3 class and the interface.
  bit checks_enable3 = 1; 
  bit coverage_enable3 = 1;

  // Components of the environment3
  ahb_master_agent3 master_agent3;
  ahb_slave_agent3 slave_agent3;

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(ahb_env3)
    `uvm_field_int(checks_enable3, UVM_ALL_ON)
    `uvm_field_int(coverage_enable3, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables3();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env3

  // UVM build() phase
  function void ahb_env3::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent3 = ahb_master_agent3::type_id::create("master_agent3", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if3)::get(this, "", "vif3", vif3))
   `uvm_fatal("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

  // Function3 to assign the checks3 and coverage3 bits
  task ahb_env3::update_vif_enables3();
    // Make3 assignments3 at time zero based upon3 config
    vif3.has_checks3 <= checks_enable3;
    vif3.has_coverage <= coverage_enable3;
    forever begin
      // Make3 assignments3 whenever3 enables3 change after time zero
      @(checks_enable3 || coverage_enable3);
      vif3.has_checks3 <= checks_enable3;
      vif3.has_coverage <= coverage_enable3;
    end
  endtask : update_vif_enables3

  // UVM run() phase
  task ahb_env3::run_phase(uvm_phase phase);
    fork
      update_vif_enables3();
    join_none
  endtask

`endif // AHB_ENV_SV3

