/*-------------------------------------------------------------------------
File6 name   : spi_csr6.sv
Title6       : SPI6 SystemVerilog6 UVM UVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV6
`define SPI_CSR_SV6

typedef struct packed {
  bit [7:0] n_ss_out6;
  bit [6:0] transfer_data_size6;
  bit [15:0] baud_rate_divisor6;
  bit tx_clk_phase6;
  bit rx_clk_phase6;
  bit mode_select6;

  bit tx_fifo_underflow6;
  bit rx_fifo_full6; 
  bit rx_fifo_not_empty6;
  bit tx_fifo_full6;
  bit tx_fifo_not_empty6;
  bit mode_fault6;
  bit rx_fifo_overrun6;

  bit spi_enable6;

  bit [7:0] d_btwn_slave_sel6;
  bit [7:0] d_btwn_word6;
  bit [7:0] d_btwn_senable_word6;

  int data_size6;
  } spi_csr_s6;

class spi_csr6 extends uvm_object;

  spi_csr_s6 csr_s6;

  //randomize SPI6 CSR6 fields
  rand bit [7:0] n_ss_out6;
  rand bit [6:0] transfer_data_size6;
  rand bit [15:0] baud_rate_divisor6;
  rand bit tx_clk_phase6;
  rand bit rx_clk_phase6;
  rand bit mode_select6;

  rand bit [7:0] d_btwn_slave_sel6;
  rand bit [7:0] d_btwn_word6;
  rand bit [7:0] d_btwn_senable_word6;

  rand bit spi_enable6;

  int data_size6;

  // this is a default constraint that could be overriden6
  // Constrain6 randomisation6 of configuration based on UVC6/RTL6 capabilities6
  constraint c_default_config6 {
    n_ss_out6           == 8'b01;
    transfer_data_size6 == 7'b0001000;
    baud_rate_divisor6  == 16'b0001;
    tx_clk_phase6       == 1'b0;
    rx_clk_phase6       == 1'b0;
    mode_select6        == 1'b1;

    d_btwn_slave_sel6   == 8'h00;
    d_btwn_word6        == 8'h00;
    d_btwn_senable_word6== 8'h00;

    spi_enable6         == 1'b1;
  }

  // These6 declarations6 implement the create() and get_type_name() as well6 as enable automation6 of the
  // transfer6 fields   
  `uvm_object_utils_begin(spi_csr6)
    `uvm_field_int(n_ss_out6,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size6,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor6,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase6,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase6,        UVM_ALL_ON)
    `uvm_field_int(mode_select6,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel6,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word6,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word6, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable6,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This6 requires for registration6 of the ptp_tx_frame6   
  function new(string name = "spi_csr6");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int6();
    Copycfg_struct6();
  endfunction 

  // function to convert the 2 bit transfer_data_size6 to integer
  function void get_data_size_as_int6();
    case(transfer_data_size6)
      16'b00 : data_size6 = 128;
      default : data_size6 = int'(transfer_data_size6);
    endcase
     `uvm_info("SPI6 CSR6", $psprintf("data size is %d", data_size6), UVM_MEDIUM)
  endfunction : get_data_size_as_int6
    
  function void Copycfg_struct6();
    csr_s6.n_ss_out6            = n_ss_out6;
    csr_s6.transfer_data_size6  = transfer_data_size6;
    csr_s6.baud_rate_divisor6   = baud_rate_divisor6;
    csr_s6.tx_clk_phase6        = tx_clk_phase6;
    csr_s6.rx_clk_phase6        = rx_clk_phase6;
    csr_s6.mode_select6         = mode_select6;

    csr_s6.d_btwn_slave_sel6     = d_btwn_slave_sel6;
    csr_s6.d_btwn_word6          = d_btwn_word6;
    csr_s6.d_btwn_senable_word6  = d_btwn_senable_word6;

    csr_s6.spi_enable6      = spi_enable6;

    csr_s6.data_size6      = data_size6;
  endfunction

endclass : spi_csr6

`endif

