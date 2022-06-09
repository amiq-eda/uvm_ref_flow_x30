/*-------------------------------------------------------------------------
File9 name   : gpio_csr9.sv
Title9       : GPIO9 SystemVerilog9 UVM UVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV9
`define GPIO_CSR_SV9

typedef struct packed {
  bit [`GPIO_DATA_WIDTH9-1:0] bypass_mode9;
  bit [`GPIO_DATA_WIDTH9-1:0] direction_mode9;
  bit [`GPIO_DATA_WIDTH9-1:0] output_enable9;
  bit [`GPIO_DATA_WIDTH9-1:0] output_value9;
  bit [`GPIO_DATA_WIDTH9-1:0] input_value9;
  bit [`GPIO_DATA_WIDTH9-1:0] int_mask9;
  bit [`GPIO_DATA_WIDTH9-1:0] int_enable9;
  bit [`GPIO_DATA_WIDTH9-1:0] int_disable9;
  bit [`GPIO_DATA_WIDTH9-1:0] int_status9;
  bit [`GPIO_DATA_WIDTH9-1:0] int_type9;
  bit [`GPIO_DATA_WIDTH9-1:0] int_value9;
  bit [`GPIO_DATA_WIDTH9-1:0] int_on_any9;
  } gpio_csr_s9;

class gpio_csr9 extends uvm_object;

  //instance of CSRs9
  gpio_csr_s9 csr_s9;

  //randomize GPIO9 CSR9 fields
  rand bit [`GPIO_DATA_WIDTH9-1:0] bypass_mode9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] direction_mode9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] output_enable9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] output_value9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] input_value9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] int_mask9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] int_enable9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] int_disable9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] int_status9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] int_type9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] int_value9;
  rand bit [`GPIO_DATA_WIDTH9-1:0] int_on_any9;

  // this is a default constraint that could be overriden9
  // Constrain9 randomisation9 of configuration based on UVC9/RTL9 capabilities9
  constraint c_default_config9 { int_mask9         == 32'hFFFFFFFF;}

  // These9 declarations9 implement the create() and get_type_name() as well9 as enable automation9 of the
  // transfer9 fields   
  `uvm_object_utils_begin(gpio_csr9)
    `uvm_field_int(bypass_mode9,    UVM_ALL_ON)
    `uvm_field_int(direction_mode9, UVM_ALL_ON)
    `uvm_field_int(output_enable9,  UVM_ALL_ON)
    `uvm_field_int(output_value9,   UVM_ALL_ON)
    `uvm_field_int(input_value9,    UVM_ALL_ON)  
    `uvm_field_int(int_mask9,       UVM_ALL_ON)
    `uvm_field_int(int_enable9,     UVM_ALL_ON)
    `uvm_field_int(int_disable9,    UVM_ALL_ON)
    `uvm_field_int(int_status9,     UVM_ALL_ON)
    `uvm_field_int(int_type9,       UVM_ALL_ON)
    `uvm_field_int(int_value9,      UVM_ALL_ON)
    `uvm_field_int(int_on_any9,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This9 requires for registration9 of the ptp_tx_frame9   
  function new(string name = "gpio_csr9");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct9();
  endfunction 

  function void Copycfg_struct9();
    csr_s9.bypass_mode9    = bypass_mode9;
    csr_s9.direction_mode9 = direction_mode9;
    csr_s9.output_enable9  = output_enable9;
    csr_s9.output_value9   = output_value9;
    csr_s9.input_value9    = input_value9;
    csr_s9.int_mask9       = int_mask9;
    csr_s9.int_enable9     = int_enable9;
    csr_s9.int_disable9    = int_disable9;
    csr_s9.int_status9     = int_status9;
    csr_s9.int_type9       = int_type9;
    csr_s9.int_value9      = int_value9;
    csr_s9.int_on_any9     = int_on_any9;
  endfunction

endclass : gpio_csr9

`endif

