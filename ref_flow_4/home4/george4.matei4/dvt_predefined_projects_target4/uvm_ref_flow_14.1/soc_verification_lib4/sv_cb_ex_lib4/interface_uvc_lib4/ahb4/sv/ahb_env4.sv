// IVB4 checksum4: 2064975656
/*-----------------------------------------------------------------
File4 name     : ahb_env4.sv
Created4       : Wed4 May4 19 15:42:20 2010
Description4   : This4 file implements4 the OVC4 env4.
Notes4         :
-----------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV4
`define AHB_ENV_SV4

//------------------------------------------------------------------------------
//
// CLASS4: ahb_env4
//
//------------------------------------------------------------------------------

class ahb_env4 extends uvm_env;

  // Virtual Interface4 variable
  protected virtual interface ahb_if4 vif4;
 
  // The following4 two4 bits are used to control4 whether4 checks4 and coverage4 are
  // done both in the bus monitor4 class and the interface.
  bit checks_enable4 = 1; 
  bit coverage_enable4 = 1;

  // Components of the environment4
  ahb_master_agent4 master_agent4;
  ahb_slave_agent4 slave_agent4;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(ahb_env4)
    `uvm_field_int(checks_enable4, UVM_ALL_ON)
    `uvm_field_int(coverage_enable4, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor4 - required4 syntax4 for UVM automation4 and utilities4
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables4();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env4

  // UVM build() phase
  function void ahb_env4::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent4 = ahb_master_agent4::type_id::create("master_agent4", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if4)::get(this, "", "vif4", vif4))
   `uvm_fatal("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

  // Function4 to assign the checks4 and coverage4 bits
  task ahb_env4::update_vif_enables4();
    // Make4 assignments4 at time zero based upon4 config
    vif4.has_checks4 <= checks_enable4;
    vif4.has_coverage <= coverage_enable4;
    forever begin
      // Make4 assignments4 whenever4 enables4 change after time zero
      @(checks_enable4 || coverage_enable4);
      vif4.has_checks4 <= checks_enable4;
      vif4.has_coverage <= coverage_enable4;
    end
  endtask : update_vif_enables4

  // UVM run() phase
  task ahb_env4::run_phase(uvm_phase phase);
    fork
      update_vif_enables4();
    join_none
  endtask

`endif // AHB_ENV_SV4

