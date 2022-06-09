/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_vir_sequencer18.sv
Title18       : Virtual sequencer
Project18     :
Created18     :
Description18 : This18 file implements18 the Virtual sequencer for APB18-UART18 environment18
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

class apb_subsystem_virtual_sequencer18 extends uvm_sequencer;

    ahb_pkg18::ahb_master_sequencer18 ahb_seqr18;
    uart_pkg18::uart_sequencer18 uart0_seqr18;
    uart_pkg18::uart_sequencer18 uart1_seqr18;
    spi_sequencer18 spi0_seqr18;
    gpio_sequencer18 gpio0_seqr18;
    apb_ss_reg_model_c18 reg_model_ptr18;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(apb_subsystem_virtual_sequencer18)
       `uvm_field_object(reg_model_ptr18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : apb_subsystem_virtual_sequencer18

