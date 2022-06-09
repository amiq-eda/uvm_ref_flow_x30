/*-------------------------------------------------------------------------
File20 name   : spi_monitor20.sv
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


`ifndef SPI_MONITOR_SV20
`define SPI_MONITOR_SV20

class spi_monitor20 extends uvm_monitor;

  // This20 property is the virtual interfaced20 needed for this component to
  // view20 HDL signals20. 
  virtual interface spi_if20 spi_if20;

  spi_csr_s20 csr_s20;

  // Agent20 Id20
  protected int agent_id20;

  // The following20 bit is used to control20 whether20 coverage20 is
  // done both in the monitor20 class and the interface.
  bit coverage_enable20 = 1;

  uvm_analysis_port #(spi_transfer20) item_collected_port20;

  // The following20 property holds20 the transaction information currently
  // begin captured20 (by the collect_receive_data20 and collect_transmit_data20 methods20).
  protected spi_transfer20 trans_collected20;

  // Events20 needed to trigger covergroups20
  protected event cov_transaction20;

  event new_transfer_started20;
  event new_bit_started20;

  // Transfer20 collected20 covergroup
  covergroup cov_trans_cg20 @cov_transaction20;
    option.per_instance = 1;
    trans_mode20 : coverpoint csr_s20.mode_select20;
    trans_cpha20 : coverpoint csr_s20.tx_clk_phase20;
    trans_size20 : coverpoint csr_s20.transfer_data_size20 {
      bins sizes20[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes20 = default; }
    trans_txdata20 : coverpoint trans_collected20.transfer_data20 {
      option.auto_bin_max = 8; }
    trans_rxdata20 : coverpoint trans_collected20.receive_data20 {
      option.auto_bin_max = 8; }
    trans_modeXsize20 : cross trans_mode20, trans_size20;
  endgroup : cov_trans_cg20

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor20)
    `uvm_field_int(agent_id20, UVM_ALL_ON)
    `uvm_field_int(coverage_enable20, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg20 = new();
    cov_trans_cg20.set_inst_name("spi_cov_trans_cg20");
    item_collected_port20 = new("item_collected_port20", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if20)::get(this, "", "spi_if20", spi_if20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".spi_if20"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions20();
    join
  endtask : run_phase

  // collect_transactions20
  virtual protected task collect_transactions20();
    forever begin
      @(negedge spi_if20.sig_n_ss_in20);
      trans_collected20 = new();
      -> new_transfer_started20;
      if (m_parent != null)
        trans_collected20.agent20 = m_parent.get_name();
      collect_transfer20();
      if (coverage_enable20)
         -> cov_transaction20;
      item_collected_port20.write(trans_collected20);
    end
  endtask : collect_transactions20

  // collect_transfer20
  virtual protected task collect_transfer20();
    void'(this.begin_tr(trans_collected20));
    if (csr_s20.tx_clk_phase20 == 0) begin
      `uvm_info("SPI_MON20", $psprintf("tx_clk_phase20 is %d", csr_s20.tx_clk_phase20), UVM_HIGH)
      for (int i = 0; i < csr_s20.data_size20; i++) begin
        @(negedge spi_if20.sig_sclk_in20);
        -> new_bit_started20;
        if (csr_s20.mode_select20 == 1) begin     //DUT MASTER20 mode, OVC20 Slave20 mode
          trans_collected20.receive_data20[i] = spi_if20.sig_si20;
          `uvm_info("SPI_MON20", $psprintf("received20 data in mode_select20 1 is %h", trans_collected20.receive_data20), UVM_HIGH)
        end else begin
          trans_collected20.receive_data20[i] = spi_if20.sig_mi20;
          `uvm_info("SPI_MON20", $psprintf("received20 data in mode_select20 0 is %h", trans_collected20.receive_data20), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON20", $psprintf("tx_clk_phase20 is %d", csr_s20.tx_clk_phase20), UVM_HIGH)
      for (int i = 0; i < csr_s20.data_size20; i++) begin
        @(posedge spi_if20.sig_sclk_in20);
        -> new_bit_started20;
        if (csr_s20.mode_select20 == 1) begin     //DUT MASTER20 mode, OVC20 Slave20 mode
          trans_collected20.receive_data20[i] = spi_if20.sig_si20;
          `uvm_info("SPI_MON20", $psprintf("received20 data in mode_select20 1 is %h", trans_collected20.receive_data20), UVM_HIGH)
        end else begin
          trans_collected20.receive_data20[i] = spi_if20.sig_mi20;
          `uvm_info("SPI_MON20", $psprintf("received20 data in mode_select20 0 is %h", trans_collected20.receive_data20), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON20", $psprintf("Transfer20 collected20 :\n%s", trans_collected20.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected20);
  endtask : collect_transfer20

endclass : spi_monitor20

`endif // SPI_MONITOR_SV20

