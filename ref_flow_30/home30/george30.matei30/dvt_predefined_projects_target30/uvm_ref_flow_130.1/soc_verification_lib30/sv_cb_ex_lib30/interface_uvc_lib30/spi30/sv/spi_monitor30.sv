/*-------------------------------------------------------------------------
File30 name   : spi_monitor30.sv
Title30       : SPI30 SystemVerilog30 UVM UVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV30
`define SPI_MONITOR_SV30

class spi_monitor30 extends uvm_monitor;

  // This30 property is the virtual interfaced30 needed for this component to
  // view30 HDL signals30. 
  virtual interface spi_if30 spi_if30;

  spi_csr_s30 csr_s30;

  // Agent30 Id30
  protected int agent_id30;

  // The following30 bit is used to control30 whether30 coverage30 is
  // done both in the monitor30 class and the interface.
  bit coverage_enable30 = 1;

  uvm_analysis_port #(spi_transfer30) item_collected_port30;

  // The following30 property holds30 the transaction information currently
  // begin captured30 (by the collect_receive_data30 and collect_transmit_data30 methods30).
  protected spi_transfer30 trans_collected30;

  // Events30 needed to trigger covergroups30
  protected event cov_transaction30;

  event new_transfer_started30;
  event new_bit_started30;

  // Transfer30 collected30 covergroup
  covergroup cov_trans_cg30 @cov_transaction30;
    option.per_instance = 1;
    trans_mode30 : coverpoint csr_s30.mode_select30;
    trans_cpha30 : coverpoint csr_s30.tx_clk_phase30;
    trans_size30 : coverpoint csr_s30.transfer_data_size30 {
      bins sizes30[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes30 = default; }
    trans_txdata30 : coverpoint trans_collected30.transfer_data30 {
      option.auto_bin_max = 8; }
    trans_rxdata30 : coverpoint trans_collected30.receive_data30 {
      option.auto_bin_max = 8; }
    trans_modeXsize30 : cross trans_mode30, trans_size30;
  endgroup : cov_trans_cg30

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor30)
    `uvm_field_int(agent_id30, UVM_ALL_ON)
    `uvm_field_int(coverage_enable30, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg30 = new();
    cov_trans_cg30.set_inst_name("spi_cov_trans_cg30");
    item_collected_port30 = new("item_collected_port30", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if30)::get(this, "", "spi_if30", spi_if30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".spi_if30"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions30();
    join
  endtask : run_phase

  // collect_transactions30
  virtual protected task collect_transactions30();
    forever begin
      @(negedge spi_if30.sig_n_ss_in30);
      trans_collected30 = new();
      -> new_transfer_started30;
      if (m_parent != null)
        trans_collected30.agent30 = m_parent.get_name();
      collect_transfer30();
      if (coverage_enable30)
         -> cov_transaction30;
      item_collected_port30.write(trans_collected30);
    end
  endtask : collect_transactions30

  // collect_transfer30
  virtual protected task collect_transfer30();
    void'(this.begin_tr(trans_collected30));
    if (csr_s30.tx_clk_phase30 == 0) begin
      `uvm_info("SPI_MON30", $psprintf("tx_clk_phase30 is %d", csr_s30.tx_clk_phase30), UVM_HIGH)
      for (int i = 0; i < csr_s30.data_size30; i++) begin
        @(negedge spi_if30.sig_sclk_in30);
        -> new_bit_started30;
        if (csr_s30.mode_select30 == 1) begin     //DUT MASTER30 mode, OVC30 Slave30 mode
          trans_collected30.receive_data30[i] = spi_if30.sig_si30;
          `uvm_info("SPI_MON30", $psprintf("received30 data in mode_select30 1 is %h", trans_collected30.receive_data30), UVM_HIGH)
        end else begin
          trans_collected30.receive_data30[i] = spi_if30.sig_mi30;
          `uvm_info("SPI_MON30", $psprintf("received30 data in mode_select30 0 is %h", trans_collected30.receive_data30), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON30", $psprintf("tx_clk_phase30 is %d", csr_s30.tx_clk_phase30), UVM_HIGH)
      for (int i = 0; i < csr_s30.data_size30; i++) begin
        @(posedge spi_if30.sig_sclk_in30);
        -> new_bit_started30;
        if (csr_s30.mode_select30 == 1) begin     //DUT MASTER30 mode, OVC30 Slave30 mode
          trans_collected30.receive_data30[i] = spi_if30.sig_si30;
          `uvm_info("SPI_MON30", $psprintf("received30 data in mode_select30 1 is %h", trans_collected30.receive_data30), UVM_HIGH)
        end else begin
          trans_collected30.receive_data30[i] = spi_if30.sig_mi30;
          `uvm_info("SPI_MON30", $psprintf("received30 data in mode_select30 0 is %h", trans_collected30.receive_data30), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON30", $psprintf("Transfer30 collected30 :\n%s", trans_collected30.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected30);
  endtask : collect_transfer30

endclass : spi_monitor30

`endif // SPI_MONITOR_SV30

