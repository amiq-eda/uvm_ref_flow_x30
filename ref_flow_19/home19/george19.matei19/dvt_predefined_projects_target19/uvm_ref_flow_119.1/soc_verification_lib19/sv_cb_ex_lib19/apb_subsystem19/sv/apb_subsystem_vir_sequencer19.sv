/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_vir_sequencer19.sv
Title19       : Virtual sequencer
Project19     :
Created19     :
Description19 : This19 file implements19 the Virtual sequencer for APB19-UART19 environment19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer19 extends uvm_sequencer;

    ahb_pkg19::ahb_master_sequencer19 ahb_seqr19;
    uart_pkg19::uart_sequencer19 uart0_seqr19;
    uart_pkg19::uart_sequencer19 uart1_seqr19;
    spi_sequencer19 spi0_seqr19;
    gpio_sequencer19 gpio0_seqr19;
    apb_ss_reg_model_c19 reg_model_ptr19;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer19)
       `uvm_field_object(reg_model_ptr19, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer19

