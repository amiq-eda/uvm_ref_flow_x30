/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_vir_sequencer20.sv
Title20       : Virtual sequencer
Project20     :
Created20     :
Description20 : This20 file implements20 the Virtual sequencer for APB20-UART20 environment20
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer20 extends uvm_sequencer;

    ahb_pkg20::ahb_master_sequencer20 ahb_seqr20;
    uart_pkg20::uart_sequencer20 uart0_seqr20;
    uart_pkg20::uart_sequencer20 uart1_seqr20;
    spi_sequencer20 spi0_seqr20;
    gpio_sequencer20 gpio0_seqr20;
    apb_ss_reg_model_c20 reg_model_ptr20;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer20)
       `uvm_field_object(reg_model_ptr20, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer20

