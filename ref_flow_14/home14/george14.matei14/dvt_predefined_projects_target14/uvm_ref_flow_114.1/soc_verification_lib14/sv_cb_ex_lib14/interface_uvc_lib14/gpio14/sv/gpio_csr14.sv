/*-------------------------------------------------------------------------
File14 name   : gpio_csr14.sv
Title14       : GPIO14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV14
`define GPIO_CSR_SV14

typedef struct packed {
  bit [`GPIO_DATA_WIDTH14-1:0] bypass_mode14;
  bit [`GPIO_DATA_WIDTH14-1:0] direction_mode14;
  bit [`GPIO_DATA_WIDTH14-1:0] output_enable14;
  bit [`GPIO_DATA_WIDTH14-1:0] output_value14;
  bit [`GPIO_DATA_WIDTH14-1:0] input_value14;
  bit [`GPIO_DATA_WIDTH14-1:0] int_mask14;
  bit [`GPIO_DATA_WIDTH14-1:0] int_enable14;
  bit [`GPIO_DATA_WIDTH14-1:0] int_disable14;
  bit [`GPIO_DATA_WIDTH14-1:0] int_status14;
  bit [`GPIO_DATA_WIDTH14-1:0] int_type14;
  bit [`GPIO_DATA_WIDTH14-1:0] int_value14;
  bit [`GPIO_DATA_WIDTH14-1:0] int_on_any14;
  } gpio_csr_s14;

class gpio_csr14 extends uvm_object;

  //instance of CSRs14
  gpio_csr_s14 csr_s14;

  //randomize GPIO14 CSR14 fields
  rand bit [`GPIO_DATA_WIDTH14-1:0] bypass_mode14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] direction_mode14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] output_enable14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] output_value14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] input_value14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] int_mask14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] int_enable14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] int_disable14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] int_status14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] int_type14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] int_value14;
  rand bit [`GPIO_DATA_WIDTH14-1:0] int_on_any14;

  // this is a default constraint that could be overriden14
  // Constrain14 randomisation14 of configuration based on UVC14/RTL14 capabilities14
  constraint c_default_config14 { int_mask14         == 32'hFFFFFFFF;}

  // These14 declarations14 implement the create() and get_type_name() as well14 as enable automation14 of the
  // transfer14 fields   
  `uvm_object_utils_begin(gpio_csr14)
    `uvm_field_int(bypass_mode14,    UVM_ALL_ON)
    `uvm_field_int(direction_mode14, UVM_ALL_ON)
    `uvm_field_int(output_enable14,  UVM_ALL_ON)
    `uvm_field_int(output_value14,   UVM_ALL_ON)
    `uvm_field_int(input_value14,    UVM_ALL_ON)  
    `uvm_field_int(int_mask14,       UVM_ALL_ON)
    `uvm_field_int(int_enable14,     UVM_ALL_ON)
    `uvm_field_int(int_disable14,    UVM_ALL_ON)
    `uvm_field_int(int_status14,     UVM_ALL_ON)
    `uvm_field_int(int_type14,       UVM_ALL_ON)
    `uvm_field_int(int_value14,      UVM_ALL_ON)
    `uvm_field_int(int_on_any14,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This14 requires for registration14 of the ptp_tx_frame14   
  function new(string name = "gpio_csr14");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct14();
  endfunction 

  function void Copycfg_struct14();
    csr_s14.bypass_mode14    = bypass_mode14;
    csr_s14.direction_mode14 = direction_mode14;
    csr_s14.output_enable14  = output_enable14;
    csr_s14.output_value14   = output_value14;
    csr_s14.input_value14    = input_value14;
    csr_s14.int_mask14       = int_mask14;
    csr_s14.int_enable14     = int_enable14;
    csr_s14.int_disable14    = int_disable14;
    csr_s14.int_status14     = int_status14;
    csr_s14.int_type14       = int_type14;
    csr_s14.int_value14      = int_value14;
    csr_s14.int_on_any14     = int_on_any14;
  endfunction

endclass : gpio_csr14

`endif

