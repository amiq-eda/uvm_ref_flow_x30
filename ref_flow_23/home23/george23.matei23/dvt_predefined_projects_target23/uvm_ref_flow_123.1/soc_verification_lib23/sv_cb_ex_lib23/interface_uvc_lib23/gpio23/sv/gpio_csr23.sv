/*-------------------------------------------------------------------------
File23 name   : gpio_csr23.sv
Title23       : GPIO23 SystemVerilog23 UVM UVC23
Project23     : SystemVerilog23 UVM Cluster23 Level23 Verification23
Created23     :
Description23 : 
Notes23       :  
---------------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV23
`define GPIO_CSR_SV23

typedef struct packed {
  bit [`GPIO_DATA_WIDTH23-1:0] bypass_mode23;
  bit [`GPIO_DATA_WIDTH23-1:0] direction_mode23;
  bit [`GPIO_DATA_WIDTH23-1:0] output_enable23;
  bit [`GPIO_DATA_WIDTH23-1:0] output_value23;
  bit [`GPIO_DATA_WIDTH23-1:0] input_value23;
  bit [`GPIO_DATA_WIDTH23-1:0] int_mask23;
  bit [`GPIO_DATA_WIDTH23-1:0] int_enable23;
  bit [`GPIO_DATA_WIDTH23-1:0] int_disable23;
  bit [`GPIO_DATA_WIDTH23-1:0] int_status23;
  bit [`GPIO_DATA_WIDTH23-1:0] int_type23;
  bit [`GPIO_DATA_WIDTH23-1:0] int_value23;
  bit [`GPIO_DATA_WIDTH23-1:0] int_on_any23;
  } gpio_csr_s23;

class gpio_csr23 extends uvm_object;

  //instance of CSRs23
  gpio_csr_s23 csr_s23;

  //randomize GPIO23 CSR23 fields
  rand bit [`GPIO_DATA_WIDTH23-1:0] bypass_mode23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] direction_mode23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] output_enable23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] output_value23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] input_value23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] int_mask23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] int_enable23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] int_disable23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] int_status23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] int_type23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] int_value23;
  rand bit [`GPIO_DATA_WIDTH23-1:0] int_on_any23;

  // this is a default constraint that could be overriden23
  // Constrain23 randomisation23 of configuration based on UVC23/RTL23 capabilities23
  constraint c_default_config23 { int_mask23         == 32'hFFFFFFFF;}

  // These23 declarations23 implement the create() and get_type_name() as well23 as enable automation23 of the
  // transfer23 fields   
  `uvm_object_utils_begin(gpio_csr23)
    `uvm_field_int(bypass_mode23,    UVM_ALL_ON)
    `uvm_field_int(direction_mode23, UVM_ALL_ON)
    `uvm_field_int(output_enable23,  UVM_ALL_ON)
    `uvm_field_int(output_value23,   UVM_ALL_ON)
    `uvm_field_int(input_value23,    UVM_ALL_ON)  
    `uvm_field_int(int_mask23,       UVM_ALL_ON)
    `uvm_field_int(int_enable23,     UVM_ALL_ON)
    `uvm_field_int(int_disable23,    UVM_ALL_ON)
    `uvm_field_int(int_status23,     UVM_ALL_ON)
    `uvm_field_int(int_type23,       UVM_ALL_ON)
    `uvm_field_int(int_value23,      UVM_ALL_ON)
    `uvm_field_int(int_on_any23,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This23 requires for registration23 of the ptp_tx_frame23   
  function new(string name = "gpio_csr23");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct23();
  endfunction 

  function void Copycfg_struct23();
    csr_s23.bypass_mode23    = bypass_mode23;
    csr_s23.direction_mode23 = direction_mode23;
    csr_s23.output_enable23  = output_enable23;
    csr_s23.output_value23   = output_value23;
    csr_s23.input_value23    = input_value23;
    csr_s23.int_mask23       = int_mask23;
    csr_s23.int_enable23     = int_enable23;
    csr_s23.int_disable23    = int_disable23;
    csr_s23.int_status23     = int_status23;
    csr_s23.int_type23       = int_type23;
    csr_s23.int_value23      = int_value23;
    csr_s23.int_on_any23     = int_on_any23;
  endfunction

endclass : gpio_csr23

`endif

