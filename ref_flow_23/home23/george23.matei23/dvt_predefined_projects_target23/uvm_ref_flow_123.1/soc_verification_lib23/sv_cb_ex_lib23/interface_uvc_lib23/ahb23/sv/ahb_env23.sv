// IVB23 checksum23: 2064975656
/*-----------------------------------------------------------------
File23 name     : ahb_env23.sv
Created23       : Wed23 May23 19 15:42:20 2010
Description23   : This23 file implements23 the OVC23 env23.
Notes23         :
-----------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV23
`define AHB_ENV_SV23

//------------------------------------------------------------------------------
//
// CLASS23: ahb_env23
//
//------------------------------------------------------------------------------

class ahb_env23 extends uvm_env;

  // Virtual Interface23 variable
  protected virtual interface ahb_if23 vif23;
 
  // The following23 two23 bits are used to control23 whether23 checks23 and coverage23 are
  // done both in the bus monitor23 class and the interface.
  bit checks_enable23 = 1; 
  bit coverage_enable23 = 1;

  // Components of the environment23
  ahb_master_agent23 master_agent23;
  ahb_slave_agent23 slave_agent23;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(ahb_env23)
    `uvm_field_int(checks_enable23, UVM_ALL_ON)
    `uvm_field_int(coverage_enable23, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor23 - required23 syntax23 for UVM automation23 and utilities23
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables23();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env23

  // UVM build() phase
  function void ahb_env23::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent23 = ahb_master_agent23::type_id::create("master_agent23", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if23)::get(this, "", "vif23", vif23))
   `uvm_fatal("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

  // Function23 to assign the checks23 and coverage23 bits
  task ahb_env23::update_vif_enables23();
    // Make23 assignments23 at time zero based upon23 config
    vif23.has_checks23 <= checks_enable23;
    vif23.has_coverage <= coverage_enable23;
    forever begin
      // Make23 assignments23 whenever23 enables23 change after time zero
      @(checks_enable23 || coverage_enable23);
      vif23.has_checks23 <= checks_enable23;
      vif23.has_coverage <= coverage_enable23;
    end
  endtask : update_vif_enables23

  // UVM run() phase
  task ahb_env23::run_phase(uvm_phase phase);
    fork
      update_vif_enables23();
    join_none
  endtask

`endif // AHB_ENV_SV23

