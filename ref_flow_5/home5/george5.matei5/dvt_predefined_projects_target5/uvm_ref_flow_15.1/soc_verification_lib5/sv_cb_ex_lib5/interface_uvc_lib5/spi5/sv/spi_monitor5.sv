/*-------------------------------------------------------------------------
File5 name   : spi_monitor5.sv
Title5       : SPI5 SystemVerilog5 UVM UVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV5
`define SPI_MONITOR_SV5

class spi_monitor5 extends uvm_monitor;

  // This5 property is the virtual interfaced5 needed for this component to
  // view5 HDL signals5. 
  virtual interface spi_if5 spi_if5;

  spi_csr_s5 csr_s5;

  // Agent5 Id5
  protected int agent_id5;

  // The following5 bit is used to control5 whether5 coverage5 is
  // done both in the monitor5 class and the interface.
  bit coverage_enable5 = 1;

  uvm_analysis_port #(spi_transfer5) item_collected_port5;

  // The following5 property holds5 the transaction information currently
  // begin captured5 (by the collect_receive_data5 and collect_transmit_data5 methods5).
  protected spi_transfer5 trans_collected5;

  // Events5 needed to trigger covergroups5
  protected event cov_transaction5;

  event new_transfer_started5;
  event new_bit_started5;

  // Transfer5 collected5 covergroup
  covergroup cov_trans_cg5 @cov_transaction5;
    option.per_instance = 1;
    trans_mode5 : coverpoint csr_s5.mode_select5;
    trans_cpha5 : coverpoint csr_s5.tx_clk_phase5;
    trans_size5 : coverpoint csr_s5.transfer_data_size5 {
      bins sizes5[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes5 = default; }
    trans_txdata5 : coverpoint trans_collected5.transfer_data5 {
      option.auto_bin_max = 8; }
    trans_rxdata5 : coverpoint trans_collected5.receive_data5 {
      option.auto_bin_max = 8; }
    trans_modeXsize5 : cross trans_mode5, trans_size5;
  endgroup : cov_trans_cg5

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor5)
    `uvm_field_int(agent_id5, UVM_ALL_ON)
    `uvm_field_int(coverage_enable5, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg5 = new();
    cov_trans_cg5.set_inst_name("spi_cov_trans_cg5");
    item_collected_port5 = new("item_collected_port5", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if5)::get(this, "", "spi_if5", spi_if5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".spi_if5"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions5();
    join
  endtask : run_phase

  // collect_transactions5
  virtual protected task collect_transactions5();
    forever begin
      @(negedge spi_if5.sig_n_ss_in5);
      trans_collected5 = new();
      -> new_transfer_started5;
      if (m_parent != null)
        trans_collected5.agent5 = m_parent.get_name();
      collect_transfer5();
      if (coverage_enable5)
         -> cov_transaction5;
      item_collected_port5.write(trans_collected5);
    end
  endtask : collect_transactions5

  // collect_transfer5
  virtual protected task collect_transfer5();
    void'(this.begin_tr(trans_collected5));
    if (csr_s5.tx_clk_phase5 == 0) begin
      `uvm_info("SPI_MON5", $psprintf("tx_clk_phase5 is %d", csr_s5.tx_clk_phase5), UVM_HIGH)
      for (int i = 0; i < csr_s5.data_size5; i++) begin
        @(negedge spi_if5.sig_sclk_in5);
        -> new_bit_started5;
        if (csr_s5.mode_select5 == 1) begin     //DUT MASTER5 mode, OVC5 Slave5 mode
          trans_collected5.receive_data5[i] = spi_if5.sig_si5;
          `uvm_info("SPI_MON5", $psprintf("received5 data in mode_select5 1 is %h", trans_collected5.receive_data5), UVM_HIGH)
        end else begin
          trans_collected5.receive_data5[i] = spi_if5.sig_mi5;
          `uvm_info("SPI_MON5", $psprintf("received5 data in mode_select5 0 is %h", trans_collected5.receive_data5), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON5", $psprintf("tx_clk_phase5 is %d", csr_s5.tx_clk_phase5), UVM_HIGH)
      for (int i = 0; i < csr_s5.data_size5; i++) begin
        @(posedge spi_if5.sig_sclk_in5);
        -> new_bit_started5;
        if (csr_s5.mode_select5 == 1) begin     //DUT MASTER5 mode, OVC5 Slave5 mode
          trans_collected5.receive_data5[i] = spi_if5.sig_si5;
          `uvm_info("SPI_MON5", $psprintf("received5 data in mode_select5 1 is %h", trans_collected5.receive_data5), UVM_HIGH)
        end else begin
          trans_collected5.receive_data5[i] = spi_if5.sig_mi5;
          `uvm_info("SPI_MON5", $psprintf("received5 data in mode_select5 0 is %h", trans_collected5.receive_data5), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON5", $psprintf("Transfer5 collected5 :\n%s", trans_collected5.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected5);
  endtask : collect_transfer5

endclass : spi_monitor5

`endif // SPI_MONITOR_SV5

