// IVB16 checksum16: 2064975656
/*-----------------------------------------------------------------
File16 name     : ahb_env16.sv
Created16       : Wed16 May16 19 15:42:20 2010
Description16   : This16 file implements16 the OVC16 env16.
Notes16         :
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV16
`define AHB_ENV_SV16

//------------------------------------------------------------------------------
//
// CLASS16: ahb_env16
//
//------------------------------------------------------------------------------

class ahb_env16 extends uvm_env;

  // Virtual Interface16 variable
  protected virtual interface ahb_if16 vif16;
 
  // The following16 two16 bits are used to control16 whether16 checks16 and coverage16 are
  // done both in the bus monitor16 class and the interface.
  bit checks_enable16 = 1; 
  bit coverage_enable16 = 1;

  // Components of the environment16
  ahb_master_agent16 master_agent16;
  ahb_slave_agent16 slave_agent16;

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(ahb_env16)
    `uvm_field_int(checks_enable16, UVM_ALL_ON)
    `uvm_field_int(coverage_enable16, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor16 - required16 syntax16 for UVM automation16 and utilities16
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables16();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env16

  // UVM build() phase
  function void ahb_env16::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent16 = ahb_master_agent16::type_id::create("master_agent16", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if16)::get(this, "", "vif16", vif16))
   `uvm_fatal("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

  // Function16 to assign the checks16 and coverage16 bits
  task ahb_env16::update_vif_enables16();
    // Make16 assignments16 at time zero based upon16 config
    vif16.has_checks16 <= checks_enable16;
    vif16.has_coverage <= coverage_enable16;
    forever begin
      // Make16 assignments16 whenever16 enables16 change after time zero
      @(checks_enable16 || coverage_enable16);
      vif16.has_checks16 <= checks_enable16;
      vif16.has_coverage <= coverage_enable16;
    end
  endtask : update_vif_enables16

  // UVM run() phase
  task ahb_env16::run_phase(uvm_phase phase);
    fork
      update_vif_enables16();
    join_none
  endtask

`endif // AHB_ENV_SV16

