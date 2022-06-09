/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_vir_sequencer7.sv
Title7       : Virtual sequencer
Project7     :
Created7     :
Description7 : This7 file implements7 the Virtual sequencer for APB7-UART7 environment7
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer7 extends uvm_sequencer;

    ahb_pkg7::ahb_master_sequencer7 ahb_seqr7;
    uart_pkg7::uart_sequencer7 uart0_seqr7;
    uart_pkg7::uart_sequencer7 uart1_seqr7;
    spi_sequencer7 spi0_seqr7;
    gpio_sequencer7 gpio0_seqr7;
    apb_ss_reg_model_c7 reg_model_ptr7;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer7)
       `uvm_field_object(reg_model_ptr7, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer7

