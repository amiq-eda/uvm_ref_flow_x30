/*-------------------------------------------------------------------------
File4 name   : spi_csr4.sv
Title4       : SPI4 SystemVerilog4 UVM UVC4
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


`ifndef SPI_CSR_SV4
`define SPI_CSR_SV4

typedef struct packed {
  bit [7:0] n_ss_out4;
  bit [6:0] transfer_data_size4;
  bit [15:0] baud_rate_divisor4;
  bit tx_clk_phase4;
  bit rx_clk_phase4;
  bit mode_select4;

  bit tx_fifo_underflow4;
  bit rx_fifo_full4; 
  bit rx_fifo_not_empty4;
  bit tx_fifo_full4;
  bit tx_fifo_not_empty4;
  bit mode_fault4;
  bit rx_fifo_overrun4;

  bit spi_enable4;

  bit [7:0] d_btwn_slave_sel4;
  bit [7:0] d_btwn_word4;
  bit [7:0] d_btwn_senable_word4;

  int data_size4;
  } spi_csr_s4;

class spi_csr4 extends uvm_object;

  spi_csr_s4 csr_s4;

  //randomize SPI4 CSR4 fields
  rand bit [7:0] n_ss_out4;
  rand bit [6:0] transfer_data_size4;
  rand bit [15:0] baud_rate_divisor4;
  rand bit tx_clk_phase4;
  rand bit rx_clk_phase4;
  rand bit mode_select4;

  rand bit [7:0] d_btwn_slave_sel4;
  rand bit [7:0] d_btwn_word4;
  rand bit [7:0] d_btwn_senable_word4;

  rand bit spi_enable4;

  int data_size4;

  // this is a default constraint that could be overriden4
  // Constrain4 randomisation4 of configuration based on UVC4/RTL4 capabilities4
  constraint c_default_config4 {
    n_ss_out4           == 8'b01;
    transfer_data_size4 == 7'b0001000;
    baud_rate_divisor4  == 16'b0001;
    tx_clk_phase4       == 1'b0;
    rx_clk_phase4       == 1'b0;
    mode_select4        == 1'b1;

    d_btwn_slave_sel4   == 8'h00;
    d_btwn_word4        == 8'h00;
    d_btwn_senable_word4== 8'h00;

    spi_enable4         == 1'b1;
  }

  // These4 declarations4 implement the create() and get_type_name() as well4 as enable automation4 of the
  // transfer4 fields   
  `uvm_object_utils_begin(spi_csr4)
    `uvm_field_int(n_ss_out4,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size4,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor4,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase4,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase4,        UVM_ALL_ON)
    `uvm_field_int(mode_select4,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel4,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word4,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word4, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable4,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This4 requires for registration4 of the ptp_tx_frame4   
  function new(string name = "spi_csr4");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int4();
    Copycfg_struct4();
  endfunction 

  // function to convert the 2 bit transfer_data_size4 to integer
  function void get_data_size_as_int4();
    case(transfer_data_size4)
      16'b00 : data_size4 = 128;
      default : data_size4 = int'(transfer_data_size4);
    endcase
     `uvm_info("SPI4 CSR4", $psprintf("data size is %d", data_size4), UVM_MEDIUM)
  endfunction : get_data_size_as_int4
    
  function void Copycfg_struct4();
    csr_s4.n_ss_out4            = n_ss_out4;
    csr_s4.transfer_data_size4  = transfer_data_size4;
    csr_s4.baud_rate_divisor4   = baud_rate_divisor4;
    csr_s4.tx_clk_phase4        = tx_clk_phase4;
    csr_s4.rx_clk_phase4        = rx_clk_phase4;
    csr_s4.mode_select4         = mode_select4;

    csr_s4.d_btwn_slave_sel4     = d_btwn_slave_sel4;
    csr_s4.d_btwn_word4          = d_btwn_word4;
    csr_s4.d_btwn_senable_word4  = d_btwn_senable_word4;

    csr_s4.spi_enable4      = spi_enable4;

    csr_s4.data_size4      = data_size4;
  endfunction

endclass : spi_csr4

`endif

