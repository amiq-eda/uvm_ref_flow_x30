/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_vir_sequencer15.sv
Title15       : Virtual sequencer
Project15     :
Created15     :
Description15 : This15 file implements15 the Virtual sequencer for APB15-UART15 environment15
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer15 extends uvm_sequencer;

    ahb_pkg15::ahb_master_sequencer15 ahb_seqr15;
    uart_pkg15::uart_sequencer15 uart0_seqr15;
    uart_pkg15::uart_sequencer15 uart1_seqr15;
    spi_sequencer15 spi0_seqr15;
    gpio_sequencer15 gpio0_seqr15;
    apb_ss_reg_model_c15 reg_model_ptr15;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer15)
       `uvm_field_object(reg_model_ptr15, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer15

