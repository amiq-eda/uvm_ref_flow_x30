/*-------------------------------------------------------------------------
File18 name   : gpio_csr18.sv
Title18       : GPIO18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV18
`define GPIO_CSR_SV18

typedef struct packed {
  bit [`GPIO_DATA_WIDTH18-1:0] bypass_mode18;
  bit [`GPIO_DATA_WIDTH18-1:0] direction_mode18;
  bit [`GPIO_DATA_WIDTH18-1:0] output_enable18;
  bit [`GPIO_DATA_WIDTH18-1:0] output_value18;
  bit [`GPIO_DATA_WIDTH18-1:0] input_value18;
  bit [`GPIO_DATA_WIDTH18-1:0] int_mask18;
  bit [`GPIO_DATA_WIDTH18-1:0] int_enable18;
  bit [`GPIO_DATA_WIDTH18-1:0] int_disable18;
  bit [`GPIO_DATA_WIDTH18-1:0] int_status18;
  bit [`GPIO_DATA_WIDTH18-1:0] int_type18;
  bit [`GPIO_DATA_WIDTH18-1:0] int_value18;
  bit [`GPIO_DATA_WIDTH18-1:0] int_on_any18;
  } gpio_csr_s18;

class gpio_csr18 extends uvm_object;

  //instance of CSRs18
  gpio_csr_s18 csr_s18;

  //randomize GPIO18 CSR18 fields
  rand bit [`GPIO_DATA_WIDTH18-1:0] bypass_mode18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] direction_mode18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] output_enable18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] output_value18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] input_value18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] int_mask18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] int_enable18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] int_disable18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] int_status18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] int_type18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] int_value18;
  rand bit [`GPIO_DATA_WIDTH18-1:0] int_on_any18;

  // this is a default constraint that could be overriden18
  // Constrain18 randomisation18 of configuration based on UVC18/RTL18 capabilities18
  constraint c_default_config18 { int_mask18         == 32'hFFFFFFFF;}

  // These18 declarations18 implement the create() and get_type_name() as well18 as enable automation18 of the
  // transfer18 fields   
  `uvm_object_utils_begin(gpio_csr18)
    `uvm_field_int(bypass_mode18,    UVM_ALL_ON)
    `uvm_field_int(direction_mode18, UVM_ALL_ON)
    `uvm_field_int(output_enable18,  UVM_ALL_ON)
    `uvm_field_int(output_value18,   UVM_ALL_ON)
    `uvm_field_int(input_value18,    UVM_ALL_ON)  
    `uvm_field_int(int_mask18,       UVM_ALL_ON)
    `uvm_field_int(int_enable18,     UVM_ALL_ON)
    `uvm_field_int(int_disable18,    UVM_ALL_ON)
    `uvm_field_int(int_status18,     UVM_ALL_ON)
    `uvm_field_int(int_type18,       UVM_ALL_ON)
    `uvm_field_int(int_value18,      UVM_ALL_ON)
    `uvm_field_int(int_on_any18,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This18 requires for registration18 of the ptp_tx_frame18   
  function new(string name = "gpio_csr18");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct18();
  endfunction 

  function void Copycfg_struct18();
    csr_s18.bypass_mode18    = bypass_mode18;
    csr_s18.direction_mode18 = direction_mode18;
    csr_s18.output_enable18  = output_enable18;
    csr_s18.output_value18   = output_value18;
    csr_s18.input_value18    = input_value18;
    csr_s18.int_mask18       = int_mask18;
    csr_s18.int_enable18     = int_enable18;
    csr_s18.int_disable18    = int_disable18;
    csr_s18.int_status18     = int_status18;
    csr_s18.int_type18       = int_type18;
    csr_s18.int_value18      = int_value18;
    csr_s18.int_on_any18     = int_on_any18;
  endfunction

endclass : gpio_csr18

`endif

