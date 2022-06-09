/*-------------------------------------------------------------------------
File21 name   : spi_monitor21.sv
Title21       : SPI21 SystemVerilog21 UVM UVC21
Project21     : SystemVerilog21 UVM Cluster21 Level21 Verification21
Created21     :
Description21 : 
Notes21       :  
---------------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef SPI_MONITOR_SV21
`define SPI_MONITOR_SV21

class spi_monitor21 extends uvm_monitor;

  // This21 property is the virtual interfaced21 needed for this component to
  // view21 HDL signals21. 
  virtual interface spi_if21 spi_if21;

  spi_csr_s21 csr_s21;

  // Agent21 Id21
  protected int agent_id21;

  // The following21 bit is used to control21 whether21 coverage21 is
  // done both in the monitor21 class and the interface.
  bit coverage_enable21 = 1;

  uvm_analysis_port #(spi_transfer21) item_collected_port21;

  // The following21 property holds21 the transaction information currently
  // begin captured21 (by the collect_receive_data21 and collect_transmit_data21 methods21).
  protected spi_transfer21 trans_collected21;

  // Events21 needed to trigger covergroups21
  protected event cov_transaction21;

  event new_transfer_started21;
  event new_bit_started21;

  // Transfer21 collected21 covergroup
  covergroup cov_trans_cg21 @cov_transaction21;
    option.per_instance = 1;
    trans_mode21 : coverpoint csr_s21.mode_select21;
    trans_cpha21 : coverpoint csr_s21.tx_clk_phase21;
    trans_size21 : coverpoint csr_s21.transfer_data_size21 {
      bins sizes21[] = {0, 1, 2, 3, 8};
      illegal_bins invalid_sizes21 = default; }
    trans_txdata21 : coverpoint trans_collected21.transfer_data21 {
      option.auto_bin_max = 8; }
    trans_rxdata21 : coverpoint trans_collected21.receive_data21 {
      option.auto_bin_max = 8; }
    trans_modeXsize21 : cross trans_mode21, trans_size21;
  endgroup : cov_trans_cg21

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(spi_monitor21)
    `uvm_field_int(agent_id21, UVM_ALL_ON)
    `uvm_field_int(coverage_enable21, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    cov_trans_cg21 = new();
    cov_trans_cg21.set_inst_name("spi_cov_trans_cg21");
    item_collected_port21 = new("item_collected_port21", this);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if21)::get(this, "", "spi_if21", spi_if21))
   `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".spi_if21"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions21();
    join
  endtask : run_phase

  // collect_transactions21
  virtual protected task collect_transactions21();
    forever begin
      @(negedge spi_if21.sig_n_ss_in21);
      trans_collected21 = new();
      -> new_transfer_started21;
      if (m_parent != null)
        trans_collected21.agent21 = m_parent.get_name();
      collect_transfer21();
      if (coverage_enable21)
         -> cov_transaction21;
      item_collected_port21.write(trans_collected21);
    end
  endtask : collect_transactions21

  // collect_transfer21
  virtual protected task collect_transfer21();
    void'(this.begin_tr(trans_collected21));
    if (csr_s21.tx_clk_phase21 == 0) begin
      `uvm_info("SPI_MON21", $psprintf("tx_clk_phase21 is %d", csr_s21.tx_clk_phase21), UVM_HIGH)
      for (int i = 0; i < csr_s21.data_size21; i++) begin
        @(negedge spi_if21.sig_sclk_in21);
        -> new_bit_started21;
        if (csr_s21.mode_select21 == 1) begin     //DUT MASTER21 mode, OVC21 Slave21 mode
          trans_collected21.receive_data21[i] = spi_if21.sig_si21;
          `uvm_info("SPI_MON21", $psprintf("received21 data in mode_select21 1 is %h", trans_collected21.receive_data21), UVM_HIGH)
        end else begin
          trans_collected21.receive_data21[i] = spi_if21.sig_mi21;
          `uvm_info("SPI_MON21", $psprintf("received21 data in mode_select21 0 is %h", trans_collected21.receive_data21), UVM_HIGH)
        end
      end
    end else begin
      `uvm_info("SPI_MON21", $psprintf("tx_clk_phase21 is %d", csr_s21.tx_clk_phase21), UVM_HIGH)
      for (int i = 0; i < csr_s21.data_size21; i++) begin
        @(posedge spi_if21.sig_sclk_in21);
        -> new_bit_started21;
        if (csr_s21.mode_select21 == 1) begin     //DUT MASTER21 mode, OVC21 Slave21 mode
          trans_collected21.receive_data21[i] = spi_if21.sig_si21;
          `uvm_info("SPI_MON21", $psprintf("received21 data in mode_select21 1 is %h", trans_collected21.receive_data21), UVM_HIGH)
        end else begin
          trans_collected21.receive_data21[i] = spi_if21.sig_mi21;
          `uvm_info("SPI_MON21", $psprintf("received21 data in mode_select21 0 is %h", trans_collected21.receive_data21), UVM_HIGH)
        end
      end
    end
    `uvm_info("SPI_MON21", $psprintf("Transfer21 collected21 :\n%s", trans_collected21.sprint()), UVM_MEDIUM)
    this.end_tr(trans_collected21);
  endtask : collect_transfer21

endclass : spi_monitor21

`endif // SPI_MONITOR_SV21

