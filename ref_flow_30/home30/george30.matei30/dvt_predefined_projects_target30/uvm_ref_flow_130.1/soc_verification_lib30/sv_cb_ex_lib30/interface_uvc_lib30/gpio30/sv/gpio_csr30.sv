/*-------------------------------------------------------------------------
File30 name   : gpio_csr30.sv
Title30       : GPIO30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV30
`define GPIO_CSR_SV30

typedef struct packed {
  bit [`GPIO_DATA_WIDTH30-1:0] bypass_mode30;
  bit [`GPIO_DATA_WIDTH30-1:0] direction_mode30;
  bit [`GPIO_DATA_WIDTH30-1:0] output_enable30;
  bit [`GPIO_DATA_WIDTH30-1:0] output_value30;
  bit [`GPIO_DATA_WIDTH30-1:0] input_value30;
  bit [`GPIO_DATA_WIDTH30-1:0] int_mask30;
  bit [`GPIO_DATA_WIDTH30-1:0] int_enable30;
  bit [`GPIO_DATA_WIDTH30-1:0] int_disable30;
  bit [`GPIO_DATA_WIDTH30-1:0] int_status30;
  bit [`GPIO_DATA_WIDTH30-1:0] int_type30;
  bit [`GPIO_DATA_WIDTH30-1:0] int_value30;
  bit [`GPIO_DATA_WIDTH30-1:0] int_on_any30;
  } gpio_csr_s30;

class gpio_csr30 extends uvm_object;

  //instance of CSRs30
  gpio_csr_s30 csr_s30;

  //randomize GPIO30 CSR30 fields
  rand bit [`GPIO_DATA_WIDTH30-1:0] bypass_mode30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] direction_mode30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] output_enable30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] output_value30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] input_value30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] int_mask30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] int_enable30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] int_disable30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] int_status30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] int_type30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] int_value30;
  rand bit [`GPIO_DATA_WIDTH30-1:0] int_on_any30;

  // this is a default constraint that could be overriden30
  // Constrain30 randomisation30 of configuration based on UVC30/RTL30 capabilities30
  constraint c_default_config30 { int_mask30         == 32'hFFFFFFFF;}

  // These30 declarations30 implement the create() and get_type_name() as well30 as enable automation30 of the
  // transfer30 fields   
  `uvm_object_utils_begin(gpio_csr30)
    `uvm_field_int(bypass_mode30,    UVM_ALL_ON)
    `uvm_field_int(direction_mode30, UVM_ALL_ON)
    `uvm_field_int(output_enable30,  UVM_ALL_ON)
    `uvm_field_int(output_value30,   UVM_ALL_ON)
    `uvm_field_int(input_value30,    UVM_ALL_ON)  
    `uvm_field_int(int_mask30,       UVM_ALL_ON)
    `uvm_field_int(int_enable30,     UVM_ALL_ON)
    `uvm_field_int(int_disable30,    UVM_ALL_ON)
    `uvm_field_int(int_status30,     UVM_ALL_ON)
    `uvm_field_int(int_type30,       UVM_ALL_ON)
    `uvm_field_int(int_value30,      UVM_ALL_ON)
    `uvm_field_int(int_on_any30,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This30 requires for registration30 of the ptp_tx_frame30   
  function new(string name = "gpio_csr30");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct30();
  endfunction 

  function void Copycfg_struct30();
    csr_s30.bypass_mode30    = bypass_mode30;
    csr_s30.direction_mode30 = direction_mode30;
    csr_s30.output_enable30  = output_enable30;
    csr_s30.output_value30   = output_value30;
    csr_s30.input_value30    = input_value30;
    csr_s30.int_mask30       = int_mask30;
    csr_s30.int_enable30     = int_enable30;
    csr_s30.int_disable30    = int_disable30;
    csr_s30.int_status30     = int_status30;
    csr_s30.int_type30       = int_type30;
    csr_s30.int_value30      = int_value30;
    csr_s30.int_on_any30     = int_on_any30;
  endfunction

endclass : gpio_csr30

`endif

