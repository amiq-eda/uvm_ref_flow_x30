/*-------------------------------------------------------------------------
File8 name   : gpio_csr8.sv
Title8       : GPIO8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV8
`define GPIO_CSR_SV8

typedef struct packed {
  bit [`GPIO_DATA_WIDTH8-1:0] bypass_mode8;
  bit [`GPIO_DATA_WIDTH8-1:0] direction_mode8;
  bit [`GPIO_DATA_WIDTH8-1:0] output_enable8;
  bit [`GPIO_DATA_WIDTH8-1:0] output_value8;
  bit [`GPIO_DATA_WIDTH8-1:0] input_value8;
  bit [`GPIO_DATA_WIDTH8-1:0] int_mask8;
  bit [`GPIO_DATA_WIDTH8-1:0] int_enable8;
  bit [`GPIO_DATA_WIDTH8-1:0] int_disable8;
  bit [`GPIO_DATA_WIDTH8-1:0] int_status8;
  bit [`GPIO_DATA_WIDTH8-1:0] int_type8;
  bit [`GPIO_DATA_WIDTH8-1:0] int_value8;
  bit [`GPIO_DATA_WIDTH8-1:0] int_on_any8;
  } gpio_csr_s8;

class gpio_csr8 extends uvm_object;

  //instance of CSRs8
  gpio_csr_s8 csr_s8;

  //randomize GPIO8 CSR8 fields
  rand bit [`GPIO_DATA_WIDTH8-1:0] bypass_mode8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] direction_mode8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] output_enable8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] output_value8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] input_value8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] int_mask8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] int_enable8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] int_disable8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] int_status8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] int_type8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] int_value8;
  rand bit [`GPIO_DATA_WIDTH8-1:0] int_on_any8;

  // this is a default constraint that could be overriden8
  // Constrain8 randomisation8 of configuration based on UVC8/RTL8 capabilities8
  constraint c_default_config8 { int_mask8         == 32'hFFFFFFFF;}

  // These8 declarations8 implement the create() and get_type_name() as well8 as enable automation8 of the
  // transfer8 fields   
  `uvm_object_utils_begin(gpio_csr8)
    `uvm_field_int(bypass_mode8,    UVM_ALL_ON)
    `uvm_field_int(direction_mode8, UVM_ALL_ON)
    `uvm_field_int(output_enable8,  UVM_ALL_ON)
    `uvm_field_int(output_value8,   UVM_ALL_ON)
    `uvm_field_int(input_value8,    UVM_ALL_ON)  
    `uvm_field_int(int_mask8,       UVM_ALL_ON)
    `uvm_field_int(int_enable8,     UVM_ALL_ON)
    `uvm_field_int(int_disable8,    UVM_ALL_ON)
    `uvm_field_int(int_status8,     UVM_ALL_ON)
    `uvm_field_int(int_type8,       UVM_ALL_ON)
    `uvm_field_int(int_value8,      UVM_ALL_ON)
    `uvm_field_int(int_on_any8,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This8 requires for registration8 of the ptp_tx_frame8   
  function new(string name = "gpio_csr8");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct8();
  endfunction 

  function void Copycfg_struct8();
    csr_s8.bypass_mode8    = bypass_mode8;
    csr_s8.direction_mode8 = direction_mode8;
    csr_s8.output_enable8  = output_enable8;
    csr_s8.output_value8   = output_value8;
    csr_s8.input_value8    = input_value8;
    csr_s8.int_mask8       = int_mask8;
    csr_s8.int_enable8     = int_enable8;
    csr_s8.int_disable8    = int_disable8;
    csr_s8.int_status8     = int_status8;
    csr_s8.int_type8       = int_type8;
    csr_s8.int_value8      = int_value8;
    csr_s8.int_on_any8     = int_on_any8;
  endfunction

endclass : gpio_csr8

`endif

