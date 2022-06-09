/*-------------------------------------------------------------------------
File2 name   : spi_csr2.sv
Title2       : SPI2 SystemVerilog2 UVM UVC2
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


`ifndef SPI_CSR_SV2
`define SPI_CSR_SV2

typedef struct packed {
  bit [7:0] n_ss_out2;
  bit [6:0] transfer_data_size2;
  bit [15:0] baud_rate_divisor2;
  bit tx_clk_phase2;
  bit rx_clk_phase2;
  bit mode_select2;

  bit tx_fifo_underflow2;
  bit rx_fifo_full2; 
  bit rx_fifo_not_empty2;
  bit tx_fifo_full2;
  bit tx_fifo_not_empty2;
  bit mode_fault2;
  bit rx_fifo_overrun2;

  bit spi_enable2;

  bit [7:0] d_btwn_slave_sel2;
  bit [7:0] d_btwn_word2;
  bit [7:0] d_btwn_senable_word2;

  int data_size2;
  } spi_csr_s2;

class spi_csr2 extends uvm_object;

  spi_csr_s2 csr_s2;

  //randomize SPI2 CSR2 fields
  rand bit [7:0] n_ss_out2;
  rand bit [6:0] transfer_data_size2;
  rand bit [15:0] baud_rate_divisor2;
  rand bit tx_clk_phase2;
  rand bit rx_clk_phase2;
  rand bit mode_select2;

  rand bit [7:0] d_btwn_slave_sel2;
  rand bit [7:0] d_btwn_word2;
  rand bit [7:0] d_btwn_senable_word2;

  rand bit spi_enable2;

  int data_size2;

  // this is a default constraint that could be overriden2
  // Constrain2 randomisation2 of configuration based on UVC2/RTL2 capabilities2
  constraint c_default_config2 {
    n_ss_out2           == 8'b01;
    transfer_data_size2 == 7'b0001000;
    baud_rate_divisor2  == 16'b0001;
    tx_clk_phase2       == 1'b0;
    rx_clk_phase2       == 1'b0;
    mode_select2        == 1'b1;

    d_btwn_slave_sel2   == 8'h00;
    d_btwn_word2        == 8'h00;
    d_btwn_senable_word2== 8'h00;

    spi_enable2         == 1'b1;
  }

  // These2 declarations2 implement the create() and get_type_name() as well2 as enable automation2 of the
  // transfer2 fields   
  `uvm_object_utils_begin(spi_csr2)
    `uvm_field_int(n_ss_out2,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size2,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor2,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase2,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase2,        UVM_ALL_ON)
    `uvm_field_int(mode_select2,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel2,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word2,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word2, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable2,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This2 requires for registration2 of the ptp_tx_frame2   
  function new(string name = "spi_csr2");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int2();
    Copycfg_struct2();
  endfunction 

  // function to convert the 2 bit transfer_data_size2 to integer
  function void get_data_size_as_int2();
    case(transfer_data_size2)
      16'b00 : data_size2 = 128;
      default : data_size2 = int'(transfer_data_size2);
    endcase
     `uvm_info("SPI2 CSR2", $psprintf("data size is %d", data_size2), UVM_MEDIUM)
  endfunction : get_data_size_as_int2
    
  function void Copycfg_struct2();
    csr_s2.n_ss_out2            = n_ss_out2;
    csr_s2.transfer_data_size2  = transfer_data_size2;
    csr_s2.baud_rate_divisor2   = baud_rate_divisor2;
    csr_s2.tx_clk_phase2        = tx_clk_phase2;
    csr_s2.rx_clk_phase2        = rx_clk_phase2;
    csr_s2.mode_select2         = mode_select2;

    csr_s2.d_btwn_slave_sel2     = d_btwn_slave_sel2;
    csr_s2.d_btwn_word2          = d_btwn_word2;
    csr_s2.d_btwn_senable_word2  = d_btwn_senable_word2;

    csr_s2.spi_enable2      = spi_enable2;

    csr_s2.data_size2      = data_size2;
  endfunction

endclass : spi_csr2

`endif

