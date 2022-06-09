/*-------------------------------------------------------------------------
File6 name   : spi_monitor6.sv
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


`ifndef SPI_MONITOR_SV6
`define SPI_MONITOR_SV6

class spi_monitor6 extends uvm_monitor;

  // This6 property is the virtual interfaced6 needed for this component to
  // view6 HDL signals6. 
  virtual interface spi_if6 spi_if6;

  spi_csr_s6 csr_s6;

  // Agent6 Id6
  protected int agent_id6;

  // The following6 bit is used to control6 whether6 coverage6 is
  // done both in the monitor6 class and the interface.
  bit coverage_enable6 = 1;

  uvm_analysis_port #(spi_transfer6) item_collected_port6;

  // The following6 property holds6 the transaction information currently
  // begin captured6 (by the collect_receive_data6 and collect_transmit_data6 methods6).
  protected spi_transfer6 trans_collected6;

  // Events6 needed to trigger covergroups6
  protected event cov_transaction6;

  event new_transfer_started6;
  event new_bit_started6;

  // Transfer6 collected6 covergroup
  covergroup cov_trans_cg6 @cov_transaction6;
    option.per_instance = 1;
    trans_mode6 : coverpoint csr_s6.mode_select6;
    trans_cpha6 : coverpoint csr_s6.tx_clk_phase6;
    trans_size6 : coverpoint csr_s6.transfer_data_size6 {
      bins sizes6[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes6 = default; }
    trans_txdata6 : coverpoint trans_collected6.transfer_data6 {
      option.auto_bin_max = 8; }
    trans_rxdata6 : coverpoint trans_collected6.receive_data6 {
      option.auto_bin_max = 8; }
    trans_modeXsize6 : cross trans_mode6, trans_size6;
  endgroup : cov_trans_cg6

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor6)
    `uvm_field_int(agent_id6, UVM_ALL_ON)
    `uvm_field_int(coverage_enable6, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg6 = new();
    cov_trans_cg6.set_inst_name("spi_cov_trans_cg6");
    item_collected_port6 = new("item_collected_port6", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if6)::get(this, "", "spi_if6", spi_if6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".spi_if6"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions6();
    join
  endtask : run_phase

  // collect_transactions6
  virtual protected task collect_transactions6();
    forever begin
      @(negedge spi_if6.sig_n_ss_in6);
      trans_collected6 = new();
      -> new_transfer_started6;
      if (m_parent != null)
        trans_collected6.agent6 = m_parent.get_name();
      collect_transfer6();
      if (coverage_enable6)
         -> cov_transaction6;
      item_collected_port6.write(trans_collected6);
    end
  endtask : collect_transactions6

  // collect_transfer6
  virtual protected task collect_transfer6();
    void'(this.begin_tr(trans_collected6));
    if (csr_s6.tx_clk_phase6 == 0) begin
      `uvm_info("SPI_MON6", $psprintf("tx_clk_phase6 is %d", csr_s6.tx_clk_phase6), UVM_HIGH)
      for (int i = 0; i < csr_s6.data_size6; i++) begin
        @(negedge spi_if6.sig_sclk_in6);
        -> new_bit_started6;
        if (csr_s6.mode_select6 == 1) begin     //DUT MASTER6 mode, OVC6 Slave6 mode
          trans_collected6.receive_data6[i] = spi_if6.sig_si6;
          `uvm_info("SPI_MON6", $psprintf("received6 data in mode_select6 1 is %h", trans_collected6.receive_data6), UVM_HIGH)
        end else begin
          trans_collected6.receive_data6[i] = spi_if6.sig_mi6;
          `uvm_info("SPI_MON6", $psprintf("received6 data in mode_select6 0 is %h", trans_collected6.receive_data6), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON6", $psprintf("tx_clk_phase6 is %d", csr_s6.tx_clk_phase6), UVM_HIGH)
      for (int i = 0; i < csr_s6.data_size6; i++) begin
        @(posedge spi_if6.sig_sclk_in6);
        -> new_bit_started6;
        if (csr_s6.mode_select6 == 1) begin     //DUT MASTER6 mode, OVC6 Slave6 mode
          trans_collected6.receive_data6[i] = spi_if6.sig_si6;
          `uvm_info("SPI_MON6", $psprintf("received6 data in mode_select6 1 is %h", trans_collected6.receive_data6), UVM_HIGH)
        end else begin
          trans_collected6.receive_data6[i] = spi_if6.sig_mi6;
          `uvm_info("SPI_MON6", $psprintf("received6 data in mode_select6 0 is %h", trans_collected6.receive_data6), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON6", $psprintf("Transfer6 collected6 :\n%s", trans_collected6.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected6);
  endtask : collect_transfer6

endclass : spi_monitor6

`endif // SPI_MONITOR_SV6

