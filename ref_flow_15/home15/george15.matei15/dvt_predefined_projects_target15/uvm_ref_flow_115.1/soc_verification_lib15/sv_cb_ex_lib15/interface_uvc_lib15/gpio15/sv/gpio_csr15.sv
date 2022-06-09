/*-------------------------------------------------------------------------
File15 name   : gpio_csr15.sv
Title15       : GPIO15 SystemVerilog15 UVM UVC15
Project15     : SystemVerilog15 UVM Cluster15 Level15 Verification15
Created15     :
Description15 : 
Notes15       :  
---------------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV15
`define GPIO_CSR_SV15

typedef struct packed {
  bit [`GPIO_DATA_WIDTH15-1:0] bypass_mode15;
  bit [`GPIO_DATA_WIDTH15-1:0] direction_mode15;
  bit [`GPIO_DATA_WIDTH15-1:0] output_enable15;
  bit [`GPIO_DATA_WIDTH15-1:0] output_value15;
  bit [`GPIO_DATA_WIDTH15-1:0] input_value15;
  bit [`GPIO_DATA_WIDTH15-1:0] int_mask15;
  bit [`GPIO_DATA_WIDTH15-1:0] int_enable15;
  bit [`GPIO_DATA_WIDTH15-1:0] int_disable15;
  bit [`GPIO_DATA_WIDTH15-1:0] int_status15;
  bit [`GPIO_DATA_WIDTH15-1:0] int_type15;
  bit [`GPIO_DATA_WIDTH15-1:0] int_value15;
  bit [`GPIO_DATA_WIDTH15-1:0] int_on_any15;
  } gpio_csr_s15;

class gpio_csr15 extends uvm_object;

  //instance of CSRs15
  gpio_csr_s15 csr_s15;

  //randomize GPIO15 CSR15 fields
  rand bit [`GPIO_DATA_WIDTH15-1:0] bypass_mode15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] direction_mode15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] output_enable15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] output_value15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] input_value15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] int_mask15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] int_enable15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] int_disable15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] int_status15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] int_type15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] int_value15;
  rand bit [`GPIO_DATA_WIDTH15-1:0] int_on_any15;

  // this is a default constraint that could be overriden15
  // Constrain15 randomisation15 of configuration based on UVC15/RTL15 capabilities15
  constraint c_default_config15 { int_mask15         == 32'hFFFFFFFF;}

  // These15 declarations15 implement the create() and get_type_name() as well15 as enable automation15 of the
  // transfer15 fields   
  `uvm_object_utils_begin(gpio_csr15)
    `uvm_field_int(bypass_mode15,    UVM_ALL_ON)
    `uvm_field_int(direction_mode15, UVM_ALL_ON)
    `uvm_field_int(output_enable15,  UVM_ALL_ON)
    `uvm_field_int(output_value15,   UVM_ALL_ON)
    `uvm_field_int(input_value15,    UVM_ALL_ON)  
    `uvm_field_int(int_mask15,       UVM_ALL_ON)
    `uvm_field_int(int_enable15,     UVM_ALL_ON)
    `uvm_field_int(int_disable15,    UVM_ALL_ON)
    `uvm_field_int(int_status15,     UVM_ALL_ON)
    `uvm_field_int(int_type15,       UVM_ALL_ON)
    `uvm_field_int(int_value15,      UVM_ALL_ON)
    `uvm_field_int(int_on_any15,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This15 requires for registration15 of the ptp_tx_frame15   
  function new(string name = "gpio_csr15");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct15();
  endfunction 

  function void Copycfg_struct15();
    csr_s15.bypass_mode15    = bypass_mode15;
    csr_s15.direction_mode15 = direction_mode15;
    csr_s15.output_enable15  = output_enable15;
    csr_s15.output_value15   = output_value15;
    csr_s15.input_value15    = input_value15;
    csr_s15.int_mask15       = int_mask15;
    csr_s15.int_enable15     = int_enable15;
    csr_s15.int_disable15    = int_disable15;
    csr_s15.int_status15     = int_status15;
    csr_s15.int_type15       = int_type15;
    csr_s15.int_value15      = int_value15;
    csr_s15.int_on_any15     = int_on_any15;
  endfunction

endclass : gpio_csr15

`endif

