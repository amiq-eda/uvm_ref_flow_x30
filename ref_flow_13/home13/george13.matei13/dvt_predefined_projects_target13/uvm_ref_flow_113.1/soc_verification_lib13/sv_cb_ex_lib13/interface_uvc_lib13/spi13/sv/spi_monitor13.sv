/*-------------------------------------------------------------------------
File13 name   : spi_monitor13.sv
Title13       : SPI13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV13
`define SPI_MONITOR_SV13

class spi_monitor13 extends uvm_monitor;

  // This13 property is the virtual interfaced13 needed for this component to
  // view13 HDL signals13. 
  virtual interface spi_if13 spi_if13;

  spi_csr_s13 csr_s13;

  // Agent13 Id13
  protected int agent_id13;

  // The following13 bit is used to control13 whether13 coverage13 is
  // done both in the monitor13 class and the interface.
  bit coverage_enable13 = 1;

  uvm_analysis_port #(spi_transfer13) item_collected_port13;

  // The following13 property holds13 the transaction information currently
  // begin captured13 (by the collect_receive_data13 and collect_transmit_data13 methods13).
  protected spi_transfer13 trans_collected13;

  // Events13 needed to trigger covergroups13
  protected event cov_transaction13;

  event new_transfer_started13;
  event new_bit_started13;

  // Transfer13 collected13 covergroup
  covergroup cov_trans_cg13 @cov_transaction13;
    option.per_instance = 1;
    trans_mode13 : coverpoint csr_s13.mode_select13;
    trans_cpha13 : coverpoint csr_s13.tx_clk_phase13;
    trans_size13 : coverpoint csr_s13.transfer_data_size13 {
      bins sizes13[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes13 = default; }
    trans_txdata13 : coverpoint trans_collected13.transfer_data13 {
      option.auto_bin_max = 8; }
    trans_rxdata13 : coverpoint trans_collected13.receive_data13 {
      option.auto_bin_max = 8; }
    trans_modeXsize13 : cross trans_mode13, trans_size13;
  endgroup : cov_trans_cg13

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor13)
    `uvm_field_int(agent_id13, UVM_ALL_ON)
    `uvm_field_int(coverage_enable13, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg13 = new();
    cov_trans_cg13.set_inst_name("spi_cov_trans_cg13");
    item_collected_port13 = new("item_collected_port13", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if13)::get(this, "", "spi_if13", spi_if13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".spi_if13"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions13();
    join
  endtask : run_phase

  // collect_transactions13
  virtual protected task collect_transactions13();
    forever begin
      @(negedge spi_if13.sig_n_ss_in13);
      trans_collected13 = new();
      -> new_transfer_started13;
      if (m_parent != null)
        trans_collected13.agent13 = m_parent.get_name();
      collect_transfer13();
      if (coverage_enable13)
         -> cov_transaction13;
      item_collected_port13.write(trans_collected13);
    end
  endtask : collect_transactions13

  // collect_transfer13
  virtual protected task collect_transfer13();
    void'(this.begin_tr(trans_collected13));
    if (csr_s13.tx_clk_phase13 == 0) begin
      `uvm_info("SPI_MON13", $psprintf("tx_clk_phase13 is %d", csr_s13.tx_clk_phase13), UVM_HIGH)
      for (int i = 0; i < csr_s13.data_size13; i++) begin
        @(negedge spi_if13.sig_sclk_in13);
        -> new_bit_started13;
        if (csr_s13.mode_select13 == 1) begin     //DUT MASTER13 mode, OVC13 Slave13 mode
          trans_collected13.receive_data13[i] = spi_if13.sig_si13;
          `uvm_info("SPI_MON13", $psprintf("received13 data in mode_select13 1 is %h", trans_collected13.receive_data13), UVM_HIGH)
        end else begin
          trans_collected13.receive_data13[i] = spi_if13.sig_mi13;
          `uvm_info("SPI_MON13", $psprintf("received13 data in mode_select13 0 is %h", trans_collected13.receive_data13), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON13", $psprintf("tx_clk_phase13 is %d", csr_s13.tx_clk_phase13), UVM_HIGH)
      for (int i = 0; i < csr_s13.data_size13; i++) begin
        @(posedge spi_if13.sig_sclk_in13);
        -> new_bit_started13;
        if (csr_s13.mode_select13 == 1) begin     //DUT MASTER13 mode, OVC13 Slave13 mode
          trans_collected13.receive_data13[i] = spi_if13.sig_si13;
          `uvm_info("SPI_MON13", $psprintf("received13 data in mode_select13 1 is %h", trans_collected13.receive_data13), UVM_HIGH)
        end else begin
          trans_collected13.receive_data13[i] = spi_if13.sig_mi13;
          `uvm_info("SPI_MON13", $psprintf("received13 data in mode_select13 0 is %h", trans_collected13.receive_data13), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON13", $psprintf("Transfer13 collected13 :\n%s", trans_collected13.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected13);
  endtask : collect_transfer13

endclass : spi_monitor13

`endif // SPI_MONITOR_SV13

