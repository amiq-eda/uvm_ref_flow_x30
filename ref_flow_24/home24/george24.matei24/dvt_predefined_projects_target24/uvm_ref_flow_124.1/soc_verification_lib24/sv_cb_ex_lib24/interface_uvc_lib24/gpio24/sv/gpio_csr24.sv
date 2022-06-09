/*-------------------------------------------------------------------------
File24 name   : gpio_csr24.sv
Title24       : GPIO24 SystemVerilog24 UVM UVC24
Project24     : SystemVerilog24 UVM Cluster24 Level24 Verification24
Created24     :
Description24 : 
Notes24       :  
---------------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV24
`define GPIO_CSR_SV24

typedef struct packed {
  bit [`GPIO_DATA_WIDTH24-1:0] bypass_mode24;
  bit [`GPIO_DATA_WIDTH24-1:0] direction_mode24;
  bit [`GPIO_DATA_WIDTH24-1:0] output_enable24;
  bit [`GPIO_DATA_WIDTH24-1:0] output_value24;
  bit [`GPIO_DATA_WIDTH24-1:0] input_value24;
  bit [`GPIO_DATA_WIDTH24-1:0] int_mask24;
  bit [`GPIO_DATA_WIDTH24-1:0] int_enable24;
  bit [`GPIO_DATA_WIDTH24-1:0] int_disable24;
  bit [`GPIO_DATA_WIDTH24-1:0] int_status24;
  bit [`GPIO_DATA_WIDTH24-1:0] int_type24;
  bit [`GPIO_DATA_WIDTH24-1:0] int_value24;
  bit [`GPIO_DATA_WIDTH24-1:0] int_on_any24;
  } gpio_csr_s24;

class gpio_csr24 extends uvm_object;

  //instance of CSRs24
  gpio_csr_s24 csr_s24;

  //randomize GPIO24 CSR24 fields
  rand bit [`GPIO_DATA_WIDTH24-1:0] bypass_mode24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] direction_mode24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] output_enable24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] output_value24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] input_value24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] int_mask24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] int_enable24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] int_disable24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] int_status24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] int_type24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] int_value24;
  rand bit [`GPIO_DATA_WIDTH24-1:0] int_on_any24;

  // this is a default constraint that could be overriden24
  // Constrain24 randomisation24 of configuration based on UVC24/RTL24 capabilities24
  constraint c_default_config24 { int_mask24         == 32'hFFFFFFFF;}

  // These24 declarations24 implement the create() and get_type_name() as well24 as enable automation24 of the
  // transfer24 fields   
  `uvm_object_utils_begin(gpio_csr24)
    `uvm_field_int(bypass_mode24,    UVM_ALL_ON)
    `uvm_field_int(direction_mode24, UVM_ALL_ON)
    `uvm_field_int(output_enable24,  UVM_ALL_ON)
    `uvm_field_int(output_value24,   UVM_ALL_ON)
    `uvm_field_int(input_value24,    UVM_ALL_ON)  
    `uvm_field_int(int_mask24,       UVM_ALL_ON)
    `uvm_field_int(int_enable24,     UVM_ALL_ON)
    `uvm_field_int(int_disable24,    UVM_ALL_ON)
    `uvm_field_int(int_status24,     UVM_ALL_ON)
    `uvm_field_int(int_type24,       UVM_ALL_ON)
    `uvm_field_int(int_value24,      UVM_ALL_ON)
    `uvm_field_int(int_on_any24,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This24 requires for registration24 of the ptp_tx_frame24   
  function new(string name = "gpio_csr24");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct24();
  endfunction 

  function void Copycfg_struct24();
    csr_s24.bypass_mode24    = bypass_mode24;
    csr_s24.direction_mode24 = direction_mode24;
    csr_s24.output_enable24  = output_enable24;
    csr_s24.output_value24   = output_value24;
    csr_s24.input_value24    = input_value24;
    csr_s24.int_mask24       = int_mask24;
    csr_s24.int_enable24     = int_enable24;
    csr_s24.int_disable24    = int_disable24;
    csr_s24.int_status24     = int_status24;
    csr_s24.int_type24       = int_type24;
    csr_s24.int_value24      = int_value24;
    csr_s24.int_on_any24     = int_on_any24;
  endfunction

endclass : gpio_csr24

`endif

