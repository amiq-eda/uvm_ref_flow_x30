/*-------------------------------------------------------------------------
File7 name   : gpio_csr7.sv
Title7       : GPIO7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV7
`define GPIO_CSR_SV7

typedef struct packed {
  bit [`GPIO_DATA_WIDTH7-1:0] bypass_mode7;
  bit [`GPIO_DATA_WIDTH7-1:0] direction_mode7;
  bit [`GPIO_DATA_WIDTH7-1:0] output_enable7;
  bit [`GPIO_DATA_WIDTH7-1:0] output_value7;
  bit [`GPIO_DATA_WIDTH7-1:0] input_value7;
  bit [`GPIO_DATA_WIDTH7-1:0] int_mask7;
  bit [`GPIO_DATA_WIDTH7-1:0] int_enable7;
  bit [`GPIO_DATA_WIDTH7-1:0] int_disable7;
  bit [`GPIO_DATA_WIDTH7-1:0] int_status7;
  bit [`GPIO_DATA_WIDTH7-1:0] int_type7;
  bit [`GPIO_DATA_WIDTH7-1:0] int_value7;
  bit [`GPIO_DATA_WIDTH7-1:0] int_on_any7;
  } gpio_csr_s7;

class gpio_csr7 extends uvm_object;

  //instance of CSRs7
  gpio_csr_s7 csr_s7;

  //randomize GPIO7 CSR7 fields
  rand bit [`GPIO_DATA_WIDTH7-1:0] bypass_mode7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] direction_mode7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] output_enable7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] output_value7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] input_value7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] int_mask7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] int_enable7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] int_disable7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] int_status7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] int_type7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] int_value7;
  rand bit [`GPIO_DATA_WIDTH7-1:0] int_on_any7;

  // this is a default constraint that could be overriden7
  // Constrain7 randomisation7 of configuration based on UVC7/RTL7 capabilities7
  constraint c_default_config7 { int_mask7         == 32'hFFFFFFFF;}

  // These7 declarations7 implement the create() and get_type_name() as well7 as enable automation7 of the
  // transfer7 fields   
  `uvm_object_utils_begin(gpio_csr7)
    `uvm_field_int(bypass_mode7,    UVM_ALL_ON)
    `uvm_field_int(direction_mode7, UVM_ALL_ON)
    `uvm_field_int(output_enable7,  UVM_ALL_ON)
    `uvm_field_int(output_value7,   UVM_ALL_ON)
    `uvm_field_int(input_value7,    UVM_ALL_ON)  
    `uvm_field_int(int_mask7,       UVM_ALL_ON)
    `uvm_field_int(int_enable7,     UVM_ALL_ON)
    `uvm_field_int(int_disable7,    UVM_ALL_ON)
    `uvm_field_int(int_status7,     UVM_ALL_ON)
    `uvm_field_int(int_type7,       UVM_ALL_ON)
    `uvm_field_int(int_value7,      UVM_ALL_ON)
    `uvm_field_int(int_on_any7,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This7 requires for registration7 of the ptp_tx_frame7   
  function new(string name = "gpio_csr7");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct7();
  endfunction 

  function void Copycfg_struct7();
    csr_s7.bypass_mode7    = bypass_mode7;
    csr_s7.direction_mode7 = direction_mode7;
    csr_s7.output_enable7  = output_enable7;
    csr_s7.output_value7   = output_value7;
    csr_s7.input_value7    = input_value7;
    csr_s7.int_mask7       = int_mask7;
    csr_s7.int_enable7     = int_enable7;
    csr_s7.int_disable7    = int_disable7;
    csr_s7.int_status7     = int_status7;
    csr_s7.int_type7       = int_type7;
    csr_s7.int_value7      = int_value7;
    csr_s7.int_on_any7     = int_on_any7;
  endfunction

endclass : gpio_csr7

`endif

