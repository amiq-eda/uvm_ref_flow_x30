// IVB28 checksum28: 2064975656
/*-----------------------------------------------------------------
File28 name     : ahb_env28.sv
Created28       : Wed28 May28 19 15:42:20 2010
Description28   : This28 file implements28 the OVC28 env28.
Notes28         :
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV28
`define AHB_ENV_SV28

//------------------------------------------------------------------------------
//
// CLASS28: ahb_env28
//
//------------------------------------------------------------------------------

class ahb_env28 extends uvm_env;

  // Virtual Interface28 variable
  protected virtual interface ahb_if28 vif28;
 
  // The following28 two28 bits are used to control28 whether28 checks28 and coverage28 are
  // done both in the bus monitor28 class and the interface.
  bit checks_enable28 = 1; 
  bit coverage_enable28 = 1;

  // Components of the environment28
  ahb_master_agent28 master_agent28;
  ahb_slave_agent28 slave_agent28;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(ahb_env28)
    `uvm_field_int(checks_enable28, UVM_ALL_ON)
    `uvm_field_int(coverage_enable28, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor28 - required28 syntax28 for UVM automation28 and utilities28
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables28();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env28

  // UVM build() phase
  function void ahb_env28::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent28 = ahb_master_agent28::type_id::create("master_agent28", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if28)::get(this, "", "vif28", vif28))
   `uvm_fatal("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

  // Function28 to assign the checks28 and coverage28 bits
  task ahb_env28::update_vif_enables28();
    // Make28 assignments28 at time zero based upon28 config
    vif28.has_checks28 <= checks_enable28;
    vif28.has_coverage <= coverage_enable28;
    forever begin
      // Make28 assignments28 whenever28 enables28 change after time zero
      @(checks_enable28 || coverage_enable28);
      vif28.has_checks28 <= checks_enable28;
      vif28.has_coverage <= coverage_enable28;
    end
  endtask : update_vif_enables28

  // UVM run() phase
  task ahb_env28::run_phase(uvm_phase phase);
    fork
      update_vif_enables28();
    join_none
  endtask

`endif // AHB_ENV_SV28

