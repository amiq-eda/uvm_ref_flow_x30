/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_vir_sequencer10.sv
Title10       : Virtual sequencer
Project10     :
Created10     :
Description10 : This10 file implements10 the Virtual sequencer for APB10-UART10 environment10
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer10 extends uvm_sequencer;

    ahb_pkg10::ahb_master_sequencer10 ahb_seqr10;
    uart_pkg10::uart_sequencer10 uart0_seqr10;
    uart_pkg10::uart_sequencer10 uart1_seqr10;
    spi_sequencer10 spi0_seqr10;
    gpio_sequencer10 gpio0_seqr10;
    apb_ss_reg_model_c10 reg_model_ptr10;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer10)
       `uvm_field_object(reg_model_ptr10, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer10

