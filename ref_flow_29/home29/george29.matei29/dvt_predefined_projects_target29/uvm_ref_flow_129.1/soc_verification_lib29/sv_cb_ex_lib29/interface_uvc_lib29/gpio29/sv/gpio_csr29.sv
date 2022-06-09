/*-------------------------------------------------------------------------
File29 name   : gpio_csr29.sv
Title29       : GPIO29 SystemVerilog29 UVM UVC29
Project29     : SystemVerilog29 UVM Cluster29 Level29 Verification29
Created29     :
Description29 : 
Notes29       :  
---------------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV29
`define GPIO_CSR_SV29

typedef struct packed {
  bit [`GPIO_DATA_WIDTH29-1:0] bypass_mode29;
  bit [`GPIO_DATA_WIDTH29-1:0] direction_mode29;
  bit [`GPIO_DATA_WIDTH29-1:0] output_enable29;
  bit [`GPIO_DATA_WIDTH29-1:0] output_value29;
  bit [`GPIO_DATA_WIDTH29-1:0] input_value29;
  bit [`GPIO_DATA_WIDTH29-1:0] int_mask29;
  bit [`GPIO_DATA_WIDTH29-1:0] int_enable29;
  bit [`GPIO_DATA_WIDTH29-1:0] int_disable29;
  bit [`GPIO_DATA_WIDTH29-1:0] int_status29;
  bit [`GPIO_DATA_WIDTH29-1:0] int_type29;
  bit [`GPIO_DATA_WIDTH29-1:0] int_value29;
  bit [`GPIO_DATA_WIDTH29-1:0] int_on_any29;
  } gpio_csr_s29;

class gpio_csr29 extends uvm_object;

  //instance of CSRs29
  gpio_csr_s29 csr_s29;

  //randomize GPIO29 CSR29 fields
  rand bit [`GPIO_DATA_WIDTH29-1:0] bypass_mode29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] direction_mode29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] output_enable29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] output_value29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] input_value29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] int_mask29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] int_enable29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] int_disable29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] int_status29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] int_type29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] int_value29;
  rand bit [`GPIO_DATA_WIDTH29-1:0] int_on_any29;

  // this is a default constraint that could be overriden29
  // Constrain29 randomisation29 of configuration based on UVC29/RTL29 capabilities29
  constraint c_default_config29 { int_mask29         == 32'hFFFFFFFF;}

  // These29 declarations29 implement the create() and get_type_name() as well29 as enable automation29 of the
  // transfer29 fields   
  `uvm_object_utils_begin(gpio_csr29)
    `uvm_field_int(bypass_mode29,    UVM_ALL_ON)
    `uvm_field_int(direction_mode29, UVM_ALL_ON)
    `uvm_field_int(output_enable29,  UVM_ALL_ON)
    `uvm_field_int(output_value29,   UVM_ALL_ON)
    `uvm_field_int(input_value29,    UVM_ALL_ON)  
    `uvm_field_int(int_mask29,       UVM_ALL_ON)
    `uvm_field_int(int_enable29,     UVM_ALL_ON)
    `uvm_field_int(int_disable29,    UVM_ALL_ON)
    `uvm_field_int(int_status29,     UVM_ALL_ON)
    `uvm_field_int(int_type29,       UVM_ALL_ON)
    `uvm_field_int(int_value29,      UVM_ALL_ON)
    `uvm_field_int(int_on_any29,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This29 requires for registration29 of the ptp_tx_frame29   
  function new(string name = "gpio_csr29");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct29();
  endfunction 

  function void Copycfg_struct29();
    csr_s29.bypass_mode29    = bypass_mode29;
    csr_s29.direction_mode29 = direction_mode29;
    csr_s29.output_enable29  = output_enable29;
    csr_s29.output_value29   = output_value29;
    csr_s29.input_value29    = input_value29;
    csr_s29.int_mask29       = int_mask29;
    csr_s29.int_enable29     = int_enable29;
    csr_s29.int_disable29    = int_disable29;
    csr_s29.int_status29     = int_status29;
    csr_s29.int_type29       = int_type29;
    csr_s29.int_value29      = int_value29;
    csr_s29.int_on_any29     = int_on_any29;
  endfunction

endclass : gpio_csr29

`endif

