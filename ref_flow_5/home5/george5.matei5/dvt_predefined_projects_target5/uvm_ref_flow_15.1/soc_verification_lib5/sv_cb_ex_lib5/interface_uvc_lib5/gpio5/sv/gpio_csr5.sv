/*-------------------------------------------------------------------------
File5 name   : gpio_csr5.sv
Title5       : GPIO5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV5
`define GPIO_CSR_SV5

typedef struct packed {
  bit [`GPIO_DATA_WIDTH5-1:0] bypass_mode5;
  bit [`GPIO_DATA_WIDTH5-1:0] direction_mode5;
  bit [`GPIO_DATA_WIDTH5-1:0] output_enable5;
  bit [`GPIO_DATA_WIDTH5-1:0] output_value5;
  bit [`GPIO_DATA_WIDTH5-1:0] input_value5;
  bit [`GPIO_DATA_WIDTH5-1:0] int_mask5;
  bit [`GPIO_DATA_WIDTH5-1:0] int_enable5;
  bit [`GPIO_DATA_WIDTH5-1:0] int_disable5;
  bit [`GPIO_DATA_WIDTH5-1:0] int_status5;
  bit [`GPIO_DATA_WIDTH5-1:0] int_type5;
  bit [`GPIO_DATA_WIDTH5-1:0] int_value5;
  bit [`GPIO_DATA_WIDTH5-1:0] int_on_any5;
  } gpio_csr_s5;

class gpio_csr5 extends uvm_object;

  //instance of CSRs5
  gpio_csr_s5 csr_s5;

  //randomize GPIO5 CSR5 fields
  rand bit [`GPIO_DATA_WIDTH5-1:0] bypass_mode5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] direction_mode5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] output_enable5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] output_value5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] input_value5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] int_mask5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] int_enable5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] int_disable5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] int_status5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] int_type5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] int_value5;
  rand bit [`GPIO_DATA_WIDTH5-1:0] int_on_any5;

  // this is a default constraint that could be overriden5
  // Constrain5 randomisation5 of configuration based on UVC5/RTL5 capabilities5
  constraint c_default_config5 { int_mask5         == 32'hFFFFFFFF;}

  // These5 declarations5 implement the create() and get_type_name() as well5 as enable automation5 of the
  // transfer5 fields   
  `uvm_object_utils_begin(gpio_csr5)
    `uvm_field_int(bypass_mode5,    UVM_ALL_ON)
    `uvm_field_int(direction_mode5, UVM_ALL_ON)
    `uvm_field_int(output_enable5,  UVM_ALL_ON)
    `uvm_field_int(output_value5,   UVM_ALL_ON)
    `uvm_field_int(input_value5,    UVM_ALL_ON)  
    `uvm_field_int(int_mask5,       UVM_ALL_ON)
    `uvm_field_int(int_enable5,     UVM_ALL_ON)
    `uvm_field_int(int_disable5,    UVM_ALL_ON)
    `uvm_field_int(int_status5,     UVM_ALL_ON)
    `uvm_field_int(int_type5,       UVM_ALL_ON)
    `uvm_field_int(int_value5,      UVM_ALL_ON)
    `uvm_field_int(int_on_any5,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This5 requires for registration5 of the ptp_tx_frame5   
  function new(string name = "gpio_csr5");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct5();
  endfunction 

  function void Copycfg_struct5();
    csr_s5.bypass_mode5    = bypass_mode5;
    csr_s5.direction_mode5 = direction_mode5;
    csr_s5.output_enable5  = output_enable5;
    csr_s5.output_value5   = output_value5;
    csr_s5.input_value5    = input_value5;
    csr_s5.int_mask5       = int_mask5;
    csr_s5.int_enable5     = int_enable5;
    csr_s5.int_disable5    = int_disable5;
    csr_s5.int_status5     = int_status5;
    csr_s5.int_type5       = int_type5;
    csr_s5.int_value5      = int_value5;
    csr_s5.int_on_any5     = int_on_any5;
  endfunction

endclass : gpio_csr5

`endif

