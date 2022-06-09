/*-------------------------------------------------------------------------
File26 name   : gpio_csr26.sv
Title26       : GPIO26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV26
`define GPIO_CSR_SV26

typedef struct packed {
  bit [`GPIO_DATA_WIDTH26-1:0] bypass_mode26;
  bit [`GPIO_DATA_WIDTH26-1:0] direction_mode26;
  bit [`GPIO_DATA_WIDTH26-1:0] output_enable26;
  bit [`GPIO_DATA_WIDTH26-1:0] output_value26;
  bit [`GPIO_DATA_WIDTH26-1:0] input_value26;
  bit [`GPIO_DATA_WIDTH26-1:0] int_mask26;
  bit [`GPIO_DATA_WIDTH26-1:0] int_enable26;
  bit [`GPIO_DATA_WIDTH26-1:0] int_disable26;
  bit [`GPIO_DATA_WIDTH26-1:0] int_status26;
  bit [`GPIO_DATA_WIDTH26-1:0] int_type26;
  bit [`GPIO_DATA_WIDTH26-1:0] int_value26;
  bit [`GPIO_DATA_WIDTH26-1:0] int_on_any26;
  } gpio_csr_s26;

class gpio_csr26 extends uvm_object;

  //instance of CSRs26
  gpio_csr_s26 csr_s26;

  //randomize GPIO26 CSR26 fields
  rand bit [`GPIO_DATA_WIDTH26-1:0] bypass_mode26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] direction_mode26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] output_enable26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] output_value26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] input_value26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] int_mask26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] int_enable26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] int_disable26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] int_status26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] int_type26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] int_value26;
  rand bit [`GPIO_DATA_WIDTH26-1:0] int_on_any26;

  // this is a default constraint that could be overriden26
  // Constrain26 randomisation26 of configuration based on UVC26/RTL26 capabilities26
  constraint c_default_config26 { int_mask26         == 32'hFFFFFFFF;}

  // These26 declarations26 implement the create() and get_type_name() as well26 as enable automation26 of the
  // transfer26 fields   
  `uvm_object_utils_begin(gpio_csr26)
    `uvm_field_int(bypass_mode26,    UVM_ALL_ON)
    `uvm_field_int(direction_mode26, UVM_ALL_ON)
    `uvm_field_int(output_enable26,  UVM_ALL_ON)
    `uvm_field_int(output_value26,   UVM_ALL_ON)
    `uvm_field_int(input_value26,    UVM_ALL_ON)  
    `uvm_field_int(int_mask26,       UVM_ALL_ON)
    `uvm_field_int(int_enable26,     UVM_ALL_ON)
    `uvm_field_int(int_disable26,    UVM_ALL_ON)
    `uvm_field_int(int_status26,     UVM_ALL_ON)
    `uvm_field_int(int_type26,       UVM_ALL_ON)
    `uvm_field_int(int_value26,      UVM_ALL_ON)
    `uvm_field_int(int_on_any26,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This26 requires for registration26 of the ptp_tx_frame26   
  function new(string name = "gpio_csr26");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct26();
  endfunction 

  function void Copycfg_struct26();
    csr_s26.bypass_mode26    = bypass_mode26;
    csr_s26.direction_mode26 = direction_mode26;
    csr_s26.output_enable26  = output_enable26;
    csr_s26.output_value26   = output_value26;
    csr_s26.input_value26    = input_value26;
    csr_s26.int_mask26       = int_mask26;
    csr_s26.int_enable26     = int_enable26;
    csr_s26.int_disable26    = int_disable26;
    csr_s26.int_status26     = int_status26;
    csr_s26.int_type26       = int_type26;
    csr_s26.int_value26      = int_value26;
    csr_s26.int_on_any26     = int_on_any26;
  endfunction

endclass : gpio_csr26

`endif

