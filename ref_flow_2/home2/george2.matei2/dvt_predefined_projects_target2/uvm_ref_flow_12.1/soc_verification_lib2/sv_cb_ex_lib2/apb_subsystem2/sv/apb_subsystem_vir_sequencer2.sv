/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_vir_sequencer2.sv
Title2       : Virtual sequencer
Project2     :
Created2     :
Description2 : This2 file implements2 the Virtual sequencer for APB2-UART2 environment2
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer2 extends uvm_sequencer;

    ahb_pkg2::ahb_master_sequencer2 ahb_seqr2;
    uart_pkg2::uart_sequencer2 uart0_seqr2;
    uart_pkg2::uart_sequencer2 uart1_seqr2;
    spi_sequencer2 spi0_seqr2;
    gpio_sequencer2 gpio0_seqr2;
    apb_ss_reg_model_c2 reg_model_ptr2;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer2)
       `uvm_field_object(reg_model_ptr2, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer2

