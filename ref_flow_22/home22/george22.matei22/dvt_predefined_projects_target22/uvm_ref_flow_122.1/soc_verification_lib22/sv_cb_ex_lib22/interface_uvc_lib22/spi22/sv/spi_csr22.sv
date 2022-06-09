/*-------------------------------------------------------------------------
File22 name   : spi_csr22.sv
Title22       : SPI22 SystemVerilog22 UVM UVC22
Project22     : SystemVerilog22 UVM Cluster22 Level22 Verification22
Created22     :
Description22 : 
Notes22       :  
---------------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV22
`define SPI_CSR_SV22

typedef struct packed {
  bit [7:0] n_ss_out22;
  bit [6:0] transfer_data_size22;
  bit [15:0] baud_rate_divisor22;
  bit tx_clk_phase22;
  bit rx_clk_phase22;
  bit mode_select22;

  bit tx_fifo_underflow22;
  bit rx_fifo_full22; 
  bit rx_fifo_not_empty22;
  bit tx_fifo_full22;
  bit tx_fifo_not_empty22;
  bit mode_fault22;
  bit rx_fifo_overrun22;

  bit spi_enable22;

  bit [7:0] d_btwn_slave_sel22;
  bit [7:0] d_btwn_word22;
  bit [7:0] d_btwn_senable_word22;

  int data_size22;
  } spi_csr_s22;

class spi_csr22 extends uvm_object;

  spi_csr_s22 csr_s22;

  //randomize SPI22 CSR22 fields
  rand bit [7:0] n_ss_out22;
  rand bit [6:0] transfer_data_size22;
  rand bit [15:0] baud_rate_divisor22;
  rand bit tx_clk_phase22;
  rand bit rx_clk_phase22;
  rand bit mode_select22;

  rand bit [7:0] d_btwn_slave_sel22;
  rand bit [7:0] d_btwn_word22;
  rand bit [7:0] d_btwn_senable_word22;

  rand bit spi_enable22;

  int data_size22;

  // this is a default constraint that could be overriden22
  // Constrain22 randomisation22 of configuration based on UVC22/RTL22 capabilities22
  constraint c_default_config22 {
    n_ss_out22           == 8'b01;
    transfer_data_size22 == 7'b0001000;
    baud_rate_divisor22  == 16'b0001;
    tx_clk_phase22       == 1'b0;
    rx_clk_phase22       == 1'b0;
    mode_select22        == 1'b1;

    d_btwn_slave_sel22   == 8'h00;
    d_btwn_word22        == 8'h00;
    d_btwn_senable_word22== 8'h00;

    spi_enable22         == 1'b1;
  }

  // These22 declarations22 implement the create() and get_type_name() as well22 as enable automation22 of the
  // transfer22 fields   
  `uvm_object_utils_begin(spi_csr22)
    `uvm_field_int(n_ss_out22,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size22,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor22,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase22,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase22,        UVM_ALL_ON)
    `uvm_field_int(mode_select22,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel22,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word22,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word22, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable22,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This22 requires for registration22 of the ptp_tx_frame22   
  function new(string name = "spi_csr22");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int22();
    Copycfg_struct22();
  endfunction 

  // function to convert the 2 bit transfer_data_size22 to integer
  function void get_data_size_as_int22();
    case(transfer_data_size22)
      16'b00 : data_size22 = 128;
      default : data_size22 = int'(transfer_data_size22);
    endcase
     `uvm_info("SPI22 CSR22", $psprintf("data size is %d", data_size22), UVM_MEDIUM)
  endfunction : get_data_size_as_int22
    
  function void Copycfg_struct22();
    csr_s22.n_ss_out22            = n_ss_out22;
    csr_s22.transfer_data_size22  = transfer_data_size22;
    csr_s22.baud_rate_divisor22   = baud_rate_divisor22;
    csr_s22.tx_clk_phase22        = tx_clk_phase22;
    csr_s22.rx_clk_phase22        = rx_clk_phase22;
    csr_s22.mode_select22         = mode_select22;

    csr_s22.d_btwn_slave_sel22     = d_btwn_slave_sel22;
    csr_s22.d_btwn_word22          = d_btwn_word22;
    csr_s22.d_btwn_senable_word22  = d_btwn_senable_word22;

    csr_s22.spi_enable22      = spi_enable22;

    csr_s22.data_size22      = data_size22;
  endfunction

endclass : spi_csr22

`endif

