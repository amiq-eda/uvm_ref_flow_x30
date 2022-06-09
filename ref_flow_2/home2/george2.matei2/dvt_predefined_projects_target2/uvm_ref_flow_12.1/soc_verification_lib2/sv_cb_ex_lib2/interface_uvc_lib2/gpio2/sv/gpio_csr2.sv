/*-------------------------------------------------------------------------
File2 name   : gpio_csr2.sv
Title2       : GPIO2 SystemVerilog2 UVM UVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef GPIO_CSR_SV2
`define GPIO_CSR_SV2

typedef struct packed {
  bit [`GPIO_DATA_WIDTH2-1:0] bypass_mode2;
  bit [`GPIO_DATA_WIDTH2-1:0] direction_mode2;
  bit [`GPIO_DATA_WIDTH2-1:0] output_enable2;
  bit [`GPIO_DATA_WIDTH2-1:0] output_value2;
  bit [`GPIO_DATA_WIDTH2-1:0] input_value2;
  bit [`GPIO_DATA_WIDTH2-1:0] int_mask2;
  bit [`GPIO_DATA_WIDTH2-1:0] int_enable2;
  bit [`GPIO_DATA_WIDTH2-1:0] int_disable2;
  bit [`GPIO_DATA_WIDTH2-1:0] int_status2;
  bit [`GPIO_DATA_WIDTH2-1:0] int_type2;
  bit [`GPIO_DATA_WIDTH2-1:0] int_value2;
  bit [`GPIO_DATA_WIDTH2-1:0] int_on_any2;
  } gpio_csr_s2;

class gpio_csr2 extends uvm_object;

  //instance of CSRs2
  gpio_csr_s2 csr_s2;

  //randomize GPIO2 CSR2 fields
  rand bit [`GPIO_DATA_WIDTH2-1:0] bypass_mode2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] direction_mode2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] output_enable2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] output_value2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] input_value2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] int_mask2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] int_enable2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] int_disable2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] int_status2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] int_type2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] int_value2;
  rand bit [`GPIO_DATA_WIDTH2-1:0] int_on_any2;

  // this is a default constraint that could be overriden2
  // Constrain2 randomisation2 of configuration based on UVC2/RTL2 capabilities2
  constraint c_default_config2 { int_mask2         == 32'hFFFFFFFF;}

  // These2 declarations2 implement the create() and get_type_name() as well2 as enable automation2 of the
  // transfer2 fields   
  `uvm_object_utils_begin(gpio_csr2)
    `uvm_field_int(bypass_mode2,    UVM_ALL_ON)
    `uvm_field_int(direction_mode2, UVM_ALL_ON)
    `uvm_field_int(output_enable2,  UVM_ALL_ON)
    `uvm_field_int(output_value2,   UVM_ALL_ON)
    `uvm_field_int(input_value2,    UVM_ALL_ON)  
    `uvm_field_int(int_mask2,       UVM_ALL_ON)
    `uvm_field_int(int_enable2,     UVM_ALL_ON)
    `uvm_field_int(int_disable2,    UVM_ALL_ON)
    `uvm_field_int(int_status2,     UVM_ALL_ON)
    `uvm_field_int(int_type2,       UVM_ALL_ON)
    `uvm_field_int(int_value2,      UVM_ALL_ON)
    `uvm_field_int(int_on_any2,     UVM_ALL_ON)
  `uvm_object_utils_end

  // This2 requires for registration2 of the ptp_tx_frame2   
  function new(string name = "gpio_csr2");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    Copycfg_struct2();
  endfunction 

  function void Copycfg_struct2();
    csr_s2.bypass_mode2    = bypass_mode2;
    csr_s2.direction_mode2 = direction_mode2;
    csr_s2.output_enable2  = output_enable2;
    csr_s2.output_value2   = output_value2;
    csr_s2.input_value2    = input_value2;
    csr_s2.int_mask2       = int_mask2;
    csr_s2.int_enable2     = int_enable2;
    csr_s2.int_disable2    = int_disable2;
    csr_s2.int_status2     = int_status2;
    csr_s2.int_type2       = int_type2;
    csr_s2.int_value2      = int_value2;
    csr_s2.int_on_any2     = int_on_any2;
  endfunction

endclass : gpio_csr2

`endif

