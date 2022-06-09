/*-------------------------------------------------------------------------
File13 name   : gpio_csr13.sv
Title13       : GPIO13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV13
`define GPIO_CSR_SV13

typedef struct packed {
  bit [`GPIO_DATA_WIDTH13-1:0] bypass_mode13;
  bit [`GPIO_DATA_WIDTH13-1:0] direction_mode13;
  bit [`GPIO_DATA_WIDTH13-1:0] output_enable13;
  bit [`GPIO_DATA_WIDTH13-1:0] output_value13;
  bit [`GPIO_DATA_WIDTH13-1:0] input_value13;
  bit [`GPIO_DATA_WIDTH13-1:0] int_mask13;
  bit [`GPIO_DATA_WIDTH13-1:0] int_enable13;
  bit [`GPIO_DATA_WIDTH13-1:0] int_disable13;
  bit [`GPIO_DATA_WIDTH13-1:0] int_status13;
  bit [`GPIO_DATA_WIDTH13-1:0] int_type13;
  bit [`GPIO_DATA_WIDTH13-1:0] int_value13;
  bit [`GPIO_DATA_WIDTH13-1:0] int_on_any13;
  } gpio_csr_s13;

class gpio_csr13 extends uvm_object;

  //instance of CSRs13
  gpio_csr_s13 csr_s13;

  //randomize GPIO13 CSR13 fields
  rand bit [`GPIO_DATA_WIDTH13-1:0] bypass_mode13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] direction_mode13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] output_enable13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] output_value13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] input_value13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] int_mask13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] int_enable13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] int_disable13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] int_status13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] int_type13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] int_value13;
  rand bit [`GPIO_DATA_WIDTH13-1:0] int_on_any13;

  // this is a default constraint that could be overriden13
  // Constrain13 randomisation13 of configuration based on UVC13/RTL13 capabilities13
  constraint c_default_config13 { int_mask13         == 32'hFFFFFFFF;}

  // These13 declarations13 implement the create() and get_type_name() as well13 as enable automation13 of the
  // transfer13 fields   
  `uvm_object_utils_begin(gpio_csr13)
    `uvm_field_int(bypass_mode13,    UVM_ALL_ON)
    `uvm_field_int(direction_mode13, UVM_ALL_ON)
    `uvm_field_int(output_enable13,  UVM_ALL_ON)
    `uvm_field_int(output_value13,   UVM_ALL_ON)
    `uvm_field_int(input_value13,    UVM_ALL_ON)  
    `uvm_field_int(int_mask13,       UVM_ALL_ON)
    `uvm_field_int(int_enable13,     UVM_ALL_ON)
    `uvm_field_int(int_disable13,    UVM_ALL_ON)
    `uvm_field_int(int_status13,     UVM_ALL_ON)
    `uvm_field_int(int_type13,       UVM_ALL_ON)
    `uvm_field_int(int_value13,      UVM_ALL_ON)
    `uvm_field_int(int_on_any13,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This13 requires for registration13 of the ptp_tx_frame13   
  function new(string name = "gpio_csr13");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct13();
  endfunction 

  function void Copycfg_struct13();
    csr_s13.bypass_mode13    = bypass_mode13;
    csr_s13.direction_mode13 = direction_mode13;
    csr_s13.output_enable13  = output_enable13;
    csr_s13.output_value13   = output_value13;
    csr_s13.input_value13    = input_value13;
    csr_s13.int_mask13       = int_mask13;
    csr_s13.int_enable13     = int_enable13;
    csr_s13.int_disable13    = int_disable13;
    csr_s13.int_status13     = int_status13;
    csr_s13.int_type13       = int_type13;
    csr_s13.int_value13      = int_value13;
    csr_s13.int_on_any13     = int_on_any13;
  endfunction

endclass : gpio_csr13

`endif

