/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_vir_sequencer28.sv
Title28       : Virtual sequencer
Project28     :
Created28     :
Description28 : This28 file implements28 the Virtual sequencer for APB28-UART28 environment28
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer28 extends uvm_sequencer;

    ahb_pkg28::ahb_master_sequencer28 ahb_seqr28;
    uart_pkg28::uart_sequencer28 uart0_seqr28;
    uart_pkg28::uart_sequencer28 uart1_seqr28;
    spi_sequencer28 spi0_seqr28;
    gpio_sequencer28 gpio0_seqr28;
    apb_ss_reg_model_c28 reg_model_ptr28;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer28)
       `uvm_field_object(reg_model_ptr28, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer28

