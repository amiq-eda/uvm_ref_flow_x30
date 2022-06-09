/*-------------------------------------------------------------------------
File10 name   : gpio_csr10.sv
Title10       : GPIO10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV10
`define GPIO_CSR_SV10

typedef struct packed {
  bit [`GPIO_DATA_WIDTH10-1:0] bypass_mode10;
  bit [`GPIO_DATA_WIDTH10-1:0] direction_mode10;
  bit [`GPIO_DATA_WIDTH10-1:0] output_enable10;
  bit [`GPIO_DATA_WIDTH10-1:0] output_value10;
  bit [`GPIO_DATA_WIDTH10-1:0] input_value10;
  bit [`GPIO_DATA_WIDTH10-1:0] int_mask10;
  bit [`GPIO_DATA_WIDTH10-1:0] int_enable10;
  bit [`GPIO_DATA_WIDTH10-1:0] int_disable10;
  bit [`GPIO_DATA_WIDTH10-1:0] int_status10;
  bit [`GPIO_DATA_WIDTH10-1:0] int_type10;
  bit [`GPIO_DATA_WIDTH10-1:0] int_value10;
  bit [`GPIO_DATA_WIDTH10-1:0] int_on_any10;
  } gpio_csr_s10;

class gpio_csr10 extends uvm_object;

  //instance of CSRs10
  gpio_csr_s10 csr_s10;

  //randomize GPIO10 CSR10 fields
  rand bit [`GPIO_DATA_WIDTH10-1:0] bypass_mode10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] direction_mode10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] output_enable10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] output_value10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] input_value10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] int_mask10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] int_enable10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] int_disable10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] int_status10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] int_type10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] int_value10;
  rand bit [`GPIO_DATA_WIDTH10-1:0] int_on_any10;

  // this is a default constraint that could be overriden10
  // Constrain10 randomisation10 of configuration based on UVC10/RTL10 capabilities10
  constraint c_default_config10 { int_mask10         == 32'hFFFFFFFF;}

  // These10 declarations10 implement the create() and get_type_name() as well10 as enable automation10 of the
  // transfer10 fields   
  `uvm_object_utils_begin(gpio_csr10)
    `uvm_field_int(bypass_mode10,    UVM_ALL_ON)
    `uvm_field_int(direction_mode10, UVM_ALL_ON)
    `uvm_field_int(output_enable10,  UVM_ALL_ON)
    `uvm_field_int(output_value10,   UVM_ALL_ON)
    `uvm_field_int(input_value10,    UVM_ALL_ON)  
    `uvm_field_int(int_mask10,       UVM_ALL_ON)
    `uvm_field_int(int_enable10,     UVM_ALL_ON)
    `uvm_field_int(int_disable10,    UVM_ALL_ON)
    `uvm_field_int(int_status10,     UVM_ALL_ON)
    `uvm_field_int(int_type10,       UVM_ALL_ON)
    `uvm_field_int(int_value10,      UVM_ALL_ON)
    `uvm_field_int(int_on_any10,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This10 requires for registration10 of the ptp_tx_frame10   
  function new(string name = "gpio_csr10");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct10();
  endfunction 

  function void Copycfg_struct10();
    csr_s10.bypass_mode10    = bypass_mode10;
    csr_s10.direction_mode10 = direction_mode10;
    csr_s10.output_enable10  = output_enable10;
    csr_s10.output_value10   = output_value10;
    csr_s10.input_value10    = input_value10;
    csr_s10.int_mask10       = int_mask10;
    csr_s10.int_enable10     = int_enable10;
    csr_s10.int_disable10    = int_disable10;
    csr_s10.int_status10     = int_status10;
    csr_s10.int_type10       = int_type10;
    csr_s10.int_value10      = int_value10;
    csr_s10.int_on_any10     = int_on_any10;
  endfunction

endclass : gpio_csr10

`endif

