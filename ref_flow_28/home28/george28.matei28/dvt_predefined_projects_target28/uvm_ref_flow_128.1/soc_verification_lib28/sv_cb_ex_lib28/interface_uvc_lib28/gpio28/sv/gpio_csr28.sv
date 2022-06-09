/*-------------------------------------------------------------------------
File28 name   : gpio_csr28.sv
Title28       : GPIO28 SystemVerilog28 UVM UVC28
Project28     : SystemVerilog28 UVM Cluster28 Level28 Verification28
Created28     :
Description28 : 
Notes28       :  
---------------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV28
`define GPIO_CSR_SV28

typedef struct packed {
  bit [`GPIO_DATA_WIDTH28-1:0] bypass_mode28;
  bit [`GPIO_DATA_WIDTH28-1:0] direction_mode28;
  bit [`GPIO_DATA_WIDTH28-1:0] output_enable28;
  bit [`GPIO_DATA_WIDTH28-1:0] output_value28;
  bit [`GPIO_DATA_WIDTH28-1:0] input_value28;
  bit [`GPIO_DATA_WIDTH28-1:0] int_mask28;
  bit [`GPIO_DATA_WIDTH28-1:0] int_enable28;
  bit [`GPIO_DATA_WIDTH28-1:0] int_disable28;
  bit [`GPIO_DATA_WIDTH28-1:0] int_status28;
  bit [`GPIO_DATA_WIDTH28-1:0] int_type28;
  bit [`GPIO_DATA_WIDTH28-1:0] int_value28;
  bit [`GPIO_DATA_WIDTH28-1:0] int_on_any28;
  } gpio_csr_s28;

class gpio_csr28 extends uvm_object;

  //instance of CSRs28
  gpio_csr_s28 csr_s28;

  //randomize GPIO28 CSR28 fields
  rand bit [`GPIO_DATA_WIDTH28-1:0] bypass_mode28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] direction_mode28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] output_enable28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] output_value28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] input_value28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] int_mask28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] int_enable28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] int_disable28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] int_status28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] int_type28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] int_value28;
  rand bit [`GPIO_DATA_WIDTH28-1:0] int_on_any28;

  // this is a default constraint that could be overriden28
  // Constrain28 randomisation28 of configuration based on UVC28/RTL28 capabilities28
  constraint c_default_config28 { int_mask28         == 32'hFFFFFFFF;}

  // These28 declarations28 implement the create() and get_type_name() as well28 as enable automation28 of the
  // transfer28 fields   
  `uvm_object_utils_begin(gpio_csr28)
    `uvm_field_int(bypass_mode28,    UVM_ALL_ON)
    `uvm_field_int(direction_mode28, UVM_ALL_ON)
    `uvm_field_int(output_enable28,  UVM_ALL_ON)
    `uvm_field_int(output_value28,   UVM_ALL_ON)
    `uvm_field_int(input_value28,    UVM_ALL_ON)  
    `uvm_field_int(int_mask28,       UVM_ALL_ON)
    `uvm_field_int(int_enable28,     UVM_ALL_ON)
    `uvm_field_int(int_disable28,    UVM_ALL_ON)
    `uvm_field_int(int_status28,     UVM_ALL_ON)
    `uvm_field_int(int_type28,       UVM_ALL_ON)
    `uvm_field_int(int_value28,      UVM_ALL_ON)
    `uvm_field_int(int_on_any28,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This28 requires for registration28 of the ptp_tx_frame28   
  function new(string name = "gpio_csr28");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct28();
  endfunction 

  function void Copycfg_struct28();
    csr_s28.bypass_mode28    = bypass_mode28;
    csr_s28.direction_mode28 = direction_mode28;
    csr_s28.output_enable28  = output_enable28;
    csr_s28.output_value28   = output_value28;
    csr_s28.input_value28    = input_value28;
    csr_s28.int_mask28       = int_mask28;
    csr_s28.int_enable28     = int_enable28;
    csr_s28.int_disable28    = int_disable28;
    csr_s28.int_status28     = int_status28;
    csr_s28.int_type28       = int_type28;
    csr_s28.int_value28      = int_value28;
    csr_s28.int_on_any28     = int_on_any28;
  endfunction

endclass : gpio_csr28

`endif

