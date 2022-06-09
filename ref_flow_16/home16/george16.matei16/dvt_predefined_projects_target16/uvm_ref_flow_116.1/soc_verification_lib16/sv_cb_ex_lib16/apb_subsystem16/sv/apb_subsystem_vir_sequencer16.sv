/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_vir_sequencer16.sv
Title16       : Virtual sequencer
Project16     :
Created16     :
Description16 : This16 file implements16 the Virtual sequencer for APB16-UART16 environment16
Notes16       : 
----------------------------------------------------------------------*/
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

class apb_subsystem_virtual_sequencer16 extends uvm_sequencer;

    ahb_pkg16::ahb_master_sequencer16 ahb_seqr16;
    uart_pkg16::uart_sequencer16 uart0_seqr16;
    uart_pkg16::uart_sequencer16 uart1_seqr16;
    spi_sequencer16 spi0_seqr16;
    gpio_sequencer16 gpio0_seqr16;
    apb_ss_reg_model_c16 reg_model_ptr16;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer16)
       `uvm_field_object(reg_model_ptr16, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer16

