// IVB22 checksum22: 2064975656
/*-----------------------------------------------------------------
File22 name     : ahb_env22.sv
Created22       : Wed22 May22 19 15:42:20 2010
Description22   : This22 file implements22 the OVC22 env22.
Notes22         :
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV22
`define AHB_ENV_SV22

//------------------------------------------------------------------------------
//
// CLASS22: ahb_env22
//
//------------------------------------------------------------------------------

class ahb_env22 extends uvm_env;

  // Virtual Interface22 variable
  protected virtual interface ahb_if22 vif22;
 
  // The following22 two22 bits are used to control22 whether22 checks22 and coverage22 are
  // done both in the bus monitor22 class and the interface.
  bit checks_enable22 = 1; 
  bit coverage_enable22 = 1;

  // Components of the environment22
  ahb_master_agent22 master_agent22;
  ahb_slave_agent22 slave_agent22;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(ahb_env22)
    `uvm_field_int(checks_enable22, UVM_ALL_ON)
    `uvm_field_int(coverage_enable22, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables22();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env22

  // UVM build() phase
  function void ahb_env22::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent22 = ahb_master_agent22::type_id::create("master_agent22", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if22)::get(this, "", "vif22", vif22))
   `uvm_fatal("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

  // Function22 to assign the checks22 and coverage22 bits
  task ahb_env22::update_vif_enables22();
    // Make22 assignments22 at time zero based upon22 config
    vif22.has_checks22 <= checks_enable22;
    vif22.has_coverage <= coverage_enable22;
    forever begin
      // Make22 assignments22 whenever22 enables22 change after time zero
      @(checks_enable22 || coverage_enable22);
      vif22.has_checks22 <= checks_enable22;
      vif22.has_coverage <= coverage_enable22;
    end
  endtask : update_vif_enables22

  // UVM run() phase
  task ahb_env22::run_phase(uvm_phase phase);
    fork
      update_vif_enables22();
    join_none
  endtask

`endif // AHB_ENV_SV22

