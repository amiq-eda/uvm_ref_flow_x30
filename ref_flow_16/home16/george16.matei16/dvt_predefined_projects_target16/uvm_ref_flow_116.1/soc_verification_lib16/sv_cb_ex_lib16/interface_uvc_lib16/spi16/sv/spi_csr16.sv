/*-------------------------------------------------------------------------
File16 name   : spi_csr16.sv
Title16       : SPI16 SystemVerilog16 UVM UVC16
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


`ifndef SPI_CSR_SV16
`define SPI_CSR_SV16

typedef struct packed {
  bit [7:0] n_ss_out16;
  bit [6:0] transfer_data_size16;
  bit [15:0] baud_rate_divisor16;
  bit tx_clk_phase16;
  bit rx_clk_phase16;
  bit mode_select16;

  bit tx_fifo_underflow16;
  bit rx_fifo_full16; 
  bit rx_fifo_not_empty16;
  bit tx_fifo_full16;
  bit tx_fifo_not_empty16;
  bit mode_fault16;
  bit rx_fifo_overrun16;

  bit spi_enable16;

  bit [7:0] d_btwn_slave_sel16;
  bit [7:0] d_btwn_word16;
  bit [7:0] d_btwn_senable_word16;

  int data_size16;
  } spi_csr_s16;

class spi_csr16 extends uvm_object;

  spi_csr_s16 csr_s16;

  //randomize SPI16 CSR16 fields
  rand bit [7:0] n_ss_out16;
  rand bit [6:0] transfer_data_size16;
  rand bit [15:0] baud_rate_divisor16;
  rand bit tx_clk_phase16;
  rand bit rx_clk_phase16;
  rand bit mode_select16;

  rand bit [7:0] d_btwn_slave_sel16;
  rand bit [7:0] d_btwn_word16;
  rand bit [7:0] d_btwn_senable_word16;

  rand bit spi_enable16;

  int data_size16;

  // this is a default constraint that could be overriden16
  // Constrain16 randomisation16 of configuration based on UVC16/RTL16 capabilities16
  constraint c_default_config16 {
    n_ss_out16           == 8'b01;
    transfer_data_size16 == 7'b0001000;
    baud_rate_divisor16  == 16'b0001;
    tx_clk_phase16       == 1'b0;
    rx_clk_phase16       == 1'b0;
    mode_select16        == 1'b1;

    d_btwn_slave_sel16   == 8'h00;
    d_btwn_word16        == 8'h00;
    d_btwn_senable_word16== 8'h00;

    spi_enable16         == 1'b1;
  }

  // These16 declarations16 implement the create() and get_type_name() as well16 as enable automation16 of the
  // transfer16 fields   
  `uvm_object_utils_begin(spi_csr16)
    `uvm_field_int(n_ss_out16,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size16,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor16,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase16,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase16,        UVM_ALL_ON)
    `uvm_field_int(mode_select16,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel16,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word16,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word16, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable16,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This16 requires for registration16 of the ptp_tx_frame16   
  function new(string name = "spi_csr16");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int16();
    Copycfg_struct16();
  endfunction 

  // function to convert the 2 bit transfer_data_size16 to integer
  function void get_data_size_as_int16();
    case(transfer_data_size16)
      16'b00 : data_size16 = 128;
      default : data_size16 = int'(transfer_data_size16);
    endcase
     `uvm_info("SPI16 CSR16", $psprintf("data size is %d", data_size16), UVM_MEDIUM)
  endfunction : get_data_size_as_int16
    
  function void Copycfg_struct16();
    csr_s16.n_ss_out16            = n_ss_out16;
    csr_s16.transfer_data_size16  = transfer_data_size16;
    csr_s16.baud_rate_divisor16   = baud_rate_divisor16;
    csr_s16.tx_clk_phase16        = tx_clk_phase16;
    csr_s16.rx_clk_phase16        = rx_clk_phase16;
    csr_s16.mode_select16         = mode_select16;

    csr_s16.d_btwn_slave_sel16     = d_btwn_slave_sel16;
    csr_s16.d_btwn_word16          = d_btwn_word16;
    csr_s16.d_btwn_senable_word16  = d_btwn_senable_word16;

    csr_s16.spi_enable16      = spi_enable16;

    csr_s16.data_size16      = data_size16;
  endfunction

endclass : spi_csr16

`endif

