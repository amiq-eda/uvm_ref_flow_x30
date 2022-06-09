/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_vir_sequencer27.sv
Title27       : Virtual sequencer
Project27     :
Created27     :
Description27 : This27 file implements27 the Virtual sequencer for APB27-UART27 environment27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer27 extends uvm_sequencer;

    ahb_pkg27::ahb_master_sequencer27 ahb_seqr27;
    uart_pkg27::uart_sequencer27 uart0_seqr27;
    uart_pkg27::uart_sequencer27 uart1_seqr27;
    spi_sequencer27 spi0_seqr27;
    gpio_sequencer27 gpio0_seqr27;
    apb_ss_reg_model_c27 reg_model_ptr27;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer27)
       `uvm_field_object(reg_model_ptr27, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer27

