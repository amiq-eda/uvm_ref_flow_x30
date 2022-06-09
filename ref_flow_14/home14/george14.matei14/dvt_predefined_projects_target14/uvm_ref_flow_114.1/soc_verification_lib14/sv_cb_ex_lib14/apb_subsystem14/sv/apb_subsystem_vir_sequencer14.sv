/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_vir_sequencer14.sv
Title14       : Virtual sequencer
Project14     :
Created14     :
Description14 : This14 file implements14 the Virtual sequencer for APB14-UART14 environment14
Notes14       : 
----------------------------------------------------------------------*/
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

class apb_subsystem_virtual_sequencer14 extends uvm_sequencer;

    ahb_pkg14::ahb_master_sequencer14 ahb_seqr14;
    uart_pkg14::uart_sequencer14 uart0_seqr14;
    uart_pkg14::uart_sequencer14 uart1_seqr14;
    spi_sequencer14 spi0_seqr14;
    gpio_sequencer14 gpio0_seqr14;
    apb_ss_reg_model_c14 reg_model_ptr14;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer14)
       `uvm_field_object(reg_model_ptr14, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer14

