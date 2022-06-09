/*-------------------------------------------------------------------------
File6 name   : gpio_csr6.sv
Title6       : GPIO6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV6
`define GPIO_CSR_SV6

typedef struct packed {
  bit [`GPIO_DATA_WIDTH6-1:0] bypass_mode6;
  bit [`GPIO_DATA_WIDTH6-1:0] direction_mode6;
  bit [`GPIO_DATA_WIDTH6-1:0] output_enable6;
  bit [`GPIO_DATA_WIDTH6-1:0] output_value6;
  bit [`GPIO_DATA_WIDTH6-1:0] input_value6;
  bit [`GPIO_DATA_WIDTH6-1:0] int_mask6;
  bit [`GPIO_DATA_WIDTH6-1:0] int_enable6;
  bit [`GPIO_DATA_WIDTH6-1:0] int_disable6;
  bit [`GPIO_DATA_WIDTH6-1:0] int_status6;
  bit [`GPIO_DATA_WIDTH6-1:0] int_type6;
  bit [`GPIO_DATA_WIDTH6-1:0] int_value6;
  bit [`GPIO_DATA_WIDTH6-1:0] int_on_any6;
  } gpio_csr_s6;

class gpio_csr6 extends uvm_object;

  //instance of CSRs6
  gpio_csr_s6 csr_s6;

  //randomize GPIO6 CSR6 fields
  rand bit [`GPIO_DATA_WIDTH6-1:0] bypass_mode6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] direction_mode6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] output_enable6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] output_value6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] input_value6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] int_mask6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] int_enable6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] int_disable6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] int_status6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] int_type6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] int_value6;
  rand bit [`GPIO_DATA_WIDTH6-1:0] int_on_any6;

  // this is a default constraint that could be overriden6
  // Constrain6 randomisation6 of configuration based on UVC6/RTL6 capabilities6
  constraint c_default_config6 { int_mask6         == 32'hFFFFFFFF;}

  // These6 declarations6 implement the create() and get_type_name() as well6 as enable automation6 of the
  // transfer6 fields   
  `uvm_object_utils_begin(gpio_csr6)
    `uvm_field_int(bypass_mode6,    UVM_ALL_ON)
    `uvm_field_int(direction_mode6, UVM_ALL_ON)
    `uvm_field_int(output_enable6,  UVM_ALL_ON)
    `uvm_field_int(output_value6,   UVM_ALL_ON)
    `uvm_field_int(input_value6,    UVM_ALL_ON)  
    `uvm_field_int(int_mask6,       UVM_ALL_ON)
    `uvm_field_int(int_enable6,     UVM_ALL_ON)
    `uvm_field_int(int_disable6,    UVM_ALL_ON)
    `uvm_field_int(int_status6,     UVM_ALL_ON)
    `uvm_field_int(int_type6,       UVM_ALL_ON)
    `uvm_field_int(int_value6,      UVM_ALL_ON)
    `uvm_field_int(int_on_any6,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This6 requires for registration6 of the ptp_tx_frame6   
  function new(string name = "gpio_csr6");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct6();
  endfunction 

  function void Copycfg_struct6();
    csr_s6.bypass_mode6    = bypass_mode6;
    csr_s6.direction_mode6 = direction_mode6;
    csr_s6.output_enable6  = output_enable6;
    csr_s6.output_value6   = output_value6;
    csr_s6.input_value6    = input_value6;
    csr_s6.int_mask6       = int_mask6;
    csr_s6.int_enable6     = int_enable6;
    csr_s6.int_disable6    = int_disable6;
    csr_s6.int_status6     = int_status6;
    csr_s6.int_type6       = int_type6;
    csr_s6.int_value6      = int_value6;
    csr_s6.int_on_any6     = int_on_any6;
  endfunction

endclass : gpio_csr6

`endif

