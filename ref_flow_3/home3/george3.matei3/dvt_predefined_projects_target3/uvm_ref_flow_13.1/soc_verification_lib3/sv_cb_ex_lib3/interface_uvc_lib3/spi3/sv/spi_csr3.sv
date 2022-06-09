/*-------------------------------------------------------------------------
File3 name   : spi_csr3.sv
Title3       : SPI3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV3
`define SPI_CSR_SV3

typedef struct packed {
  bit [7:0] n_ss_out3;
  bit [6:0] transfer_data_size3;
  bit [15:0] baud_rate_divisor3;
  bit tx_clk_phase3;
  bit rx_clk_phase3;
  bit mode_select3;

  bit tx_fifo_underflow3;
  bit rx_fifo_full3; 
  bit rx_fifo_not_empty3;
  bit tx_fifo_full3;
  bit tx_fifo_not_empty3;
  bit mode_fault3;
  bit rx_fifo_overrun3;

  bit spi_enable3;

  bit [7:0] d_btwn_slave_sel3;
  bit [7:0] d_btwn_word3;
  bit [7:0] d_btwn_senable_word3;

  int data_size3;
  } spi_csr_s3;

class spi_csr3 extends uvm_object;

  spi_csr_s3 csr_s3;

  //randomize SPI3 CSR3 fields
  rand bit [7:0] n_ss_out3;
  rand bit [6:0] transfer_data_size3;
  rand bit [15:0] baud_rate_divisor3;
  rand bit tx_clk_phase3;
  rand bit rx_clk_phase3;
  rand bit mode_select3;

  rand bit [7:0] d_btwn_slave_sel3;
  rand bit [7:0] d_btwn_word3;
  rand bit [7:0] d_btwn_senable_word3;

  rand bit spi_enable3;

  int data_size3;

  // this is a default constraint that could be overriden3
  // Constrain3 randomisation3 of configuration based on UVC3/RTL3 capabilities3
  constraint c_default_config3 {
    n_ss_out3           == 8'b01;
    transfer_data_size3 == 7'b0001000;
    baud_rate_divisor3  == 16'b0001;
    tx_clk_phase3       == 1'b0;
    rx_clk_phase3       == 1'b0;
    mode_select3        == 1'b1;

    d_btwn_slave_sel3   == 8'h00;
    d_btwn_word3        == 8'h00;
    d_btwn_senable_word3== 8'h00;

    spi_enable3         == 1'b1;
  }

  // These3 declarations3 implement the create() and get_type_name() as well3 as enable automation3 of the
  // transfer3 fields   
  `uvm_object_utils_begin(spi_csr3)
    `uvm_field_int(n_ss_out3,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size3,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor3,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase3,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase3,        UVM_ALL_ON)
    `uvm_field_int(mode_select3,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel3,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word3,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word3, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable3,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This3 requires for registration3 of the ptp_tx_frame3   
  function new(string name = "spi_csr3");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int3();
    Copycfg_struct3();
  endfunction 

  // function to convert the 2 bit transfer_data_size3 to integer
  function void get_data_size_as_int3();
    case(transfer_data_size3)
      16'b00 : data_size3 = 128;
      default : data_size3 = int'(transfer_data_size3);
    endcase
     `uvm_info("SPI3 CSR3", $psprintf("data size is %d", data_size3), UVM_MEDIUM)
  endfunction : get_data_size_as_int3
    
  function void Copycfg_struct3();
    csr_s3.n_ss_out3            = n_ss_out3;
    csr_s3.transfer_data_size3  = transfer_data_size3;
    csr_s3.baud_rate_divisor3   = baud_rate_divisor3;
    csr_s3.tx_clk_phase3        = tx_clk_phase3;
    csr_s3.rx_clk_phase3        = rx_clk_phase3;
    csr_s3.mode_select3         = mode_select3;

    csr_s3.d_btwn_slave_sel3     = d_btwn_slave_sel3;
    csr_s3.d_btwn_word3          = d_btwn_word3;
    csr_s3.d_btwn_senable_word3  = d_btwn_senable_word3;

    csr_s3.spi_enable3      = spi_enable3;

    csr_s3.data_size3      = data_size3;
  endfunction

endclass : spi_csr3

`endif

