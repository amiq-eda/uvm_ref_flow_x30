/*-------------------------------------------------------------------------
File21 name   : spi_csr21.sv
Title21       : SPI21 SystemVerilog21 UVM UVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV21
`define SPI_CSR_SV21

typedef struct packed {
  bit [7:0] n_ss_out21;
  bit [6:0] transfer_data_size21;
  bit [15:0] baud_rate_divisor21;
  bit tx_clk_phase21;
  bit rx_clk_phase21;
  bit mode_select21;

  bit tx_fifo_underflow21;
  bit rx_fifo_full21; 
  bit rx_fifo_not_empty21;
  bit tx_fifo_full21;
  bit tx_fifo_not_empty21;
  bit mode_fault21;
  bit rx_fifo_overrun21;

  bit spi_enable21;

  bit [7:0] d_btwn_slave_sel21;
  bit [7:0] d_btwn_word21;
  bit [7:0] d_btwn_senable_word21;

  int data_size21;
  } spi_csr_s21;

class spi_csr21 extends uvm_object;

  spi_csr_s21 csr_s21;

  //randomize SPI21 CSR21 fields
  rand bit [7:0] n_ss_out21;
  rand bit [6:0] transfer_data_size21;
  rand bit [15:0] baud_rate_divisor21;
  rand bit tx_clk_phase21;
  rand bit rx_clk_phase21;
  rand bit mode_select21;

  rand bit [7:0] d_btwn_slave_sel21;
  rand bit [7:0] d_btwn_word21;
  rand bit [7:0] d_btwn_senable_word21;

  rand bit spi_enable21;

  int data_size21;

  // this is a default constraint that could be overriden21
  // Constrain21 randomisation21 of configuration based on UVC21/RTL21 capabilities21
  constraint c_default_config21 {
    n_ss_out21           == 8'b01;
    transfer_data_size21 == 7'b0001000;
    baud_rate_divisor21  == 16'b0001;
    tx_clk_phase21       == 1'b0;
    rx_clk_phase21       == 1'b0;
    mode_select21        == 1'b1;

    d_btwn_slave_sel21   == 8'h00;
    d_btwn_word21        == 8'h00;
    d_btwn_senable_word21== 8'h00;

    spi_enable21         == 1'b1;
  }

  // These21 declarations21 implement the create() and get_type_name() as well21 as enable automation21 of the
  // transfer21 fields   
  `uvm_object_utils_begin(spi_csr21)
    `uvm_field_int(n_ss_out21,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size21,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor21,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase21,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase21,        UVM_ALL_ON)
    `uvm_field_int(mode_select21,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel21,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word21,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word21, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable21,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This21 requires for registration21 of the ptp_tx_frame21   
  function new(string name = "spi_csr21");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int21();
    Copycfg_struct21();
  endfunction 

  // function to convert the 2 bit transfer_data_size21 to integer
  function void get_data_size_as_int21();
    case(transfer_data_size21)
      16'b00 : data_size21 = 128;
      default : data_size21 = int'(transfer_data_size21);
    endcase
     `uvm_info("SPI21 CSR21", $psprintf("data size is %d", data_size21), UVM_MEDIUM)
  endfunction : get_data_size_as_int21
    
  function void Copycfg_struct21();
    csr_s21.n_ss_out21            = n_ss_out21;
    csr_s21.transfer_data_size21  = transfer_data_size21;
    csr_s21.baud_rate_divisor21   = baud_rate_divisor21;
    csr_s21.tx_clk_phase21        = tx_clk_phase21;
    csr_s21.rx_clk_phase21        = rx_clk_phase21;
    csr_s21.mode_select21         = mode_select21;

    csr_s21.d_btwn_slave_sel21     = d_btwn_slave_sel21;
    csr_s21.d_btwn_word21          = d_btwn_word21;
    csr_s21.d_btwn_senable_word21  = d_btwn_senable_word21;

    csr_s21.spi_enable21      = spi_enable21;

    csr_s21.data_size21      = data_size21;
  endfunction

endclass : spi_csr21

`endif

