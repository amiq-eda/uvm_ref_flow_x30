// IVB14 checksum14: 2064975656
/*-----------------------------------------------------------------
File14 name     : ahb_env14.sv
Created14       : Wed14 May14 19 15:42:20 2010
Description14   : This14 file implements14 the OVC14 env14.
Notes14         :
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV14
`define AHB_ENV_SV14

//------------------------------------------------------------------------------
//
// CLASS14: ahb_env14
//
//------------------------------------------------------------------------------

class ahb_env14 extends uvm_env;

  // Virtual Interface14 variable
  protected virtual interface ahb_if14 vif14;
 
  // The following14 two14 bits are used to control14 whether14 checks14 and coverage14 are
  // done both in the bus monitor14 class and the interface.
  bit checks_enable14 = 1; 
  bit coverage_enable14 = 1;

  // Components of the environment14
  ahb_master_agent14 master_agent14;
  ahb_slave_agent14 slave_agent14;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(ahb_env14)
    `uvm_field_int(checks_enable14, UVM_ALL_ON)
    `uvm_field_int(coverage_enable14, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables14();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env14

  // UVM build() phase
  function void ahb_env14::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent14 = ahb_master_agent14::type_id::create("master_agent14", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if14)::get(this, "", "vif14", vif14))
   `uvm_fatal("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

  // Function14 to assign the checks14 and coverage14 bits
  task ahb_env14::update_vif_enables14();
    // Make14 assignments14 at time zero based upon14 config
    vif14.has_checks14 <= checks_enable14;
    vif14.has_coverage <= coverage_enable14;
    forever begin
      // Make14 assignments14 whenever14 enables14 change after time zero
      @(checks_enable14 || coverage_enable14);
      vif14.has_checks14 <= checks_enable14;
      vif14.has_coverage <= coverage_enable14;
    end
  endtask : update_vif_enables14

  // UVM run() phase
  task ahb_env14::run_phase(uvm_phase phase);
    fork
      update_vif_enables14();
    join_none
  endtask

`endif // AHB_ENV_SV14

