// IVB20 checksum20: 2064975656
/*-----------------------------------------------------------------
File20 name     : ahb_env20.sv
Created20       : Wed20 May20 19 15:42:20 2010
Description20   : This20 file implements20 the OVC20 env20.
Notes20         :
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV20
`define AHB_ENV_SV20

//------------------------------------------------------------------------------
//
// CLASS20: ahb_env20
//
//------------------------------------------------------------------------------

class ahb_env20 extends uvm_env;

  // Virtual Interface20 variable
  protected virtual interface ahb_if20 vif20;
 
  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done both in the bus monitor20 class and the interface.
  bit checks_enable20 = 1; 
  bit coverage_enable20 = 1;

  // Components of the environment20
  ahb_master_agent20 master_agent20;
  ahb_slave_agent20 slave_agent20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(ahb_env20)
    `uvm_field_int(checks_enable20, UVM_ALL_ON)
    `uvm_field_int(coverage_enable20, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables20();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env20

  // UVM build() phase
  function void ahb_env20::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent20 = ahb_master_agent20::type_id::create("master_agent20", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if20)::get(this, "", "vif20", vif20))
   `uvm_fatal("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

  // Function20 to assign the checks20 and coverage20 bits
  task ahb_env20::update_vif_enables20();
    // Make20 assignments20 at time zero based upon20 config
    vif20.has_checks20 <= checks_enable20;
    vif20.has_coverage <= coverage_enable20;
    forever begin
      // Make20 assignments20 whenever20 enables20 change after time zero
      @(checks_enable20 || coverage_enable20);
      vif20.has_checks20 <= checks_enable20;
      vif20.has_coverage <= coverage_enable20;
    end
  endtask : update_vif_enables20

  // UVM run() phase
  task ahb_env20::run_phase(uvm_phase phase);
    fork
      update_vif_enables20();
    join_none
  endtask

`endif // AHB_ENV_SV20

