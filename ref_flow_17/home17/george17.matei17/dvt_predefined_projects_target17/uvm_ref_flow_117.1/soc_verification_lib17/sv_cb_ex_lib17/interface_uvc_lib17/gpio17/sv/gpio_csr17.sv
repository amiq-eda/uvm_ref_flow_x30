/*-------------------------------------------------------------------------
File17 name   : gpio_csr17.sv
Title17       : GPIO17 SystemVerilog17 UVM UVC17
Project17     : SystemVerilog17 UVM Cluster17 Level17 Verification17
Created17     :
Description17 : 
Notes17       :  
---------------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV17
`define GPIO_CSR_SV17

typedef struct packed {
  bit [`GPIO_DATA_WIDTH17-1:0] bypass_mode17;
  bit [`GPIO_DATA_WIDTH17-1:0] direction_mode17;
  bit [`GPIO_DATA_WIDTH17-1:0] output_enable17;
  bit [`GPIO_DATA_WIDTH17-1:0] output_value17;
  bit [`GPIO_DATA_WIDTH17-1:0] input_value17;
  bit [`GPIO_DATA_WIDTH17-1:0] int_mask17;
  bit [`GPIO_DATA_WIDTH17-1:0] int_enable17;
  bit [`GPIO_DATA_WIDTH17-1:0] int_disable17;
  bit [`GPIO_DATA_WIDTH17-1:0] int_status17;
  bit [`GPIO_DATA_WIDTH17-1:0] int_type17;
  bit [`GPIO_DATA_WIDTH17-1:0] int_value17;
  bit [`GPIO_DATA_WIDTH17-1:0] int_on_any17;
  } gpio_csr_s17;

class gpio_csr17 extends uvm_object;

  //instance of CSRs17
  gpio_csr_s17 csr_s17;

  //randomize GPIO17 CSR17 fields
  rand bit [`GPIO_DATA_WIDTH17-1:0] bypass_mode17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] direction_mode17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] output_enable17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] output_value17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] input_value17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] int_mask17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] int_enable17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] int_disable17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] int_status17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] int_type17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] int_value17;
  rand bit [`GPIO_DATA_WIDTH17-1:0] int_on_any17;

  // this is a default constraint that could be overriden17
  // Constrain17 randomisation17 of configuration based on UVC17/RTL17 capabilities17
  constraint c_default_config17 { int_mask17         == 32'hFFFFFFFF;}

  // These17 declarations17 implement the create() and get_type_name() as well17 as enable automation17 of the
  // transfer17 fields   
  `uvm_object_utils_begin(gpio_csr17)
    `uvm_field_int(bypass_mode17,    UVM_ALL_ON)
    `uvm_field_int(direction_mode17, UVM_ALL_ON)
    `uvm_field_int(output_enable17,  UVM_ALL_ON)
    `uvm_field_int(output_value17,   UVM_ALL_ON)
    `uvm_field_int(input_value17,    UVM_ALL_ON)  
    `uvm_field_int(int_mask17,       UVM_ALL_ON)
    `uvm_field_int(int_enable17,     UVM_ALL_ON)
    `uvm_field_int(int_disable17,    UVM_ALL_ON)
    `uvm_field_int(int_status17,     UVM_ALL_ON)
    `uvm_field_int(int_type17,       UVM_ALL_ON)
    `uvm_field_int(int_value17,      UVM_ALL_ON)
    `uvm_field_int(int_on_any17,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This17 requires for registration17 of the ptp_tx_frame17   
  function new(string name = "gpio_csr17");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct17();
  endfunction 

  function void Copycfg_struct17();
    csr_s17.bypass_mode17    = bypass_mode17;
    csr_s17.direction_mode17 = direction_mode17;
    csr_s17.output_enable17  = output_enable17;
    csr_s17.output_value17   = output_value17;
    csr_s17.input_value17    = input_value17;
    csr_s17.int_mask17       = int_mask17;
    csr_s17.int_enable17     = int_enable17;
    csr_s17.int_disable17    = int_disable17;
    csr_s17.int_status17     = int_status17;
    csr_s17.int_type17       = int_type17;
    csr_s17.int_value17      = int_value17;
    csr_s17.int_on_any17     = int_on_any17;
  endfunction

endclass : gpio_csr17

`endif

