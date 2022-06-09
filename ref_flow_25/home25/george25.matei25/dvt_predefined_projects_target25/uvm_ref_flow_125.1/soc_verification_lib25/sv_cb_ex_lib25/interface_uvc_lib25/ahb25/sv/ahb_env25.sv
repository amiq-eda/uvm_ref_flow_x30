// IVB25 checksum25: 2064975656
/*-----------------------------------------------------------------
File25 name     : ahb_env25.sv
Created25       : Wed25 May25 19 15:42:20 2010
Description25   : This25 file implements25 the OVC25 env25.
Notes25         :
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV25
`define AHB_ENV_SV25

//------------------------------------------------------------------------------
//
// CLASS25: ahb_env25
//
//------------------------------------------------------------------------------

class ahb_env25 extends uvm_env;

  // Virtual Interface25 variable
  protected virtual interface ahb_if25 vif25;
 
  // The following25 two25 bits are used to control25 whether25 checks25 and coverage25 are
  // done both in the bus monitor25 class and the interface.
  bit checks_enable25 = 1; 
  bit coverage_enable25 = 1;

  // Components of the environment25
  ahb_master_agent25 master_agent25;
  ahb_slave_agent25 slave_agent25;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(ahb_env25)
    `uvm_field_int(checks_enable25, UVM_ALL_ON)
    `uvm_field_int(coverage_enable25, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables25();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env25

  // UVM build() phase
  function void ahb_env25::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent25 = ahb_master_agent25::type_id::create("master_agent25", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if25)::get(this, "", "vif25", vif25))
   `uvm_fatal("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

  // Function25 to assign the checks25 and coverage25 bits
  task ahb_env25::update_vif_enables25();
    // Make25 assignments25 at time zero based upon25 config
    vif25.has_checks25 <= checks_enable25;
    vif25.has_coverage <= coverage_enable25;
    forever begin
      // Make25 assignments25 whenever25 enables25 change after time zero
      @(checks_enable25 || coverage_enable25);
      vif25.has_checks25 <= checks_enable25;
      vif25.has_coverage <= coverage_enable25;
    end
  endtask : update_vif_enables25

  // UVM run() phase
  task ahb_env25::run_phase(uvm_phase phase);
    fork
      update_vif_enables25();
    join_none
  endtask

`endif // AHB_ENV_SV25

