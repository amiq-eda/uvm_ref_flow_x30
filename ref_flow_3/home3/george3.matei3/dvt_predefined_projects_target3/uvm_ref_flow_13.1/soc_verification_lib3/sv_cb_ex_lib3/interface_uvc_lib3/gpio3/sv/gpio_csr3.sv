/*-------------------------------------------------------------------------
File3 name   : gpio_csr3.sv
Title3       : GPIO3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV3
`define GPIO_CSR_SV3

typedef struct packed {
  bit [`GPIO_DATA_WIDTH3-1:0] bypass_mode3;
  bit [`GPIO_DATA_WIDTH3-1:0] direction_mode3;
  bit [`GPIO_DATA_WIDTH3-1:0] output_enable3;
  bit [`GPIO_DATA_WIDTH3-1:0] output_value3;
  bit [`GPIO_DATA_WIDTH3-1:0] input_value3;
  bit [`GPIO_DATA_WIDTH3-1:0] int_mask3;
  bit [`GPIO_DATA_WIDTH3-1:0] int_enable3;
  bit [`GPIO_DATA_WIDTH3-1:0] int_disable3;
  bit [`GPIO_DATA_WIDTH3-1:0] int_status3;
  bit [`GPIO_DATA_WIDTH3-1:0] int_type3;
  bit [`GPIO_DATA_WIDTH3-1:0] int_value3;
  bit [`GPIO_DATA_WIDTH3-1:0] int_on_any3;
  } gpio_csr_s3;

class gpio_csr3 extends uvm_object;

  //instance of CSRs3
  gpio_csr_s3 csr_s3;

  //randomize GPIO3 CSR3 fields
  rand bit [`GPIO_DATA_WIDTH3-1:0] bypass_mode3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] direction_mode3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] output_enable3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] output_value3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] input_value3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] int_mask3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] int_enable3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] int_disable3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] int_status3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] int_type3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] int_value3;
  rand bit [`GPIO_DATA_WIDTH3-1:0] int_on_any3;

  // this is a default constraint that could be overriden3
  // Constrain3 randomisation3 of configuration based on UVC3/RTL3 capabilities3
  constraint c_default_config3 { int_mask3         == 32'hFFFFFFFF;}

  // These3 declarations3 implement the create() and get_type_name() as well3 as enable automation3 of the
  // transfer3 fields   
  `uvm_object_utils_begin(gpio_csr3)
    `uvm_field_int(bypass_mode3,    UVM_ALL_ON)
    `uvm_field_int(direction_mode3, UVM_ALL_ON)
    `uvm_field_int(output_enable3,  UVM_ALL_ON)
    `uvm_field_int(output_value3,   UVM_ALL_ON)
    `uvm_field_int(input_value3,    UVM_ALL_ON)  
    `uvm_field_int(int_mask3,       UVM_ALL_ON)
    `uvm_field_int(int_enable3,     UVM_ALL_ON)
    `uvm_field_int(int_disable3,    UVM_ALL_ON)
    `uvm_field_int(int_status3,     UVM_ALL_ON)
    `uvm_field_int(int_type3,       UVM_ALL_ON)
    `uvm_field_int(int_value3,      UVM_ALL_ON)
    `uvm_field_int(int_on_any3,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This3 requires for registration3 of the ptp_tx_frame3   
  function new(string name = "gpio_csr3");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct3();
  endfunction 

  function void Copycfg_struct3();
    csr_s3.bypass_mode3    = bypass_mode3;
    csr_s3.direction_mode3 = direction_mode3;
    csr_s3.output_enable3  = output_enable3;
    csr_s3.output_value3   = output_value3;
    csr_s3.input_value3    = input_value3;
    csr_s3.int_mask3       = int_mask3;
    csr_s3.int_enable3     = int_enable3;
    csr_s3.int_disable3    = int_disable3;
    csr_s3.int_status3     = int_status3;
    csr_s3.int_type3       = int_type3;
    csr_s3.int_value3      = int_value3;
    csr_s3.int_on_any3     = int_on_any3;
  endfunction

endclass : gpio_csr3

`endif

