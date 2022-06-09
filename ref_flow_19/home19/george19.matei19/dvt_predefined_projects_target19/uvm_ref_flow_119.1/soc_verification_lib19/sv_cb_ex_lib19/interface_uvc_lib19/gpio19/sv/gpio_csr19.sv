/*-------------------------------------------------------------------------
File19 name   : gpio_csr19.sv
Title19       : GPIO19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV19
`define GPIO_CSR_SV19

typedef struct packed {
  bit [`GPIO_DATA_WIDTH19-1:0] bypass_mode19;
  bit [`GPIO_DATA_WIDTH19-1:0] direction_mode19;
  bit [`GPIO_DATA_WIDTH19-1:0] output_enable19;
  bit [`GPIO_DATA_WIDTH19-1:0] output_value19;
  bit [`GPIO_DATA_WIDTH19-1:0] input_value19;
  bit [`GPIO_DATA_WIDTH19-1:0] int_mask19;
  bit [`GPIO_DATA_WIDTH19-1:0] int_enable19;
  bit [`GPIO_DATA_WIDTH19-1:0] int_disable19;
  bit [`GPIO_DATA_WIDTH19-1:0] int_status19;
  bit [`GPIO_DATA_WIDTH19-1:0] int_type19;
  bit [`GPIO_DATA_WIDTH19-1:0] int_value19;
  bit [`GPIO_DATA_WIDTH19-1:0] int_on_any19;
  } gpio_csr_s19;

class gpio_csr19 extends uvm_object;

  //instance of CSRs19
  gpio_csr_s19 csr_s19;

  //randomize GPIO19 CSR19 fields
  rand bit [`GPIO_DATA_WIDTH19-1:0] bypass_mode19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] direction_mode19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] output_enable19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] output_value19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] input_value19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] int_mask19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] int_enable19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] int_disable19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] int_status19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] int_type19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] int_value19;
  rand bit [`GPIO_DATA_WIDTH19-1:0] int_on_any19;

  // this is a default constraint that could be overriden19
  // Constrain19 randomisation19 of configuration based on UVC19/RTL19 capabilities19
  constraint c_default_config19 { int_mask19         == 32'hFFFFFFFF;}

  // These19 declarations19 implement the create() and get_type_name() as well19 as enable automation19 of the
  // transfer19 fields   
  `uvm_object_utils_begin(gpio_csr19)
    `uvm_field_int(bypass_mode19,    UVM_ALL_ON)
    `uvm_field_int(direction_mode19, UVM_ALL_ON)
    `uvm_field_int(output_enable19,  UVM_ALL_ON)
    `uvm_field_int(output_value19,   UVM_ALL_ON)
    `uvm_field_int(input_value19,    UVM_ALL_ON)  
    `uvm_field_int(int_mask19,       UVM_ALL_ON)
    `uvm_field_int(int_enable19,     UVM_ALL_ON)
    `uvm_field_int(int_disable19,    UVM_ALL_ON)
    `uvm_field_int(int_status19,     UVM_ALL_ON)
    `uvm_field_int(int_type19,       UVM_ALL_ON)
    `uvm_field_int(int_value19,      UVM_ALL_ON)
    `uvm_field_int(int_on_any19,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This19 requires for registration19 of the ptp_tx_frame19   
  function new(string name = "gpio_csr19");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct19();
  endfunction 

  function void Copycfg_struct19();
    csr_s19.bypass_mode19    = bypass_mode19;
    csr_s19.direction_mode19 = direction_mode19;
    csr_s19.output_enable19  = output_enable19;
    csr_s19.output_value19   = output_value19;
    csr_s19.input_value19    = input_value19;
    csr_s19.int_mask19       = int_mask19;
    csr_s19.int_enable19     = int_enable19;
    csr_s19.int_disable19    = int_disable19;
    csr_s19.int_status19     = int_status19;
    csr_s19.int_type19       = int_type19;
    csr_s19.int_value19      = int_value19;
    csr_s19.int_on_any19     = int_on_any19;
  endfunction

endclass : gpio_csr19

`endif

