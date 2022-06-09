/*-------------------------------------------------------------------------
File25 name   : spi_driver25.sv
Title25       : SPI25 SystemVerilog25 UVM UVC25
Project25     : SystemVerilog25 UVM Cluster25 Level25 Verification25
Created25     :
Description25 : 
Notes25       :  
---------------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV25
`define SPI_DRIVER_SV25

class spi_driver25 extends uvm_driver #(spi_transfer25);

  // The virtual interface used to drive25 and view25 HDL signals25.
  virtual spi_if25 spi_if25;

  spi_monitor25 monitor25;
  spi_csr_s25 csr_s25;

  // Agent25 Id25
  protected int agent_id25;

  // Provide25 implmentations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(spi_driver25)
    `uvm_field_int(agent_id25, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if25)::get(this, "", "spi_if25", spi_if25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".spi_if25"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive25();
      reset_signals25();
    join
  endtask : run_phase

  // get_and_drive25 
  virtual protected task get_and_drive25();
    uvm_sequence_item item;
    spi_transfer25 this_trans25;
    @(posedge spi_if25.sig_n_p_reset25);
    forever begin
      @(posedge spi_if25.sig_pclk25);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans25, req))
        `uvm_fatal("CASTFL25", "Failed25 to cast req to this_trans25 in get_and_drive25")
      drive_transfer25(this_trans25);
      seq_item_port.item_done();
    end
  endtask : get_and_drive25

  // reset_signals25
  virtual protected task reset_signals25();
      @(negedge spi_if25.sig_n_p_reset25);
      spi_if25.sig_slave_out_clk25  <= 'b0;
      spi_if25.sig_n_so_en25        <= 'b1;
      spi_if25.sig_so25             <= 'bz;
      spi_if25.sig_n_ss_en25        <= 'b1;
      spi_if25.sig_n_ss_out25       <= '1;
      spi_if25.sig_n_sclk_en25      <= 'b1;
      spi_if25.sig_sclk_out25       <= 'b0;
      spi_if25.sig_n_mo_en25        <= 'b1;
      spi_if25.sig_mo25             <= 'b0;
  endtask : reset_signals25

  // drive_transfer25
  virtual protected task drive_transfer25 (spi_transfer25 trans25);
    if (csr_s25.mode_select25 == 1) begin       //DUT MASTER25 mode, OVC25 SLAVE25 mode
      @monitor25.new_transfer_started25;
      for (int i = 0; i < csr_s25.data_size25; i++) begin
        @monitor25.new_bit_started25;
        spi_if25.sig_n_so_en25 <= 1'b0;
        spi_if25.sig_so25 <= trans25.transfer_data25[i];
      end
      spi_if25.sig_n_so_en25 <= 1'b1;
      `uvm_info("SPI_DRIVER25", $psprintf("Transfer25 sent25 :\n%s", trans25.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer25

endclass : spi_driver25

`endif // SPI_DRIVER_SV25

