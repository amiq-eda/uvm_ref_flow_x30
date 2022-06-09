/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_vir_sequencer30.sv
Title30       : Virtual sequencer
Project30     :
Created30     :
Description30 : This30 file implements30 the Virtual sequencer for APB30-UART30 environment30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer30 extends uvm_sequencer;

    ahb_pkg30::ahb_master_sequencer30 ahb_seqr30;
    uart_pkg30::uart_sequencer30 uart0_seqr30;
    uart_pkg30::uart_sequencer30 uart1_seqr30;
    spi_sequencer30 spi0_seqr30;
    gpio_sequencer30 gpio0_seqr30;
    apb_ss_reg_model_c30 reg_model_ptr30;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer30)
       `uvm_field_object(reg_model_ptr30, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer30

