/*-------------------------------------------------------------------------
File18 name   : spi_monitor18.sv
Title18       : SPI18 SystemVerilog18 UVM UVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV18
`define SPI_MONITOR_SV18

class spi_monitor18 extends uvm_monitor;

  // This18 property is the virtual interfaced18 needed for this component to
  // view18 HDL signals18. 
  virtual interface spi_if18 spi_if18;

  spi_csr_s18 csr_s18;

  // Agent18 Id18
  protected int agent_id18;

  // The following18 bit is used to control18 whether18 coverage18 is
  // done both in the monitor18 class and the interface.
  bit coverage_enable18 = 1;

  uvm_analysis_port #(spi_transfer18) item_collected_port18;

  // The following18 property holds18 the transaction information currently
  // begin captured18 (by the collect_receive_data18 and collect_transmit_data18 methods18).
  protected spi_transfer18 trans_collected18;

  // Events18 needed to trigger covergroups18
  protected event cov_transaction18;

  event new_transfer_started18;
  event new_bit_started18;

  // Transfer18 collected18 covergroup
  covergroup cov_trans_cg18 @cov_transaction18;
    option.per_instance = 1;
    trans_mode18 : coverpoint csr_s18.mode_select18;
    trans_cpha18 : coverpoint csr_s18.tx_clk_phase18;
    trans_size18 : coverpoint csr_s18.transfer_data_size18 {
      bins sizes18[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes18 = default; }
    trans_txdata18 : coverpoint trans_collected18.transfer_data18 {
      option.auto_bin_max = 8; }
    trans_rxdata18 : coverpoint trans_collected18.receive_data18 {
      option.auto_bin_max = 8; }
    trans_modeXsize18 : cross trans_mode18, trans_size18;
  endgroup : cov_trans_cg18

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor18)
    `uvm_field_int(agent_id18, UVM_ALL_ON)
    `uvm_field_int(coverage_enable18, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg18 = new();
    cov_trans_cg18.set_inst_name("spi_cov_trans_cg18");
    item_collected_port18 = new("item_collected_port18", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if18)::get(this, "", "spi_if18", spi_if18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".spi_if18"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions18();
    join
  endtask : run_phase

  // collect_transactions18
  virtual protected task collect_transactions18();
    forever begin
      @(negedge spi_if18.sig_n_ss_in18);
      trans_collected18 = new();
      -> new_transfer_started18;
      if (m_parent != null)
        trans_collected18.agent18 = m_parent.get_name();
      collect_transfer18();
      if (coverage_enable18)
         -> cov_transaction18;
      item_collected_port18.write(trans_collected18);
    end
  endtask : collect_transactions18

  // collect_transfer18
  virtual protected task collect_transfer18();
    void'(this.begin_tr(trans_collected18));
    if (csr_s18.tx_clk_phase18 == 0) begin
      `uvm_info("SPI_MON18", $psprintf("tx_clk_phase18 is %d", csr_s18.tx_clk_phase18), UVM_HIGH)
      for (int i = 0; i < csr_s18.data_size18; i++) begin
        @(negedge spi_if18.sig_sclk_in18);
        -> new_bit_started18;
        if (csr_s18.mode_select18 == 1) begin     //DUT MASTER18 mode, OVC18 Slave18 mode
          trans_collected18.receive_data18[i] = spi_if18.sig_si18;
          `uvm_info("SPI_MON18", $psprintf("received18 data in mode_select18 1 is %h", trans_collected18.receive_data18), UVM_HIGH)
        end else begin
          trans_collected18.receive_data18[i] = spi_if18.sig_mi18;
          `uvm_info("SPI_MON18", $psprintf("received18 data in mode_select18 0 is %h", trans_collected18.receive_data18), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON18", $psprintf("tx_clk_phase18 is %d", csr_s18.tx_clk_phase18), UVM_HIGH)
      for (int i = 0; i < csr_s18.data_size18; i++) begin
        @(posedge spi_if18.sig_sclk_in18);
        -> new_bit_started18;
        if (csr_s18.mode_select18 == 1) begin     //DUT MASTER18 mode, OVC18 Slave18 mode
          trans_collected18.receive_data18[i] = spi_if18.sig_si18;
          `uvm_info("SPI_MON18", $psprintf("received18 data in mode_select18 1 is %h", trans_collected18.receive_data18), UVM_HIGH)
        end else begin
          trans_collected18.receive_data18[i] = spi_if18.sig_mi18;
          `uvm_info("SPI_MON18", $psprintf("received18 data in mode_select18 0 is %h", trans_collected18.receive_data18), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON18", $psprintf("Transfer18 collected18 :\n%s", trans_collected18.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected18);
  endtask : collect_transfer18

endclass : spi_monitor18

`endif // SPI_MONITOR_SV18

