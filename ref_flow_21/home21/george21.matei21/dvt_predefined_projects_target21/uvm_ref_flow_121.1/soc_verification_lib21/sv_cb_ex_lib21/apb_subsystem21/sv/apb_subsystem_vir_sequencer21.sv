/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_vir_sequencer21.sv
Title21       : Virtual sequencer
Project21     :
Created21     :
Description21 : This21 file implements21 the Virtual sequencer for APB21-UART21 environment21
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer21 extends uvm_sequencer;

    ahb_pkg21::ahb_master_sequencer21 ahb_seqr21;
    uart_pkg21::uart_sequencer21 uart0_seqr21;
    uart_pkg21::uart_sequencer21 uart1_seqr21;
    spi_sequencer21 spi0_seqr21;
    gpio_sequencer21 gpio0_seqr21;
    apb_ss_reg_model_c21 reg_model_ptr21;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer21)
       `uvm_field_object(reg_model_ptr21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer21

