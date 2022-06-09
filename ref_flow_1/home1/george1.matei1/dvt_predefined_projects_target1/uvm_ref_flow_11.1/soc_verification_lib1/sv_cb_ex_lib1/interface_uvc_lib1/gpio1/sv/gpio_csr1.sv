/*-------------------------------------------------------------------------
File1 name   : gpio_csr1.sv
Title1       : GPIO1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV1
`define GPIO_CSR_SV1

typedef struct packed {
  bit [`GPIO_DATA_WIDTH1-1:0] bypass_mode1;
  bit [`GPIO_DATA_WIDTH1-1:0] direction_mode1;
  bit [`GPIO_DATA_WIDTH1-1:0] output_enable1;
  bit [`GPIO_DATA_WIDTH1-1:0] output_value1;
  bit [`GPIO_DATA_WIDTH1-1:0] input_value1;
  bit [`GPIO_DATA_WIDTH1-1:0] int_mask1;
  bit [`GPIO_DATA_WIDTH1-1:0] int_enable1;
  bit [`GPIO_DATA_WIDTH1-1:0] int_disable1;
  bit [`GPIO_DATA_WIDTH1-1:0] int_status1;
  bit [`GPIO_DATA_WIDTH1-1:0] int_type1;
  bit [`GPIO_DATA_WIDTH1-1:0] int_value1;
  bit [`GPIO_DATA_WIDTH1-1:0] int_on_any1;
  } gpio_csr_s1;

class gpio_csr1 extends uvm_object;

  //instance of CSRs1
  gpio_csr_s1 csr_s1;

  //randomize GPIO1 CSR1 fields
  rand bit [`GPIO_DATA_WIDTH1-1:0] bypass_mode1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] direction_mode1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] output_enable1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] output_value1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] input_value1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] int_mask1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] int_enable1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] int_disable1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] int_status1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] int_type1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] int_value1;
  rand bit [`GPIO_DATA_WIDTH1-1:0] int_on_any1;

  // this is a default constraint that could be overriden1
  // Constrain1 randomisation1 of configuration based on UVC1/RTL1 capabilities1
  constraint c_default_config1 { int_mask1         == 32'hFFFFFFFF;}

  // These1 declarations1 implement the create() and get_type_name() as well1 as enable automation1 of the
  // transfer1 fields   
  `uvm_object_utils_begin(gpio_csr1)
    `uvm_field_int(bypass_mode1,    UVM_ALL_ON)
    `uvm_field_int(direction_mode1, UVM_ALL_ON)
    `uvm_field_int(output_enable1,  UVM_ALL_ON)
    `uvm_field_int(output_value1,   UVM_ALL_ON)
    `uvm_field_int(input_value1,    UVM_ALL_ON)  
    `uvm_field_int(int_mask1,       UVM_ALL_ON)
    `uvm_field_int(int_enable1,     UVM_ALL_ON)
    `uvm_field_int(int_disable1,    UVM_ALL_ON)
    `uvm_field_int(int_status1,     UVM_ALL_ON)
    `uvm_field_int(int_type1,       UVM_ALL_ON)
    `uvm_field_int(int_value1,      UVM_ALL_ON)
    `uvm_field_int(int_on_any1,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This1 requires for registration1 of the ptp_tx_frame1   
  function new(string name = "gpio_csr1");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct1();
  endfunction 

  function void Copycfg_struct1();
    csr_s1.bypass_mode1    = bypass_mode1;
    csr_s1.direction_mode1 = direction_mode1;
    csr_s1.output_enable1  = output_enable1;
    csr_s1.output_value1   = output_value1;
    csr_s1.input_value1    = input_value1;
    csr_s1.int_mask1       = int_mask1;
    csr_s1.int_enable1     = int_enable1;
    csr_s1.int_disable1    = int_disable1;
    csr_s1.int_status1     = int_status1;
    csr_s1.int_type1       = int_type1;
    csr_s1.int_value1      = int_value1;
    csr_s1.int_on_any1     = int_on_any1;
  endfunction

endclass : gpio_csr1

`endif

