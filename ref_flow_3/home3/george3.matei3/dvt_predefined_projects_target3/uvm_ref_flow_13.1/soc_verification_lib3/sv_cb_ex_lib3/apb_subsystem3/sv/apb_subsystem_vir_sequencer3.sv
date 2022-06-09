/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_vir_sequencer3.sv
Title3       : Virtual sequencer
Project3     :
Created3     :
Description3 : This3 file implements3 the Virtual sequencer for APB3-UART3 environment3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer3 extends uvm_sequencer;

    ahb_pkg3::ahb_master_sequencer3 ahb_seqr3;
    uart_pkg3::uart_sequencer3 uart0_seqr3;
    uart_pkg3::uart_sequencer3 uart1_seqr3;
    spi_sequencer3 spi0_seqr3;
    gpio_sequencer3 gpio0_seqr3;
    apb_ss_reg_model_c3 reg_model_ptr3;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer3)
       `uvm_field_object(reg_model_ptr3, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer3

