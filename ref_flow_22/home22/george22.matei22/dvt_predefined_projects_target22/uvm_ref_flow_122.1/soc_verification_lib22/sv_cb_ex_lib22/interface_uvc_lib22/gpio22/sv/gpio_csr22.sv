/*-------------------------------------------------------------------------
File22 name   : gpio_csr22.sv
Title22       : GPIO22 SystemVerilog22 UVM UVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV22
`define GPIO_CSR_SV22

typedef struct packed {
  bit [`GPIO_DATA_WIDTH22-1:0] bypass_mode22;
  bit [`GPIO_DATA_WIDTH22-1:0] direction_mode22;
  bit [`GPIO_DATA_WIDTH22-1:0] output_enable22;
  bit [`GPIO_DATA_WIDTH22-1:0] output_value22;
  bit [`GPIO_DATA_WIDTH22-1:0] input_value22;
  bit [`GPIO_DATA_WIDTH22-1:0] int_mask22;
  bit [`GPIO_DATA_WIDTH22-1:0] int_enable22;
  bit [`GPIO_DATA_WIDTH22-1:0] int_disable22;
  bit [`GPIO_DATA_WIDTH22-1:0] int_status22;
  bit [`GPIO_DATA_WIDTH22-1:0] int_type22;
  bit [`GPIO_DATA_WIDTH22-1:0] int_value22;
  bit [`GPIO_DATA_WIDTH22-1:0] int_on_any22;
  } gpio_csr_s22;

class gpio_csr22 extends uvm_object;

  //instance of CSRs22
  gpio_csr_s22 csr_s22;

  //randomize GPIO22 CSR22 fields
  rand bit [`GPIO_DATA_WIDTH22-1:0] bypass_mode22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] direction_mode22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] output_enable22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] output_value22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] input_value22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] int_mask22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] int_enable22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] int_disable22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] int_status22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] int_type22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] int_value22;
  rand bit [`GPIO_DATA_WIDTH22-1:0] int_on_any22;

  // this is a default constraint that could be overriden22
  // Constrain22 randomisation22 of configuration based on UVC22/RTL22 capabilities22
  constraint c_default_config22 { int_mask22         == 32'hFFFFFFFF;}

  // These22 declarations22 implement the create() and get_type_name() as well22 as enable automation22 of the
  // transfer22 fields   
  `uvm_object_utils_begin(gpio_csr22)
    `uvm_field_int(bypass_mode22,    UVM_ALL_ON)
    `uvm_field_int(direction_mode22, UVM_ALL_ON)
    `uvm_field_int(output_enable22,  UVM_ALL_ON)
    `uvm_field_int(output_value22,   UVM_ALL_ON)
    `uvm_field_int(input_value22,    UVM_ALL_ON)  
    `uvm_field_int(int_mask22,       UVM_ALL_ON)
    `uvm_field_int(int_enable22,     UVM_ALL_ON)
    `uvm_field_int(int_disable22,    UVM_ALL_ON)
    `uvm_field_int(int_status22,     UVM_ALL_ON)
    `uvm_field_int(int_type22,       UVM_ALL_ON)
    `uvm_field_int(int_value22,      UVM_ALL_ON)
    `uvm_field_int(int_on_any22,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This22 requires for registration22 of the ptp_tx_frame22   
  function new(string name = "gpio_csr22");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct22();
  endfunction 

  function void Copycfg_struct22();
    csr_s22.bypass_mode22    = bypass_mode22;
    csr_s22.direction_mode22 = direction_mode22;
    csr_s22.output_enable22  = output_enable22;
    csr_s22.output_value22   = output_value22;
    csr_s22.input_value22    = input_value22;
    csr_s22.int_mask22       = int_mask22;
    csr_s22.int_enable22     = int_enable22;
    csr_s22.int_disable22    = int_disable22;
    csr_s22.int_status22     = int_status22;
    csr_s22.int_type22       = int_type22;
    csr_s22.int_value22      = int_value22;
    csr_s22.int_on_any22     = int_on_any22;
  endfunction

endclass : gpio_csr22

`endif

