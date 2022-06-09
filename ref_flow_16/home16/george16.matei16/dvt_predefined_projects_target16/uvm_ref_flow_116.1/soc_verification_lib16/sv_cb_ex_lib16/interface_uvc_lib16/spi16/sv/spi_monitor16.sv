/*-------------------------------------------------------------------------
File16 name   : spi_monitor16.sv
Title16       : SPI16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV16
`define SPI_MONITOR_SV16

class spi_monitor16 extends uvm_monitor;

  // This16 property is the virtual interfaced16 needed for this component to
  // view16 HDL signals16. 
  virtual interface spi_if16 spi_if16;

  spi_csr_s16 csr_s16;

  // Agent16 Id16
  protected int agent_id16;

  // The following16 bit is used to control16 whether16 coverage16 is
  // done both in the monitor16 class and the interface.
  bit coverage_enable16 = 1;

  uvm_analysis_port #(spi_transfer16) item_collected_port16;

  // The following16 property holds16 the transaction information currently
  // begin captured16 (by the collect_receive_data16 and collect_transmit_data16 methods16).
  protected spi_transfer16 trans_collected16;

  // Events16 needed to trigger covergroups16
  protected event cov_transaction16;

  event new_transfer_started16;
  event new_bit_started16;

  // Transfer16 collected16 covergroup
  covergroup cov_trans_cg16 @cov_transaction16;
    option.per_instance = 1;
    trans_mode16 : coverpoint csr_s16.mode_select16;
    trans_cpha16 : coverpoint csr_s16.tx_clk_phase16;
    trans_size16 : coverpoint csr_s16.transfer_data_size16 {
      bins sizes16[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes16 = default; }
    trans_txdata16 : coverpoint trans_collected16.transfer_data16 {
      option.auto_bin_max = 8; }
    trans_rxdata16 : coverpoint trans_collected16.receive_data16 {
      option.auto_bin_max = 8; }
    trans_modeXsize16 : cross trans_mode16, trans_size16;
  endgroup : cov_trans_cg16

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor16)
    `uvm_field_int(agent_id16, UVM_ALL_ON)
    `uvm_field_int(coverage_enable16, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg16 = new();
    cov_trans_cg16.set_inst_name("spi_cov_trans_cg16");
    item_collected_port16 = new("item_collected_port16", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if16)::get(this, "", "spi_if16", spi_if16))
   `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".spi_if16"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions16();
    join
  endtask : run_phase

  // collect_transactions16
  virtual protected task collect_transactions16();
    forever begin
      @(negedge spi_if16.sig_n_ss_in16);
      trans_collected16 = new();
      -> new_transfer_started16;
      if (m_parent != null)
        trans_collected16.agent16 = m_parent.get_name();
      collect_transfer16();
      if (coverage_enable16)
         -> cov_transaction16;
      item_collected_port16.write(trans_collected16);
    end
  endtask : collect_transactions16

  // collect_transfer16
  virtual protected task collect_transfer16();
    void'(this.begin_tr(trans_collected16));
    if (csr_s16.tx_clk_phase16 == 0) begin
      `uvm_info("SPI_MON16", $psprintf("tx_clk_phase16 is %d", csr_s16.tx_clk_phase16), UVM_HIGH)
      for (int i = 0; i < csr_s16.data_size16; i++) begin
        @(negedge spi_if16.sig_sclk_in16);
        -> new_bit_started16;
        if (csr_s16.mode_select16 == 1) begin     //DUT MASTER16 mode, OVC16 Slave16 mode
          trans_collected16.receive_data16[i] = spi_if16.sig_si16;
          `uvm_info("SPI_MON16", $psprintf("received16 data in mode_select16 1 is %h", trans_collected16.receive_data16), UVM_HIGH)
        end else begin
          trans_collected16.receive_data16[i] = spi_if16.sig_mi16;
          `uvm_info("SPI_MON16", $psprintf("received16 data in mode_select16 0 is %h", trans_collected16.receive_data16), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON16", $psprintf("tx_clk_phase16 is %d", csr_s16.tx_clk_phase16), UVM_HIGH)
      for (int i = 0; i < csr_s16.data_size16; i++) begin
        @(posedge spi_if16.sig_sclk_in16);
        -> new_bit_started16;
        if (csr_s16.mode_select16 == 1) begin     //DUT MASTER16 mode, OVC16 Slave16 mode
          trans_collected16.receive_data16[i] = spi_if16.sig_si16;
          `uvm_info("SPI_MON16", $psprintf("received16 data in mode_select16 1 is %h", trans_collected16.receive_data16), UVM_HIGH)
        end else begin
          trans_collected16.receive_data16[i] = spi_if16.sig_mi16;
          `uvm_info("SPI_MON16", $psprintf("received16 data in mode_select16 0 is %h", trans_collected16.receive_data16), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON16", $psprintf("Transfer16 collected16 :\n%s", trans_collected16.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected16);
  endtask : collect_transfer16

endclass : spi_monitor16

`endif // SPI_MONITOR_SV16

