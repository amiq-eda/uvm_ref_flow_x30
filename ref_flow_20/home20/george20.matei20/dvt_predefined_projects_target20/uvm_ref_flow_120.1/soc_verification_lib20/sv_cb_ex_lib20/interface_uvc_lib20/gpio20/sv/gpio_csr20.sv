/*-------------------------------------------------------------------------
File20 name   : gpio_csr20.sv
Title20       : GPIO20 SystemVerilog20 UVM UVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV20
`define GPIO_CSR_SV20

typedef struct packed {
  bit [`GPIO_DATA_WIDTH20-1:0] bypass_mode20;
  bit [`GPIO_DATA_WIDTH20-1:0] direction_mode20;
  bit [`GPIO_DATA_WIDTH20-1:0] output_enable20;
  bit [`GPIO_DATA_WIDTH20-1:0] output_value20;
  bit [`GPIO_DATA_WIDTH20-1:0] input_value20;
  bit [`GPIO_DATA_WIDTH20-1:0] int_mask20;
  bit [`GPIO_DATA_WIDTH20-1:0] int_enable20;
  bit [`GPIO_DATA_WIDTH20-1:0] int_disable20;
  bit [`GPIO_DATA_WIDTH20-1:0] int_status20;
  bit [`GPIO_DATA_WIDTH20-1:0] int_type20;
  bit [`GPIO_DATA_WIDTH20-1:0] int_value20;
  bit [`GPIO_DATA_WIDTH20-1:0] int_on_any20;
  } gpio_csr_s20;

class gpio_csr20 extends uvm_object;

  //instance of CSRs20
  gpio_csr_s20 csr_s20;

  //randomize GPIO20 CSR20 fields
  rand bit [`GPIO_DATA_WIDTH20-1:0] bypass_mode20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] direction_mode20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] output_enable20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] output_value20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] input_value20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] int_mask20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] int_enable20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] int_disable20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] int_status20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] int_type20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] int_value20;
  rand bit [`GPIO_DATA_WIDTH20-1:0] int_on_any20;

  // this is a default constraint that could be overriden20
  // Constrain20 randomisation20 of configuration based on UVC20/RTL20 capabilities20
  constraint c_default_config20 { int_mask20         == 32'hFFFFFFFF;}

  // These20 declarations20 implement the create() and get_type_name() as well20 as enable automation20 of the
  // transfer20 fields   
  `uvm_object_utils_begin(gpio_csr20)
    `uvm_field_int(bypass_mode20,    UVM_ALL_ON)
    `uvm_field_int(direction_mode20, UVM_ALL_ON)
    `uvm_field_int(output_enable20,  UVM_ALL_ON)
    `uvm_field_int(output_value20,   UVM_ALL_ON)
    `uvm_field_int(input_value20,    UVM_ALL_ON)  
    `uvm_field_int(int_mask20,       UVM_ALL_ON)
    `uvm_field_int(int_enable20,     UVM_ALL_ON)
    `uvm_field_int(int_disable20,    UVM_ALL_ON)
    `uvm_field_int(int_status20,     UVM_ALL_ON)
    `uvm_field_int(int_type20,       UVM_ALL_ON)
    `uvm_field_int(int_value20,      UVM_ALL_ON)
    `uvm_field_int(int_on_any20,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This20 requires for registration20 of the ptp_tx_frame20   
  function new(string name = "gpio_csr20");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct20();
  endfunction 

  function void Copycfg_struct20();
    csr_s20.bypass_mode20    = bypass_mode20;
    csr_s20.direction_mode20 = direction_mode20;
    csr_s20.output_enable20  = output_enable20;
    csr_s20.output_value20   = output_value20;
    csr_s20.input_value20    = input_value20;
    csr_s20.int_mask20       = int_mask20;
    csr_s20.int_enable20     = int_enable20;
    csr_s20.int_disable20    = int_disable20;
    csr_s20.int_status20     = int_status20;
    csr_s20.int_type20       = int_type20;
    csr_s20.int_value20      = int_value20;
    csr_s20.int_on_any20     = int_on_any20;
  endfunction

endclass : gpio_csr20

`endif

