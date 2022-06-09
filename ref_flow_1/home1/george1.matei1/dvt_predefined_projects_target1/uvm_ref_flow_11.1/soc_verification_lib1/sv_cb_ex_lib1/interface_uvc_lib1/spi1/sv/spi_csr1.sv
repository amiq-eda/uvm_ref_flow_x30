/*-------------------------------------------------------------------------
File1 name   : spi_csr1.sv
Title1       : SPI1 SystemVerilog1 UVM UVC1
Project1     : SystemVerilog1 UVM Cluster1 Level1 Verification1
Created1     :
Description1 : 
Notes1       :  
---------------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV1
`define SPI_CSR_SV1

typedef struct packed {
  bit [7:0] n_ss_out1;
  bit [6:0] transfer_data_size1;
  bit [15:0] baud_rate_divisor1;
  bit tx_clk_phase1;
  bit rx_clk_phase1;
  bit mode_select1;

  bit tx_fifo_underflow1;
  bit rx_fifo_full1; 
  bit rx_fifo_not_empty1;
  bit tx_fifo_full1;
  bit tx_fifo_not_empty1;
  bit mode_fault1;
  bit rx_fifo_overrun1;

  bit spi_enable1;

  bit [7:0] d_btwn_slave_sel1;
  bit [7:0] d_btwn_word1;
  bit [7:0] d_btwn_senable_word1;

  int data_size1;
  } spi_csr_s1;

class spi_csr1 extends uvm_object;

  spi_csr_s1 csr_s1;

  //randomize SPI1 CSR1 fields
  rand bit [7:0] n_ss_out1;
  rand bit [6:0] transfer_data_size1;
  rand bit [15:0] baud_rate_divisor1;
  rand bit tx_clk_phase1;
  rand bit rx_clk_phase1;
  rand bit mode_select1;

  rand bit [7:0] d_btwn_slave_sel1;
  rand bit [7:0] d_btwn_word1;
  rand bit [7:0] d_btwn_senable_word1;

  rand bit spi_enable1;

  int data_size1;

  // this is a default constraint that could be overriden1
  // Constrain1 randomisation1 of configuration based on UVC1/RTL1 capabilities1
  constraint c_default_config1 {
    n_ss_out1           == 8'b01;
    transfer_data_size1 == 7'b0001000;
    baud_rate_divisor1  == 16'b0001;
    tx_clk_phase1       == 1'b0;
    rx_clk_phase1       == 1'b0;
    mode_select1        == 1'b1;

    d_btwn_slave_sel1   == 8'h00;
    d_btwn_word1        == 8'h00;
    d_btwn_senable_word1== 8'h00;

    spi_enable1         == 1'b1;
  }

  // These1 declarations1 implement the create() and get_type_name() as well1 as enable automation1 of the
  // transfer1 fields   
  `uvm_object_utils_begin(spi_csr1)
    `uvm_field_int(n_ss_out1,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size1,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor1,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase1,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase1,        UVM_ALL_ON)
    `uvm_field_int(mode_select1,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel1,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word1,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word1, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable1,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This1 requires for registration1 of the ptp_tx_frame1   
  function new(string name = "spi_csr1");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int1();
    Copycfg_struct1();
  endfunction 

  // function to convert the 2 bit transfer_data_size1 to integer
  function void get_data_size_as_int1();
    case(transfer_data_size1)
      16'b00 : data_size1 = 128;
      default : data_size1 = int'(transfer_data_size1);
    endcase
     `uvm_info("SPI1 CSR1", $psprintf("data size is %d", data_size1), UVM_MEDIUM)
  endfunction : get_data_size_as_int1
    
  function void Copycfg_struct1();
    csr_s1.n_ss_out1            = n_ss_out1;
    csr_s1.transfer_data_size1  = transfer_data_size1;
    csr_s1.baud_rate_divisor1   = baud_rate_divisor1;
    csr_s1.tx_clk_phase1        = tx_clk_phase1;
    csr_s1.rx_clk_phase1        = rx_clk_phase1;
    csr_s1.mode_select1         = mode_select1;

    csr_s1.d_btwn_slave_sel1     = d_btwn_slave_sel1;
    csr_s1.d_btwn_word1          = d_btwn_word1;
    csr_s1.d_btwn_senable_word1  = d_btwn_senable_word1;

    csr_s1.spi_enable1      = spi_enable1;

    csr_s1.data_size1      = data_size1;
  endfunction

endclass : spi_csr1

`endif

