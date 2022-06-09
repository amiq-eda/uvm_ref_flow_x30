/*-------------------------------------------------------------------------
File27 name   : gpio_csr27.sv
Title27       : GPIO27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV27
`define GPIO_CSR_SV27

typedef struct packed {
  bit [`GPIO_DATA_WIDTH27-1:0] bypass_mode27;
  bit [`GPIO_DATA_WIDTH27-1:0] direction_mode27;
  bit [`GPIO_DATA_WIDTH27-1:0] output_enable27;
  bit [`GPIO_DATA_WIDTH27-1:0] output_value27;
  bit [`GPIO_DATA_WIDTH27-1:0] input_value27;
  bit [`GPIO_DATA_WIDTH27-1:0] int_mask27;
  bit [`GPIO_DATA_WIDTH27-1:0] int_enable27;
  bit [`GPIO_DATA_WIDTH27-1:0] int_disable27;
  bit [`GPIO_DATA_WIDTH27-1:0] int_status27;
  bit [`GPIO_DATA_WIDTH27-1:0] int_type27;
  bit [`GPIO_DATA_WIDTH27-1:0] int_value27;
  bit [`GPIO_DATA_WIDTH27-1:0] int_on_any27;
  } gpio_csr_s27;

class gpio_csr27 extends uvm_object;

  //instance of CSRs27
  gpio_csr_s27 csr_s27;

  //randomize GPIO27 CSR27 fields
  rand bit [`GPIO_DATA_WIDTH27-1:0] bypass_mode27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] direction_mode27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] output_enable27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] output_value27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] input_value27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] int_mask27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] int_enable27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] int_disable27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] int_status27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] int_type27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] int_value27;
  rand bit [`GPIO_DATA_WIDTH27-1:0] int_on_any27;

  // this is a default constraint that could be overriden27
  // Constrain27 randomisation27 of configuration based on UVC27/RTL27 capabilities27
  constraint c_default_config27 { int_mask27         == 32'hFFFFFFFF;}

  // These27 declarations27 implement the create() and get_type_name() as well27 as enable automation27 of the
  // transfer27 fields   
  `uvm_object_utils_begin(gpio_csr27)
    `uvm_field_int(bypass_mode27,    UVM_ALL_ON)
    `uvm_field_int(direction_mode27, UVM_ALL_ON)
    `uvm_field_int(output_enable27,  UVM_ALL_ON)
    `uvm_field_int(output_value27,   UVM_ALL_ON)
    `uvm_field_int(input_value27,    UVM_ALL_ON)  
    `uvm_field_int(int_mask27,       UVM_ALL_ON)
    `uvm_field_int(int_enable27,     UVM_ALL_ON)
    `uvm_field_int(int_disable27,    UVM_ALL_ON)
    `uvm_field_int(int_status27,     UVM_ALL_ON)
    `uvm_field_int(int_type27,       UVM_ALL_ON)
    `uvm_field_int(int_value27,      UVM_ALL_ON)
    `uvm_field_int(int_on_any27,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This27 requires for registration27 of the ptp_tx_frame27   
  function new(string name = "gpio_csr27");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct27();
  endfunction 

  function void Copycfg_struct27();
    csr_s27.bypass_mode27    = bypass_mode27;
    csr_s27.direction_mode27 = direction_mode27;
    csr_s27.output_enable27  = output_enable27;
    csr_s27.output_value27   = output_value27;
    csr_s27.input_value27    = input_value27;
    csr_s27.int_mask27       = int_mask27;
    csr_s27.int_enable27     = int_enable27;
    csr_s27.int_disable27    = int_disable27;
    csr_s27.int_status27     = int_status27;
    csr_s27.int_type27       = int_type27;
    csr_s27.int_value27      = int_value27;
    csr_s27.int_on_any27     = int_on_any27;
  endfunction

endclass : gpio_csr27

`endif

