/*-------------------------------------------------------------------------
File20 name   : spi_csr20.sv
Title20       : SPI20 SystemVerilog20 UVM UVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV20
`define SPI_CSR_SV20

typedef struct packed {
  bit [7:0] n_ss_out20;
  bit [6:0] transfer_data_size20;
  bit [15:0] baud_rate_divisor20;
  bit tx_clk_phase20;
  bit rx_clk_phase20;
  bit mode_select20;

  bit tx_fifo_underflow20;
  bit rx_fifo_full20; 
  bit rx_fifo_not_empty20;
  bit tx_fifo_full20;
  bit tx_fifo_not_empty20;
  bit mode_fault20;
  bit rx_fifo_overrun20;

  bit spi_enable20;

  bit [7:0] d_btwn_slave_sel20;
  bit [7:0] d_btwn_word20;
  bit [7:0] d_btwn_senable_word20;

  int data_size20;
  } spi_csr_s20;

class spi_csr20 extends uvm_object;

  spi_csr_s20 csr_s20;

  //randomize SPI20 CSR20 fields
  rand bit [7:0] n_ss_out20;
  rand bit [6:0] transfer_data_size20;
  rand bit [15:0] baud_rate_divisor20;
  rand bit tx_clk_phase20;
  rand bit rx_clk_phase20;
  rand bit mode_select20;

  rand bit [7:0] d_btwn_slave_sel20;
  rand bit [7:0] d_btwn_word20;
  rand bit [7:0] d_btwn_senable_word20;

  rand bit spi_enable20;

  int data_size20;

  // this is a default constraint that could be overriden20
  // Constrain20 randomisation20 of configuration based on UVC20/RTL20 capabilities20
  constraint c_default_config20 {
    n_ss_out20           == 8'b01;
    transfer_data_size20 == 7'b0001000;
    baud_rate_divisor20  == 16'b0001;
    tx_clk_phase20       == 1'b0;
    rx_clk_phase20       == 1'b0;
    mode_select20        == 1'b1;

    d_btwn_slave_sel20   == 8'h00;
    d_btwn_word20        == 8'h00;
    d_btwn_senable_word20== 8'h00;

    spi_enable20         == 1'b1;
  }

  // These20 declarations20 implement the create() and get_type_name() as well20 as enable automation20 of the
  // transfer20 fields   
  `uvm_object_utils_begin(spi_csr20)
    `uvm_field_int(n_ss_out20,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size20,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor20,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase20,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase20,        UVM_ALL_ON)
    `uvm_field_int(mode_select20,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel20,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word20,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word20, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable20,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This20 requires for registration20 of the ptp_tx_frame20   
  function new(string name = "spi_csr20");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int20();
    Copycfg_struct20();
  endfunction 

  // function to convert the 2 bit transfer_data_size20 to integer
  function void get_data_size_as_int20();
    case(transfer_data_size20)
      16'b00 : data_size20 = 128;
      default : data_size20 = int'(transfer_data_size20);
    endcase
     `uvm_info("SPI20 CSR20", $psprintf("data size is %d", data_size20), UVM_MEDIUM)
  endfunction : get_data_size_as_int20
    
  function void Copycfg_struct20();
    csr_s20.n_ss_out20            = n_ss_out20;
    csr_s20.transfer_data_size20  = transfer_data_size20;
    csr_s20.baud_rate_divisor20   = baud_rate_divisor20;
    csr_s20.tx_clk_phase20        = tx_clk_phase20;
    csr_s20.rx_clk_phase20        = rx_clk_phase20;
    csr_s20.mode_select20         = mode_select20;

    csr_s20.d_btwn_slave_sel20     = d_btwn_slave_sel20;
    csr_s20.d_btwn_word20          = d_btwn_word20;
    csr_s20.d_btwn_senable_word20  = d_btwn_senable_word20;

    csr_s20.spi_enable20      = spi_enable20;

    csr_s20.data_size20      = data_size20;
  endfunction

endclass : spi_csr20

`endif

