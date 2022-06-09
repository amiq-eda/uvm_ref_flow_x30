// IVB30 checksum30: 2064975656
/*-----------------------------------------------------------------
File30 name     : ahb_env30.sv
Created30       : Wed30 May30 19 15:42:20 2010
Description30   : This30 file implements30 the OVC30 env30.
Notes30         :
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV30
`define AHB_ENV_SV30

//------------------------------------------------------------------------------
//
// CLASS30: ahb_env30
//
//------------------------------------------------------------------------------

class ahb_env30 extends uvm_env;

  // Virtual Interface30 variable
  protected virtual interface ahb_if30 vif30;
 
  // The following30 two30 bits are used to control30 whether30 checks30 and coverage30 are
  // done both in the bus monitor30 class and the interface.
  bit checks_enable30 = 1; 
  bit coverage_enable30 = 1;

  // Components of the environment30
  ahb_master_agent30 master_agent30;
  ahb_slave_agent30 slave_agent30;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(ahb_env30)
    `uvm_field_int(checks_enable30, UVM_ALL_ON)
    `uvm_field_int(coverage_enable30, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables30();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env30

  // UVM build() phase
  function void ahb_env30::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent30 = ahb_master_agent30::type_id::create("master_agent30", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if30)::get(this, "", "vif30", vif30))
   `uvm_fatal("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

  // Function30 to assign the checks30 and coverage30 bits
  task ahb_env30::update_vif_enables30();
    // Make30 assignments30 at time zero based upon30 config
    vif30.has_checks30 <= checks_enable30;
    vif30.has_coverage <= coverage_enable30;
    forever begin
      // Make30 assignments30 whenever30 enables30 change after time zero
      @(checks_enable30 || coverage_enable30);
      vif30.has_checks30 <= checks_enable30;
      vif30.has_coverage <= coverage_enable30;
    end
  endtask : update_vif_enables30

  // UVM run() phase
  task ahb_env30::run_phase(uvm_phase phase);
    fork
      update_vif_enables30();
    join_none
  endtask

`endif // AHB_ENV_SV30

