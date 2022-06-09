// IVB26 checksum26: 2064975656
/*-----------------------------------------------------------------
File26 name     : ahb_env26.sv
Created26       : Wed26 May26 19 15:42:20 2010
Description26   : This26 file implements26 the OVC26 env26.
Notes26         :
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV26
`define AHB_ENV_SV26

//------------------------------------------------------------------------------
//
// CLASS26: ahb_env26
//
//------------------------------------------------------------------------------

class ahb_env26 extends uvm_env;

  // Virtual Interface26 variable
  protected virtual interface ahb_if26 vif26;
 
  // The following26 two26 bits are used to control26 whether26 checks26 and coverage26 are
  // done both in the bus monitor26 class and the interface.
  bit checks_enable26 = 1; 
  bit coverage_enable26 = 1;

  // Components of the environment26
  ahb_master_agent26 master_agent26;
  ahb_slave_agent26 slave_agent26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(ahb_env26)
    `uvm_field_int(checks_enable26, UVM_ALL_ON)
    `uvm_field_int(coverage_enable26, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables26();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env26

  // UVM build() phase
  function void ahb_env26::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent26 = ahb_master_agent26::type_id::create("master_agent26", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if26)::get(this, "", "vif26", vif26))
   `uvm_fatal("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

  // Function26 to assign the checks26 and coverage26 bits
  task ahb_env26::update_vif_enables26();
    // Make26 assignments26 at time zero based upon26 config
    vif26.has_checks26 <= checks_enable26;
    vif26.has_coverage <= coverage_enable26;
    forever begin
      // Make26 assignments26 whenever26 enables26 change after time zero
      @(checks_enable26 || coverage_enable26);
      vif26.has_checks26 <= checks_enable26;
      vif26.has_coverage <= coverage_enable26;
    end
  endtask : update_vif_enables26

  // UVM run() phase
  task ahb_env26::run_phase(uvm_phase phase);
    fork
      update_vif_enables26();
    join_none
  endtask

`endif // AHB_ENV_SV26

