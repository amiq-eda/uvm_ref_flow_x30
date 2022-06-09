/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_vir_sequencer17.sv
Title17       : Virtual sequencer
Project17     :
Created17     :
Description17 : This17 file implements17 the Virtual sequencer for APB17-UART17 environment17
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer17 extends uvm_sequencer;

    ahb_pkg17::ahb_master_sequencer17 ahb_seqr17;
    uart_pkg17::uart_sequencer17 uart0_seqr17;
    uart_pkg17::uart_sequencer17 uart1_seqr17;
    spi_sequencer17 spi0_seqr17;
    gpio_sequencer17 gpio0_seqr17;
    apb_ss_reg_model_c17 reg_model_ptr17;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer17)
       `uvm_field_object(reg_model_ptr17, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer17

