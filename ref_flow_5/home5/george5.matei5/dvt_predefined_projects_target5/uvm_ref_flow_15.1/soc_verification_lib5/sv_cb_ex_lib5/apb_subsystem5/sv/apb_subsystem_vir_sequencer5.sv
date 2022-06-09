/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_vir_sequencer5.sv
Title5       : Virtual sequencer
Project5     :
Created5     :
Description5 : This5 file implements5 the Virtual sequencer for APB5-UART5 environment5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer5 extends uvm_sequencer;

    ahb_pkg5::ahb_master_sequencer5 ahb_seqr5;
    uart_pkg5::uart_sequencer5 uart0_seqr5;
    uart_pkg5::uart_sequencer5 uart1_seqr5;
    spi_sequencer5 spi0_seqr5;
    gpio_sequencer5 gpio0_seqr5;
    apb_ss_reg_model_c5 reg_model_ptr5;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer5)
       `uvm_field_object(reg_model_ptr5, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer5

