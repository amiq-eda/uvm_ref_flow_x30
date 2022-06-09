/*-------------------------------------------------------------------------
File4 name   : gpio_csr4.sv
Title4       : GPIO4 SystemVerilog4 UVM UVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV4
`define GPIO_CSR_SV4

typedef struct packed {
  bit [`GPIO_DATA_WIDTH4-1:0] bypass_mode4;
  bit [`GPIO_DATA_WIDTH4-1:0] direction_mode4;
  bit [`GPIO_DATA_WIDTH4-1:0] output_enable4;
  bit [`GPIO_DATA_WIDTH4-1:0] output_value4;
  bit [`GPIO_DATA_WIDTH4-1:0] input_value4;
  bit [`GPIO_DATA_WIDTH4-1:0] int_mask4;
  bit [`GPIO_DATA_WIDTH4-1:0] int_enable4;
  bit [`GPIO_DATA_WIDTH4-1:0] int_disable4;
  bit [`GPIO_DATA_WIDTH4-1:0] int_status4;
  bit [`GPIO_DATA_WIDTH4-1:0] int_type4;
  bit [`GPIO_DATA_WIDTH4-1:0] int_value4;
  bit [`GPIO_DATA_WIDTH4-1:0] int_on_any4;
  } gpio_csr_s4;

class gpio_csr4 extends uvm_object;

  //instance of CSRs4
  gpio_csr_s4 csr_s4;

  //randomize GPIO4 CSR4 fields
  rand bit [`GPIO_DATA_WIDTH4-1:0] bypass_mode4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] direction_mode4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] output_enable4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] output_value4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] input_value4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] int_mask4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] int_enable4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] int_disable4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] int_status4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] int_type4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] int_value4;
  rand bit [`GPIO_DATA_WIDTH4-1:0] int_on_any4;

  // this is a default constraint that could be overriden4
  // Constrain4 randomisation4 of configuration based on UVC4/RTL4 capabilities4
  constraint c_default_config4 { int_mask4         == 32'hFFFFFFFF;}

  // These4 declarations4 implement the create() and get_type_name() as well4 as enable automation4 of the
  // transfer4 fields   
  `uvm_object_utils_begin(gpio_csr4)
    `uvm_field_int(bypass_mode4,    UVM_ALL_ON)
    `uvm_field_int(direction_mode4, UVM_ALL_ON)
    `uvm_field_int(output_enable4,  UVM_ALL_ON)
    `uvm_field_int(output_value4,   UVM_ALL_ON)
    `uvm_field_int(input_value4,    UVM_ALL_ON)  
    `uvm_field_int(int_mask4,       UVM_ALL_ON)
    `uvm_field_int(int_enable4,     UVM_ALL_ON)
    `uvm_field_int(int_disable4,    UVM_ALL_ON)
    `uvm_field_int(int_status4,     UVM_ALL_ON)
    `uvm_field_int(int_type4,       UVM_ALL_ON)
    `uvm_field_int(int_value4,      UVM_ALL_ON)
    `uvm_field_int(int_on_any4,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This4 requires for registration4 of the ptp_tx_frame4   
  function new(string name = "gpio_csr4");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct4();
  endfunction 

  function void Copycfg_struct4();
    csr_s4.bypass_mode4    = bypass_mode4;
    csr_s4.direction_mode4 = direction_mode4;
    csr_s4.output_enable4  = output_enable4;
    csr_s4.output_value4   = output_value4;
    csr_s4.input_value4    = input_value4;
    csr_s4.int_mask4       = int_mask4;
    csr_s4.int_enable4     = int_enable4;
    csr_s4.int_disable4    = int_disable4;
    csr_s4.int_status4     = int_status4;
    csr_s4.int_type4       = int_type4;
    csr_s4.int_value4      = int_value4;
    csr_s4.int_on_any4     = int_on_any4;
  endfunction

endclass : gpio_csr4

`endif

