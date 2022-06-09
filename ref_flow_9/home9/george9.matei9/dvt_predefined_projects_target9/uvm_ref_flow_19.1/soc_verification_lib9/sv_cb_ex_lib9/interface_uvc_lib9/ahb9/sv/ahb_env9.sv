// IVB9 checksum9: 2064975656
/*-----------------------------------------------------------------
File9 name     : ahb_env9.sv
Created9       : Wed9 May9 19 15:42:20 2010
Description9   : This9 file implements9 the OVC9 env9.
Notes9         :
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV9
`define AHB_ENV_SV9

//------------------------------------------------------------------------------
//
// CLASS9: ahb_env9
//
//------------------------------------------------------------------------------

class ahb_env9 extends uvm_env;

  // Virtual Interface9 variable
  protected virtual interface ahb_if9 vif9;
 
  // The following9 two9 bits are used to control9 whether9 checks9 and coverage9 are
  // done both in the bus monitor9 class and the interface.
  bit checks_enable9 = 1; 
  bit coverage_enable9 = 1;

  // Components of the environment9
  ahb_master_agent9 master_agent9;
  ahb_slave_agent9 slave_agent9;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(ahb_env9)
    `uvm_field_int(checks_enable9, UVM_ALL_ON)
    `uvm_field_int(coverage_enable9, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables9();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env9

  // UVM build() phase
  function void ahb_env9::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent9 = ahb_master_agent9::type_id::create("master_agent9", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if9)::get(this, "", "vif9", vif9))
   `uvm_fatal("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

  // Function9 to assign the checks9 and coverage9 bits
  task ahb_env9::update_vif_enables9();
    // Make9 assignments9 at time zero based upon9 config
    vif9.has_checks9 <= checks_enable9;
    vif9.has_coverage <= coverage_enable9;
    forever begin
      // Make9 assignments9 whenever9 enables9 change after time zero
      @(checks_enable9 || coverage_enable9);
      vif9.has_checks9 <= checks_enable9;
      vif9.has_coverage <= coverage_enable9;
    end
  endtask : update_vif_enables9

  // UVM run() phase
  task ahb_env9::run_phase(uvm_phase phase);
    fork
      update_vif_enables9();
    join_none
  endtask

`endif // AHB_ENV_SV9

