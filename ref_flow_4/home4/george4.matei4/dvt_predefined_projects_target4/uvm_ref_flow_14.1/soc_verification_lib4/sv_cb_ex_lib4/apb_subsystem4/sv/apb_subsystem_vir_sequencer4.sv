/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_vir_sequencer4.sv
Title4       : Virtual sequencer
Project4     :
Created4     :
Description4 : This4 file implements4 the Virtual sequencer for APB4-UART4 environment4
Notes4       : 
----------------------------------------------------------------------*/
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

class apb_subsystem_virtual_sequencer4 extends uvm_sequencer;

    ahb_pkg4::ahb_master_sequencer4 ahb_seqr4;
    uart_pkg4::uart_sequencer4 uart0_seqr4;
    uart_pkg4::uart_sequencer4 uart1_seqr4;
    spi_sequencer4 spi0_seqr4;
    gpio_sequencer4 gpio0_seqr4;
    apb_ss_reg_model_c4 reg_model_ptr4;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer4)
       `uvm_field_object(reg_model_ptr4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer4

