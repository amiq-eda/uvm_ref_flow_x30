/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_vir_sequencer6.sv
Title6       : Virtual sequencer
Project6     :
Created6     :
Description6 : This6 file implements6 the Virtual sequencer for APB6-UART6 environment6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer6 extends uvm_sequencer;

    ahb_pkg6::ahb_master_sequencer6 ahb_seqr6;
    uart_pkg6::uart_sequencer6 uart0_seqr6;
    uart_pkg6::uart_sequencer6 uart1_seqr6;
    spi_sequencer6 spi0_seqr6;
    gpio_sequencer6 gpio0_seqr6;
    apb_ss_reg_model_c6 reg_model_ptr6;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer6)
       `uvm_field_object(reg_model_ptr6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer6

