/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_vir_sequencer13.sv
Title13       : Virtual sequencer
Project13     :
Created13     :
Description13 : This13 file implements13 the Virtual sequencer for APB13-UART13 environment13
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer13 extends uvm_sequencer;

    ahb_pkg13::ahb_master_sequencer13 ahb_seqr13;
    uart_pkg13::uart_sequencer13 uart0_seqr13;
    uart_pkg13::uart_sequencer13 uart1_seqr13;
    spi_sequencer13 spi0_seqr13;
    gpio_sequencer13 gpio0_seqr13;
    apb_ss_reg_model_c13 reg_model_ptr13;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer13)
       `uvm_field_object(reg_model_ptr13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer13

