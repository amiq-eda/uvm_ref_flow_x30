// IVB12 checksum12: 2064975656
/*-----------------------------------------------------------------
File12 name     : ahb_env12.sv
Created12       : Wed12 May12 19 15:42:20 2010
Description12   : This12 file implements12 the OVC12 env12.
Notes12         :
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV12
`define AHB_ENV_SV12

//------------------------------------------------------------------------------
//
// CLASS12: ahb_env12
//
//------------------------------------------------------------------------------

class ahb_env12 extends uvm_env;

  // Virtual Interface12 variable
  protected virtual interface ahb_if12 vif12;
 
  // The following12 two12 bits are used to control12 whether12 checks12 and coverage12 are
  // done both in the bus monitor12 class and the interface.
  bit checks_enable12 = 1; 
  bit coverage_enable12 = 1;

  // Components of the environment12
  ahb_master_agent12 master_agent12;
  ahb_slave_agent12 slave_agent12;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(ahb_env12)
    `uvm_field_int(checks_enable12, UVM_ALL_ON)
    `uvm_field_int(coverage_enable12, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor12 - required12 syntax12 for UVM automation12 and utilities12
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables12();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env12

  // UVM build() phase
  function void ahb_env12::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent12 = ahb_master_agent12::type_id::create("master_agent12", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if12)::get(this, "", "vif12", vif12))
   `uvm_fatal("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

  // Function12 to assign the checks12 and coverage12 bits
  task ahb_env12::update_vif_enables12();
    // Make12 assignments12 at time zero based upon12 config
    vif12.has_checks12 <= checks_enable12;
    vif12.has_coverage <= coverage_enable12;
    forever begin
      // Make12 assignments12 whenever12 enables12 change after time zero
      @(checks_enable12 || coverage_enable12);
      vif12.has_checks12 <= checks_enable12;
      vif12.has_coverage <= coverage_enable12;
    end
  endtask : update_vif_enables12

  // UVM run() phase
  task ahb_env12::run_phase(uvm_phase phase);
    fork
      update_vif_enables12();
    join_none
  endtask

`endif // AHB_ENV_SV12

