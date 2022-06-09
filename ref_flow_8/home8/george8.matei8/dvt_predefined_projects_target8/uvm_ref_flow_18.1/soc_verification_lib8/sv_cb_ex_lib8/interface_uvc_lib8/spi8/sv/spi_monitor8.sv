/*-------------------------------------------------------------------------
File8 name   : spi_monitor8.sv
Title8       : SPI8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV8
`define SPI_MONITOR_SV8

class spi_monitor8 extends uvm_monitor;

  // This8 property is the virtual interfaced8 needed for this component to
  // view8 HDL signals8. 
  virtual interface spi_if8 spi_if8;

  spi_csr_s8 csr_s8;

  // Agent8 Id8
  protected int agent_id8;

  // The following8 bit is used to control8 whether8 coverage8 is
  // done both in the monitor8 class and the interface.
  bit coverage_enable8 = 1;

  uvm_analysis_port #(spi_transfer8) item_collected_port8;

  // The following8 property holds8 the transaction information currently
  // begin captured8 (by the collect_receive_data8 and collect_transmit_data8 methods8).
  protected spi_transfer8 trans_collected8;

  // Events8 needed to trigger covergroups8
  protected event cov_transaction8;

  event new_transfer_started8;
  event new_bit_started8;

  // Transfer8 collected8 covergroup
  covergroup cov_trans_cg8 @cov_transaction8;
    option.per_instance = 1;
    trans_mode8 : coverpoint csr_s8.mode_select8;
    trans_cpha8 : coverpoint csr_s8.tx_clk_phase8;
    trans_size8 : coverpoint csr_s8.transfer_data_size8 {
      bins sizes8[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes8 = default; }
    trans_txdata8 : coverpoint trans_collected8.transfer_data8 {
      option.auto_bin_max = 8; }
    trans_rxdata8 : coverpoint trans_collected8.receive_data8 {
      option.auto_bin_max = 8; }
    trans_modeXsize8 : cross trans_mode8, trans_size8;
  endgroup : cov_trans_cg8

  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor8)
    `uvm_field_int(agent_id8, UVM_ALL_ON)
    `uvm_field_int(coverage_enable8, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg8 = new();
    cov_trans_cg8.set_inst_name("spi_cov_trans_cg8");
    item_collected_port8 = new("item_collected_port8", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if8)::get(this, "", "spi_if8", spi_if8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".spi_if8"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions8();
    join
  endtask : run_phase

  // collect_transactions8
  virtual protected task collect_transactions8();
    forever begin
      @(negedge spi_if8.sig_n_ss_in8);
      trans_collected8 = new();
      -> new_transfer_started8;
      if (m_parent != null)
        trans_collected8.agent8 = m_parent.get_name();
      collect_transfer8();
      if (coverage_enable8)
         -> cov_transaction8;
      item_collected_port8.write(trans_collected8);
    end
  endtask : collect_transactions8

  // collect_transfer8
  virtual protected task collect_transfer8();
    void'(this.begin_tr(trans_collected8));
    if (csr_s8.tx_clk_phase8 == 0) begin
      `uvm_info("SPI_MON8", $psprintf("tx_clk_phase8 is %d", csr_s8.tx_clk_phase8), UVM_HIGH)
      for (int i = 0; i < csr_s8.data_size8; i++) begin
        @(negedge spi_if8.sig_sclk_in8);
        -> new_bit_started8;
        if (csr_s8.mode_select8 == 1) begin     //DUT MASTER8 mode, OVC8 Slave8 mode
          trans_collected8.receive_data8[i] = spi_if8.sig_si8;
          `uvm_info("SPI_MON8", $psprintf("received8 data in mode_select8 1 is %h", trans_collected8.receive_data8), UVM_HIGH)
        end else begin
          trans_collected8.receive_data8[i] = spi_if8.sig_mi8;
          `uvm_info("SPI_MON8", $psprintf("received8 data in mode_select8 0 is %h", trans_collected8.receive_data8), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON8", $psprintf("tx_clk_phase8 is %d", csr_s8.tx_clk_phase8), UVM_HIGH)
      for (int i = 0; i < csr_s8.data_size8; i++) begin
        @(posedge spi_if8.sig_sclk_in8);
        -> new_bit_started8;
        if (csr_s8.mode_select8 == 1) begin     //DUT MASTER8 mode, OVC8 Slave8 mode
          trans_collected8.receive_data8[i] = spi_if8.sig_si8;
          `uvm_info("SPI_MON8", $psprintf("received8 data in mode_select8 1 is %h", trans_collected8.receive_data8), UVM_HIGH)
        end else begin
          trans_collected8.receive_data8[i] = spi_if8.sig_mi8;
          `uvm_info("SPI_MON8", $psprintf("received8 data in mode_select8 0 is %h", trans_collected8.receive_data8), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON8", $psprintf("Transfer8 collected8 :\n%s", trans_collected8.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected8);
  endtask : collect_transfer8

endclass : spi_monitor8

`endif // SPI_MONITOR_SV8

