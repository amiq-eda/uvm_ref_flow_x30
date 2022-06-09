/*-------------------------------------------------------------------------
File9 name   : spi_csr9.sv
Title9       : SPI9 SystemVerilog9 UVM UVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV9
`define SPI_CSR_SV9

typedef struct packed {
  bit [7:0] n_ss_out9;
  bit [6:0] transfer_data_size9;
  bit [15:0] baud_rate_divisor9;
  bit tx_clk_phase9;
  bit rx_clk_phase9;
  bit mode_select9;

  bit tx_fifo_underflow9;
  bit rx_fifo_full9; 
  bit rx_fifo_not_empty9;
  bit tx_fifo_full9;
  bit tx_fifo_not_empty9;
  bit mode_fault9;
  bit rx_fifo_overrun9;

  bit spi_enable9;

  bit [7:0] d_btwn_slave_sel9;
  bit [7:0] d_btwn_word9;
  bit [7:0] d_btwn_senable_word9;

  int data_size9;
  } spi_csr_s9;

class spi_csr9 extends uvm_object;

  spi_csr_s9 csr_s9;

  //randomize SPI9 CSR9 fields
  rand bit [7:0] n_ss_out9;
  rand bit [6:0] transfer_data_size9;
  rand bit [15:0] baud_rate_divisor9;
  rand bit tx_clk_phase9;
  rand bit rx_clk_phase9;
  rand bit mode_select9;

  rand bit [7:0] d_btwn_slave_sel9;
  rand bit [7:0] d_btwn_word9;
  rand bit [7:0] d_btwn_senable_word9;

  rand bit spi_enable9;

  int data_size9;

  // this is a default constraint that could be overriden9
  // Constrain9 randomisation9 of configuration based on UVC9/RTL9 capabilities9
  constraint c_default_config9 {
    n_ss_out9           == 8'b01;
    transfer_data_size9 == 7'b0001000;
    baud_rate_divisor9  == 16'b0001;
    tx_clk_phase9       == 1'b0;
    rx_clk_phase9       == 1'b0;
    mode_select9        == 1'b1;

    d_btwn_slave_sel9   == 8'h00;
    d_btwn_word9        == 8'h00;
    d_btwn_senable_word9== 8'h00;

    spi_enable9         == 1'b1;
  }

  // These9 declarations9 implement the create() and get_type_name() as well9 as enable automation9 of the
  // transfer9 fields   
  `uvm_object_utils_begin(spi_csr9)
    `uvm_field_int(n_ss_out9,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size9,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor9,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase9,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase9,        UVM_ALL_ON)
    `uvm_field_int(mode_select9,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel9,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word9,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word9, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable9,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This9 requires for registration9 of the ptp_tx_frame9   
  function new(string name = "spi_csr9");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int9();
    Copycfg_struct9();
  endfunction 

  // function to convert the 2 bit transfer_data_size9 to integer
  function void get_data_size_as_int9();
    case(transfer_data_size9)
      16'b00 : data_size9 = 128;
      default : data_size9 = int'(transfer_data_size9);
    endcase
     `uvm_info("SPI9 CSR9", $psprintf("data size is %d", data_size9), UVM_MEDIUM)
  endfunction : get_data_size_as_int9
    
  function void Copycfg_struct9();
    csr_s9.n_ss_out9            = n_ss_out9;
    csr_s9.transfer_data_size9  = transfer_data_size9;
    csr_s9.baud_rate_divisor9   = baud_rate_divisor9;
    csr_s9.tx_clk_phase9        = tx_clk_phase9;
    csr_s9.rx_clk_phase9        = rx_clk_phase9;
    csr_s9.mode_select9         = mode_select9;

    csr_s9.d_btwn_slave_sel9     = d_btwn_slave_sel9;
    csr_s9.d_btwn_word9          = d_btwn_word9;
    csr_s9.d_btwn_senable_word9  = d_btwn_senable_word9;

    csr_s9.spi_enable9      = spi_enable9;

    csr_s9.data_size9      = data_size9;
  endfunction

endclass : spi_csr9

`endif

