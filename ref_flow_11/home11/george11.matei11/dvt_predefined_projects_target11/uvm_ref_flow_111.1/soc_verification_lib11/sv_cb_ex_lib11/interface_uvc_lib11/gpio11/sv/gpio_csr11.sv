/*-------------------------------------------------------------------------
File11 name   : gpio_csr11.sv
Title11       : GPIO11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV11
`define GPIO_CSR_SV11

typedef struct packed {
  bit [`GPIO_DATA_WIDTH11-1:0] bypass_mode11;
  bit [`GPIO_DATA_WIDTH11-1:0] direction_mode11;
  bit [`GPIO_DATA_WIDTH11-1:0] output_enable11;
  bit [`GPIO_DATA_WIDTH11-1:0] output_value11;
  bit [`GPIO_DATA_WIDTH11-1:0] input_value11;
  bit [`GPIO_DATA_WIDTH11-1:0] int_mask11;
  bit [`GPIO_DATA_WIDTH11-1:0] int_enable11;
  bit [`GPIO_DATA_WIDTH11-1:0] int_disable11;
  bit [`GPIO_DATA_WIDTH11-1:0] int_status11;
  bit [`GPIO_DATA_WIDTH11-1:0] int_type11;
  bit [`GPIO_DATA_WIDTH11-1:0] int_value11;
  bit [`GPIO_DATA_WIDTH11-1:0] int_on_any11;
  } gpio_csr_s11;

class gpio_csr11 extends uvm_object;

  //instance of CSRs11
  gpio_csr_s11 csr_s11;

  //randomize GPIO11 CSR11 fields
  rand bit [`GPIO_DATA_WIDTH11-1:0] bypass_mode11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] direction_mode11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] output_enable11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] output_value11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] input_value11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] int_mask11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] int_enable11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] int_disable11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] int_status11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] int_type11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] int_value11;
  rand bit [`GPIO_DATA_WIDTH11-1:0] int_on_any11;

  // this is a default constraint that could be overriden11
  // Constrain11 randomisation11 of configuration based on UVC11/RTL11 capabilities11
  constraint c_default_config11 { int_mask11         == 32'hFFFFFFFF;}

  // These11 declarations11 implement the create() and get_type_name() as well11 as enable automation11 of the
  // transfer11 fields   
  `uvm_object_utils_begin(gpio_csr11)
    `uvm_field_int(bypass_mode11,    UVM_ALL_ON)
    `uvm_field_int(direction_mode11, UVM_ALL_ON)
    `uvm_field_int(output_enable11,  UVM_ALL_ON)
    `uvm_field_int(output_value11,   UVM_ALL_ON)
    `uvm_field_int(input_value11,    UVM_ALL_ON)  
    `uvm_field_int(int_mask11,       UVM_ALL_ON)
    `uvm_field_int(int_enable11,     UVM_ALL_ON)
    `uvm_field_int(int_disable11,    UVM_ALL_ON)
    `uvm_field_int(int_status11,     UVM_ALL_ON)
    `uvm_field_int(int_type11,       UVM_ALL_ON)
    `uvm_field_int(int_value11,      UVM_ALL_ON)
    `uvm_field_int(int_on_any11,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This11 requires for registration11 of the ptp_tx_frame11   
  function new(string name = "gpio_csr11");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct11();
  endfunction 

  function void Copycfg_struct11();
    csr_s11.bypass_mode11    = bypass_mode11;
    csr_s11.direction_mode11 = direction_mode11;
    csr_s11.output_enable11  = output_enable11;
    csr_s11.output_value11   = output_value11;
    csr_s11.input_value11    = input_value11;
    csr_s11.int_mask11       = int_mask11;
    csr_s11.int_enable11     = int_enable11;
    csr_s11.int_disable11    = int_disable11;
    csr_s11.int_status11     = int_status11;
    csr_s11.int_type11       = int_type11;
    csr_s11.int_value11      = int_value11;
    csr_s11.int_on_any11     = int_on_any11;
  endfunction

endclass : gpio_csr11

`endif

