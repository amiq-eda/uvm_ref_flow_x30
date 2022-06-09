/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_vir_sequencer12.sv
Title12       : Virtual sequencer
Project12     :
Created12     :
Description12 : This12 file implements12 the Virtual sequencer for APB12-UART12 environment12
Notes12       : 
----------------------------------------------------------------------*/
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

class apb_subsystem_virtual_sequencer12 extends uvm_sequencer;

    ahb_pkg12::ahb_master_sequencer12 ahb_seqr12;
    uart_pkg12::uart_sequencer12 uart0_seqr12;
    uart_pkg12::uart_sequencer12 uart1_seqr12;
    spi_sequencer12 spi0_seqr12;
    gpio_sequencer12 gpio0_seqr12;
    apb_ss_reg_model_c12 reg_model_ptr12;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer12)
       `uvm_field_object(reg_model_ptr12, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer12

