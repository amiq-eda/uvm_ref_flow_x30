/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_vir_sequencer26.sv
Title26       : Virtual sequencer
Project26     :
Created26     :
Description26 : This26 file implements26 the Virtual sequencer for APB26-UART26 environment26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer26 extends uvm_sequencer;

    ahb_pkg26::ahb_master_sequencer26 ahb_seqr26;
    uart_pkg26::uart_sequencer26 uart0_seqr26;
    uart_pkg26::uart_sequencer26 uart1_seqr26;
    spi_sequencer26 spi0_seqr26;
    gpio_sequencer26 gpio0_seqr26;
    apb_ss_reg_model_c26 reg_model_ptr26;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer26)
       `uvm_field_object(reg_model_ptr26, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer26

