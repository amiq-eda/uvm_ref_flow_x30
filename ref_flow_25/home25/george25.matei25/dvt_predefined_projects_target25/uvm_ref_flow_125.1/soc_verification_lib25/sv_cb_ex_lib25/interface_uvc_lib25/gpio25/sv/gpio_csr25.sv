/*-------------------------------------------------------------------------
File25 name   : gpio_csr25.sv
Title25       : GPIO25 SystemVerilog25 UVM UVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV25
`define GPIO_CSR_SV25

typedef struct packed {
  bit [`GPIO_DATA_WIDTH25-1:0] bypass_mode25;
  bit [`GPIO_DATA_WIDTH25-1:0] direction_mode25;
  bit [`GPIO_DATA_WIDTH25-1:0] output_enable25;
  bit [`GPIO_DATA_WIDTH25-1:0] output_value25;
  bit [`GPIO_DATA_WIDTH25-1:0] input_value25;
  bit [`GPIO_DATA_WIDTH25-1:0] int_mask25;
  bit [`GPIO_DATA_WIDTH25-1:0] int_enable25;
  bit [`GPIO_DATA_WIDTH25-1:0] int_disable25;
  bit [`GPIO_DATA_WIDTH25-1:0] int_status25;
  bit [`GPIO_DATA_WIDTH25-1:0] int_type25;
  bit [`GPIO_DATA_WIDTH25-1:0] int_value25;
  bit [`GPIO_DATA_WIDTH25-1:0] int_on_any25;
  } gpio_csr_s25;

class gpio_csr25 extends uvm_object;

  //instance of CSRs25
  gpio_csr_s25 csr_s25;

  //randomize GPIO25 CSR25 fields
  rand bit [`GPIO_DATA_WIDTH25-1:0] bypass_mode25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] direction_mode25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] output_enable25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] output_value25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] input_value25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] int_mask25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] int_enable25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] int_disable25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] int_status25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] int_type25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] int_value25;
  rand bit [`GPIO_DATA_WIDTH25-1:0] int_on_any25;

  // this is a default constraint that could be overriden25
  // Constrain25 randomisation25 of configuration based on UVC25/RTL25 capabilities25
  constraint c_default_config25 { int_mask25         == 32'hFFFFFFFF;}

  // These25 declarations25 implement the create() and get_type_name() as well25 as enable automation25 of the
  // transfer25 fields   
  `uvm_object_utils_begin(gpio_csr25)
    `uvm_field_int(bypass_mode25,    UVM_ALL_ON)
    `uvm_field_int(direction_mode25, UVM_ALL_ON)
    `uvm_field_int(output_enable25,  UVM_ALL_ON)
    `uvm_field_int(output_value25,   UVM_ALL_ON)
    `uvm_field_int(input_value25,    UVM_ALL_ON)  
    `uvm_field_int(int_mask25,       UVM_ALL_ON)
    `uvm_field_int(int_enable25,     UVM_ALL_ON)
    `uvm_field_int(int_disable25,    UVM_ALL_ON)
    `uvm_field_int(int_status25,     UVM_ALL_ON)
    `uvm_field_int(int_type25,       UVM_ALL_ON)
    `uvm_field_int(int_value25,      UVM_ALL_ON)
    `uvm_field_int(int_on_any25,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This25 requires for registration25 of the ptp_tx_frame25   
  function new(string name = "gpio_csr25");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct25();
  endfunction 

  function void Copycfg_struct25();
    csr_s25.bypass_mode25    = bypass_mode25;
    csr_s25.direction_mode25 = direction_mode25;
    csr_s25.output_enable25  = output_enable25;
    csr_s25.output_value25   = output_value25;
    csr_s25.input_value25    = input_value25;
    csr_s25.int_mask25       = int_mask25;
    csr_s25.int_enable25     = int_enable25;
    csr_s25.int_disable25    = int_disable25;
    csr_s25.int_status25     = int_status25;
    csr_s25.int_type25       = int_type25;
    csr_s25.int_value25      = int_value25;
    csr_s25.int_on_any25     = int_on_any25;
  endfunction

endclass : gpio_csr25

`endif

