/*-------------------------------------------------------------------------
File19 name   : spi_csr19.sv
Title19       : SPI19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef SPI_CSR_SV19
`define SPI_CSR_SV19

typedef struct packed {
  bit [7:0] n_ss_out19;
  bit [6:0] transfer_data_size19;
  bit [15:0] baud_rate_divisor19;
  bit tx_clk_phase19;
  bit rx_clk_phase19;
  bit mode_select19;

  bit tx_fifo_underflow19;
  bit rx_fifo_full19; 
  bit rx_fifo_not_empty19;
  bit tx_fifo_full19;
  bit tx_fifo_not_empty19;
  bit mode_fault19;
  bit rx_fifo_overrun19;

  bit spi_enable19;

  bit [7:0] d_btwn_slave_sel19;
  bit [7:0] d_btwn_word19;
  bit [7:0] d_btwn_senable_word19;

  int data_size19;
  } spi_csr_s19;

class spi_csr19 extends uvm_object;

  spi_csr_s19 csr_s19;

  //randomize SPI19 CSR19 fields
  rand bit [7:0] n_ss_out19;
  rand bit [6:0] transfer_data_size19;
  rand bit [15:0] baud_rate_divisor19;
  rand bit tx_clk_phase19;
  rand bit rx_clk_phase19;
  rand bit mode_select19;

  rand bit [7:0] d_btwn_slave_sel19;
  rand bit [7:0] d_btwn_word19;
  rand bit [7:0] d_btwn_senable_word19;

  rand bit spi_enable19;

  int data_size19;

  // this is a default constraint that could be overriden19
  // Constrain19 randomisation19 of configuration based on UVC19/RTL19 capabilities19
  constraint c_default_config19 {
    n_ss_out19           == 8'b01;
    transfer_data_size19 == 7'b0001000;
    baud_rate_divisor19  == 16'b0001;
    tx_clk_phase19       == 1'b0;
    rx_clk_phase19       == 1'b0;
    mode_select19        == 1'b1;

    d_btwn_slave_sel19   == 8'h00;
    d_btwn_word19        == 8'h00;
    d_btwn_senable_word19== 8'h00;

    spi_enable19         == 1'b1;
  }

  // These19 declarations19 implement the create() and get_type_name() as well19 as enable automation19 of the
  // transfer19 fields   
  `uvm_object_utils_begin(spi_csr19)
    `uvm_field_int(n_ss_out19,            UVM_ALL_ON)
    `uvm_field_int(transfer_data_size19,  UVM_ALL_ON)
    `uvm_field_int(baud_rate_divisor19,   UVM_ALL_ON)  
    `uvm_field_int(tx_clk_phase19,        UVM_ALL_ON)
    `uvm_field_int(rx_clk_phase19,        UVM_ALL_ON)
    `uvm_field_int(mode_select19,         UVM_ALL_ON)
    `uvm_field_int(d_btwn_slave_sel19,    UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_word19,         UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(d_btwn_senable_word19, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(spi_enable19,          UVM_ALL_ON)
  `uvm_object_utils_end

  // This19 requires for registration19 of the ptp_tx_frame19   
  function new(string name = "spi_csr19");
	  super.new(name);
  endfunction 
   
  function void post_randomize();
    get_data_size_as_int19();
    Copycfg_struct19();
  endfunction 

  // function to convert the 2 bit transfer_data_size19 to integer
  function void get_data_size_as_int19();
    case(transfer_data_size19)
      16'b00 : data_size19 = 128;
      default : data_size19 = int'(transfer_data_size19);
    endcase
     `uvm_info("SPI19 CSR19", $psprintf("data size is %d", data_size19), UVM_MEDIUM)
  endfunction : get_data_size_as_int19
    
  function void Copycfg_struct19();
    csr_s19.n_ss_out19            = n_ss_out19;
    csr_s19.transfer_data_size19  = transfer_data_size19;
    csr_s19.baud_rate_divisor19   = baud_rate_divisor19;
    csr_s19.tx_clk_phase19        = tx_clk_phase19;
    csr_s19.rx_clk_phase19        = rx_clk_phase19;
    csr_s19.mode_select19         = mode_select19;

    csr_s19.d_btwn_slave_sel19     = d_btwn_slave_sel19;
    csr_s19.d_btwn_word19          = d_btwn_word19;
    csr_s19.d_btwn_senable_word19  = d_btwn_senable_word19;

    csr_s19.spi_enable19      = spi_enable19;

    csr_s19.data_size19      = data_size19;
  endfunction

endclass : spi_csr19

`endif

