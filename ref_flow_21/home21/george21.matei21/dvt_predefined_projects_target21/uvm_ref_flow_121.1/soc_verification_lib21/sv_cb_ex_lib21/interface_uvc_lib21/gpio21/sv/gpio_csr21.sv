/*-------------------------------------------------------------------------
File21 name   : gpio_csr21.sv
Title21       : GPIO21 SystemVerilog21 UVM UVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV21
`define GPIO_CSR_SV21

typedef struct packed {
  bit [`GPIO_DATA_WIDTH21-1:0] bypass_mode21;
  bit [`GPIO_DATA_WIDTH21-1:0] direction_mode21;
  bit [`GPIO_DATA_WIDTH21-1:0] output_enable21;
  bit [`GPIO_DATA_WIDTH21-1:0] output_value21;
  bit [`GPIO_DATA_WIDTH21-1:0] input_value21;
  bit [`GPIO_DATA_WIDTH21-1:0] int_mask21;
  bit [`GPIO_DATA_WIDTH21-1:0] int_enable21;
  bit [`GPIO_DATA_WIDTH21-1:0] int_disable21;
  bit [`GPIO_DATA_WIDTH21-1:0] int_status21;
  bit [`GPIO_DATA_WIDTH21-1:0] int_type21;
  bit [`GPIO_DATA_WIDTH21-1:0] int_value21;
  bit [`GPIO_DATA_WIDTH21-1:0] int_on_any21;
  } gpio_csr_s21;

class gpio_csr21 extends uvm_object;

  //instance of CSRs21
  gpio_csr_s21 csr_s21;

  //randomize GPIO21 CSR21 fields
  rand bit [`GPIO_DATA_WIDTH21-1:0] bypass_mode21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] direction_mode21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] output_enable21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] output_value21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] input_value21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] int_mask21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] int_enable21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] int_disable21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] int_status21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] int_type21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] int_value21;
  rand bit [`GPIO_DATA_WIDTH21-1:0] int_on_any21;

  // this is a default constraint that could be overriden21
  // Constrain21 randomisation21 of configuration based on UVC21/RTL21 capabilities21
  constraint c_default_config21 { int_mask21         == 32'hFFFFFFFF;}

  // These21 declarations21 implement the create() and get_type_name() as well21 as enable automation21 of the
  // transfer21 fields   
  `uvm_object_utils_begin(gpio_csr21)
    `uvm_field_int(bypass_mode21,    UVM_ALL_ON)
    `uvm_field_int(direction_mode21, UVM_ALL_ON)
    `uvm_field_int(output_enable21,  UVM_ALL_ON)
    `uvm_field_int(output_value21,   UVM_ALL_ON)
    `uvm_field_int(input_value21,    UVM_ALL_ON)  
    `uvm_field_int(int_mask21,       UVM_ALL_ON)
    `uvm_field_int(int_enable21,     UVM_ALL_ON)
    `uvm_field_int(int_disable21,    UVM_ALL_ON)
    `uvm_field_int(int_status21,     UVM_ALL_ON)
    `uvm_field_int(int_type21,       UVM_ALL_ON)
    `uvm_field_int(int_value21,      UVM_ALL_ON)
    `uvm_field_int(int_on_any21,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This21 requires for registration21 of the ptp_tx_frame21   
  function new(string name = "gpio_csr21");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct21();
  endfunction 

  function void Copycfg_struct21();
    csr_s21.bypass_mode21    = bypass_mode21;
    csr_s21.direction_mode21 = direction_mode21;
    csr_s21.output_enable21  = output_enable21;
    csr_s21.output_value21   = output_value21;
    csr_s21.input_value21    = input_value21;
    csr_s21.int_mask21       = int_mask21;
    csr_s21.int_enable21     = int_enable21;
    csr_s21.int_disable21    = int_disable21;
    csr_s21.int_status21     = int_status21;
    csr_s21.int_type21       = int_type21;
    csr_s21.int_value21      = int_value21;
    csr_s21.int_on_any21     = int_on_any21;
  endfunction

endclass : gpio_csr21

`endif

