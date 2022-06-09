/*-------------------------------------------------------------------------
File4 name   : spi_monitor4.sv
Title4       : SPI4 SystemVerilog4 UVM UVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV4
`define SPI_MONITOR_SV4

class spi_monitor4 extends uvm_monitor;

  // This4 property is the virtual interfaced4 needed for this component to
  // view4 HDL signals4. 
  virtual interface spi_if4 spi_if4;

  spi_csr_s4 csr_s4;

  // Agent4 Id4
  protected int agent_id4;

  // The following4 bit is used to control4 whether4 coverage4 is
  // done both in the monitor4 class and the interface.
  bit coverage_enable4 = 1;

  uvm_analysis_port #(spi_transfer4) item_collected_port4;

  // The following4 property holds4 the transaction information currently
  // begin captured4 (by the collect_receive_data4 and collect_transmit_data4 methods4).
  protected spi_transfer4 trans_collected4;

  // Events4 needed to trigger covergroups4
  protected event cov_transaction4;

  event new_transfer_started4;
  event new_bit_started4;

  // Transfer4 collected4 covergroup
  covergroup cov_trans_cg4 @cov_transaction4;
    option.per_instance = 1;
    trans_mode4 : coverpoint csr_s4.mode_select4;
    trans_cpha4 : coverpoint csr_s4.tx_clk_phase4;
    trans_size4 : coverpoint csr_s4.transfer_data_size4 {
      bins sizes4[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes4 = default; }
    trans_txdata4 : coverpoint trans_collected4.transfer_data4 {
      option.auto_bin_max = 8; }
    trans_rxdata4 : coverpoint trans_collected4.receive_data4 {
      option.auto_bin_max = 8; }
    trans_modeXsize4 : cross trans_mode4, trans_size4;
  endgroup : cov_trans_cg4

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor4)
    `uvm_field_int(agent_id4, UVM_ALL_ON)
    `uvm_field_int(coverage_enable4, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg4 = new();
    cov_trans_cg4.set_inst_name("spi_cov_trans_cg4");
    item_collected_port4 = new("item_collected_port4", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if4)::get(this, "", "spi_if4", spi_if4))
   `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".spi_if4"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions4();
    join
  endtask : run_phase

  // collect_transactions4
  virtual protected task collect_transactions4();
    forever begin
      @(negedge spi_if4.sig_n_ss_in4);
      trans_collected4 = new();
      -> new_transfer_started4;
      if (m_parent != null)
        trans_collected4.agent4 = m_parent.get_name();
      collect_transfer4();
      if (coverage_enable4)
         -> cov_transaction4;
      item_collected_port4.write(trans_collected4);
    end
  endtask : collect_transactions4

  // collect_transfer4
  virtual protected task collect_transfer4();
    void'(this.begin_tr(trans_collected4));
    if (csr_s4.tx_clk_phase4 == 0) begin
      `uvm_info("SPI_MON4", $psprintf("tx_clk_phase4 is %d", csr_s4.tx_clk_phase4), UVM_HIGH)
      for (int i = 0; i < csr_s4.data_size4; i++) begin
        @(negedge spi_if4.sig_sclk_in4);
        -> new_bit_started4;
        if (csr_s4.mode_select4 == 1) begin     //DUT MASTER4 mode, OVC4 Slave4 mode
          trans_collected4.receive_data4[i] = spi_if4.sig_si4;
          `uvm_info("SPI_MON4", $psprintf("received4 data in mode_select4 1 is %h", trans_collected4.receive_data4), UVM_HIGH)
        end else begin
          trans_collected4.receive_data4[i] = spi_if4.sig_mi4;
          `uvm_info("SPI_MON4", $psprintf("received4 data in mode_select4 0 is %h", trans_collected4.receive_data4), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON4", $psprintf("tx_clk_phase4 is %d", csr_s4.tx_clk_phase4), UVM_HIGH)
      for (int i = 0; i < csr_s4.data_size4; i++) begin
        @(posedge spi_if4.sig_sclk_in4);
        -> new_bit_started4;
        if (csr_s4.mode_select4 == 1) begin     //DUT MASTER4 mode, OVC4 Slave4 mode
          trans_collected4.receive_data4[i] = spi_if4.sig_si4;
          `uvm_info("SPI_MON4", $psprintf("received4 data in mode_select4 1 is %h", trans_collected4.receive_data4), UVM_HIGH)
        end else begin
          trans_collected4.receive_data4[i] = spi_if4.sig_mi4;
          `uvm_info("SPI_MON4", $psprintf("received4 data in mode_select4 0 is %h", trans_collected4.receive_data4), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON4", $psprintf("Transfer4 collected4 :\n%s", trans_collected4.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected4);
  endtask : collect_transfer4

endclass : spi_monitor4

`endif // SPI_MONITOR_SV4

