/*-------------------------------------------------------------------------
File12 name   : gpio_csr12.sv
Title12       : GPIO12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV12
`define GPIO_CSR_SV12

typedef struct packed {
  bit [`GPIO_DATA_WIDTH12-1:0] bypass_mode12;
  bit [`GPIO_DATA_WIDTH12-1:0] direction_mode12;
  bit [`GPIO_DATA_WIDTH12-1:0] output_enable12;
  bit [`GPIO_DATA_WIDTH12-1:0] output_value12;
  bit [`GPIO_DATA_WIDTH12-1:0] input_value12;
  bit [`GPIO_DATA_WIDTH12-1:0] int_mask12;
  bit [`GPIO_DATA_WIDTH12-1:0] int_enable12;
  bit [`GPIO_DATA_WIDTH12-1:0] int_disable12;
  bit [`GPIO_DATA_WIDTH12-1:0] int_status12;
  bit [`GPIO_DATA_WIDTH12-1:0] int_type12;
  bit [`GPIO_DATA_WIDTH12-1:0] int_value12;
  bit [`GPIO_DATA_WIDTH12-1:0] int_on_any12;
  } gpio_csr_s12;

class gpio_csr12 extends uvm_object;

  //instance of CSRs12
  gpio_csr_s12 csr_s12;

  //randomize GPIO12 CSR12 fields
  rand bit [`GPIO_DATA_WIDTH12-1:0] bypass_mode12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] direction_mode12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] output_enable12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] output_value12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] input_value12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] int_mask12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] int_enable12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] int_disable12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] int_status12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] int_type12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] int_value12;
  rand bit [`GPIO_DATA_WIDTH12-1:0] int_on_any12;

  // this is a default constraint that could be overriden12
  // Constrain12 randomisation12 of configuration based on UVC12/RTL12 capabilities12
  constraint c_default_config12 { int_mask12         == 32'hFFFFFFFF;}

  // These12 declarations12 implement the create() and get_type_name() as well12 as enable automation12 of the
  // transfer12 fields   
  `uvm_object_utils_begin(gpio_csr12)
    `uvm_field_int(bypass_mode12,    UVM_ALL_ON)
    `uvm_field_int(direction_mode12, UVM_ALL_ON)
    `uvm_field_int(output_enable12,  UVM_ALL_ON)
    `uvm_field_int(output_value12,   UVM_ALL_ON)
    `uvm_field_int(input_value12,    UVM_ALL_ON)  
    `uvm_field_int(int_mask12,       UVM_ALL_ON)
    `uvm_field_int(int_enable12,     UVM_ALL_ON)
    `uvm_field_int(int_disable12,    UVM_ALL_ON)
    `uvm_field_int(int_status12,     UVM_ALL_ON)
    `uvm_field_int(int_type12,       UVM_ALL_ON)
    `uvm_field_int(int_value12,      UVM_ALL_ON)
    `uvm_field_int(int_on_any12,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This12 requires for registration12 of the ptp_tx_frame12   
  function new(string name = "gpio_csr12");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct12();
  endfunction 

  function void Copycfg_struct12();
    csr_s12.bypass_mode12    = bypass_mode12;
    csr_s12.direction_mode12 = direction_mode12;
    csr_s12.output_enable12  = output_enable12;
    csr_s12.output_value12   = output_value12;
    csr_s12.input_value12    = input_value12;
    csr_s12.int_mask12       = int_mask12;
    csr_s12.int_enable12     = int_enable12;
    csr_s12.int_disable12    = int_disable12;
    csr_s12.int_status12     = int_status12;
    csr_s12.int_type12       = int_type12;
    csr_s12.int_value12      = int_value12;
    csr_s12.int_on_any12     = int_on_any12;
  endfunction

endclass : gpio_csr12

`endif

