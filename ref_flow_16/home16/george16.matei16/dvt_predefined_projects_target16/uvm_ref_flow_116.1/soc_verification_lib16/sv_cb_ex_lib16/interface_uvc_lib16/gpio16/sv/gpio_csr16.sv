/*-------------------------------------------------------------------------
File16 name   : gpio_csr16.sv
Title16       : GPIO16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV16
`define GPIO_CSR_SV16

typedef struct packed {
  bit [`GPIO_DATA_WIDTH16-1:0] bypass_mode16;
  bit [`GPIO_DATA_WIDTH16-1:0] direction_mode16;
  bit [`GPIO_DATA_WIDTH16-1:0] output_enable16;
  bit [`GPIO_DATA_WIDTH16-1:0] output_value16;
  bit [`GPIO_DATA_WIDTH16-1:0] input_value16;
  bit [`GPIO_DATA_WIDTH16-1:0] int_mask16;
  bit [`GPIO_DATA_WIDTH16-1:0] int_enable16;
  bit [`GPIO_DATA_WIDTH16-1:0] int_disable16;
  bit [`GPIO_DATA_WIDTH16-1:0] int_status16;
  bit [`GPIO_DATA_WIDTH16-1:0] int_type16;
  bit [`GPIO_DATA_WIDTH16-1:0] int_value16;
  bit [`GPIO_DATA_WIDTH16-1:0] int_on_any16;
  } gpio_csr_s16;

class gpio_csr16 extends uvm_object;

  //instance of CSRs16
  gpio_csr_s16 csr_s16;

  //randomize GPIO16 CSR16 fields
  rand bit [`GPIO_DATA_WIDTH16-1:0] bypass_mode16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] direction_mode16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] output_enable16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] output_value16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] input_value16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] int_mask16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] int_enable16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] int_disable16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] int_status16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] int_type16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] int_value16;
  rand bit [`GPIO_DATA_WIDTH16-1:0] int_on_any16;

  // this is a default constraint that could be overriden16
  // Constrain16 randomisation16 of configuration based on UVC16/RTL16 capabilities16
  constraint c_default_config16 { int_mask16         == 32'hFFFFFFFF;}

  // These16 declarations16 implement the create() and get_type_name() as well16 as enable automation16 of the
  // transfer16 fields   
  `uvm_object_utils_begin(gpio_csr16)
    `uvm_field_int(bypass_mode16,    UVM_ALL_ON)
    `uvm_field_int(direction_mode16, UVM_ALL_ON)
    `uvm_field_int(output_enable16,  UVM_ALL_ON)
    `uvm_field_int(output_value16,   UVM_ALL_ON)
    `uvm_field_int(input_value16,    UVM_ALL_ON)  
    `uvm_field_int(int_mask16,       UVM_ALL_ON)
    `uvm_field_int(int_enable16,     UVM_ALL_ON)
    `uvm_field_int(int_disable16,    UVM_ALL_ON)
    `uvm_field_int(int_status16,     UVM_ALL_ON)
    `uvm_field_int(int_type16,       UVM_ALL_ON)
    `uvm_field_int(int_value16,      UVM_ALL_ON)
    `uvm_field_int(int_on_any16,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This16 requires for registration16 of the ptp_tx_frame16   
  function new(string name = "gpio_csr16");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct16();
  endfunction 

  function void Copycfg_struct16();
    csr_s16.bypass_mode16    = bypass_mode16;
    csr_s16.direction_mode16 = direction_mode16;
    csr_s16.output_enable16  = output_enable16;
    csr_s16.output_value16   = output_value16;
    csr_s16.input_value16    = input_value16;
    csr_s16.int_mask16       = int_mask16;
    csr_s16.int_enable16     = int_enable16;
    csr_s16.int_disable16    = int_disable16;
    csr_s16.int_status16     = int_status16;
    csr_s16.int_type16       = int_type16;
    csr_s16.int_value16      = int_value16;
    csr_s16.int_on_any16     = int_on_any16;
  endfunction

endclass : gpio_csr16

`endif

