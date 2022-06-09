/*-------------------------------------------------------------------------
File7 name   : spi_monitor7.sv
Title7       : SPI7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV7
`define SPI_MONITOR_SV7

class spi_monitor7 extends uvm_monitor;

  // This7 property is the virtual interfaced7 needed for this component to
  // view7 HDL signals7. 
  virtual interface spi_if7 spi_if7;

  spi_csr_s7 csr_s7;

  // Agent7 Id7
  protected int agent_id7;

  // The following7 bit is used to control7 whether7 coverage7 is
  // done both in the monitor7 class and the interface.
  bit coverage_enable7 = 1;

  uvm_analysis_port #(spi_transfer7) item_collected_port7;

  // The following7 property holds7 the transaction information currently
  // begin captured7 (by the collect_receive_data7 and collect_transmit_data7 methods7).
  protected spi_transfer7 trans_collected7;

  // Events7 needed to trigger covergroups7
  protected event cov_transaction7;

  event new_transfer_started7;
  event new_bit_started7;

  // Transfer7 collected7 covergroup
  covergroup cov_trans_cg7 @cov_transaction7;
    option.per_instance = 1;
    trans_mode7 : coverpoint csr_s7.mode_select7;
    trans_cpha7 : coverpoint csr_s7.tx_clk_phase7;
    trans_size7 : coverpoint csr_s7.transfer_data_size7 {
      bins sizes7[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes7 = default; }
    trans_txdata7 : coverpoint trans_collected7.transfer_data7 {
      option.auto_bin_max = 8; }
    trans_rxdata7 : coverpoint trans_collected7.receive_data7 {
      option.auto_bin_max = 8; }
    trans_modeXsize7 : cross trans_mode7, trans_size7;
  endgroup : cov_trans_cg7

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor7)
    `uvm_field_int(agent_id7, UVM_ALL_ON)
    `uvm_field_int(coverage_enable7, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg7 = new();
    cov_trans_cg7.set_inst_name("spi_cov_trans_cg7");
    item_collected_port7 = new("item_collected_port7", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if7)::get(this, "", "spi_if7", spi_if7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".spi_if7"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions7();
    join
  endtask : run_phase

  // collect_transactions7
  virtual protected task collect_transactions7();
    forever begin
      @(negedge spi_if7.sig_n_ss_in7);
      trans_collected7 = new();
      -> new_transfer_started7;
      if (m_parent != null)
        trans_collected7.agent7 = m_parent.get_name();
      collect_transfer7();
      if (coverage_enable7)
         -> cov_transaction7;
      item_collected_port7.write(trans_collected7);
    end
  endtask : collect_transactions7

  // collect_transfer7
  virtual protected task collect_transfer7();
    void'(this.begin_tr(trans_collected7));
    if (csr_s7.tx_clk_phase7 == 0) begin
      `uvm_info("SPI_MON7", $psprintf("tx_clk_phase7 is %d", csr_s7.tx_clk_phase7), UVM_HIGH)
      for (int i = 0; i < csr_s7.data_size7; i++) begin
        @(negedge spi_if7.sig_sclk_in7);
        -> new_bit_started7;
        if (csr_s7.mode_select7 == 1) begin     //DUT MASTER7 mode, OVC7 Slave7 mode
          trans_collected7.receive_data7[i] = spi_if7.sig_si7;
          `uvm_info("SPI_MON7", $psprintf("received7 data in mode_select7 1 is %h", trans_collected7.receive_data7), UVM_HIGH)
        end else begin
          trans_collected7.receive_data7[i] = spi_if7.sig_mi7;
          `uvm_info("SPI_MON7", $psprintf("received7 data in mode_select7 0 is %h", trans_collected7.receive_data7), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON7", $psprintf("tx_clk_phase7 is %d", csr_s7.tx_clk_phase7), UVM_HIGH)
      for (int i = 0; i < csr_s7.data_size7; i++) begin
        @(posedge spi_if7.sig_sclk_in7);
        -> new_bit_started7;
        if (csr_s7.mode_select7 == 1) begin     //DUT MASTER7 mode, OVC7 Slave7 mode
          trans_collected7.receive_data7[i] = spi_if7.sig_si7;
          `uvm_info("SPI_MON7", $psprintf("received7 data in mode_select7 1 is %h", trans_collected7.receive_data7), UVM_HIGH)
        end else begin
          trans_collected7.receive_data7[i] = spi_if7.sig_mi7;
          `uvm_info("SPI_MON7", $psprintf("received7 data in mode_select7 0 is %h", trans_collected7.receive_data7), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON7", $psprintf("Transfer7 collected7 :\n%s", trans_collected7.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected7);
  endtask : collect_transfer7

endclass : spi_monitor7

`endif // SPI_MONITOR_SV7

