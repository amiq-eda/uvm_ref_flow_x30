/*-------------------------------------------------------------------------
File7 name   : spi_driver7.sv
Title7       : SPI7 SystemVerilog7 UVM UVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV7
`define SPI_DRIVER_SV7

class spi_driver7 extends uvm_driver #(spi_transfer7);

  // The virtual interface used to drive7 and view7 HDL signals7.
  virtual spi_if7 spi_if7;

  spi_monitor7 monitor7;
  spi_csr_s7 csr_s7;

  // Agent7 Id7
  protected int agent_id7;

  // Provide7 implmentations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(spi_driver7)
    `uvm_field_int(agent_id7, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if7)::get(this, "", "spi_if7", spi_if7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".spi_if7"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive7();
      reset_signals7();
    join
  endtask : run_phase

  // get_and_drive7 
  virtual protected task get_and_drive7();
    uvm_sequence_item item;
    spi_transfer7 this_trans7;
    @(posedge spi_if7.sig_n_p_reset7);
    forever begin
      @(posedge spi_if7.sig_pclk7);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans7, req))
        `uvm_fatal("CASTFL7", "Failed7 to cast req to this_trans7 in get_and_drive7")
      drive_transfer7(this_trans7);
      seq_item_port.item_done();
    end
  endtask : get_and_drive7

  // reset_signals7
  virtual protected task reset_signals7();
      @(negedge spi_if7.sig_n_p_reset7);
      spi_if7.sig_slave_out_clk7  <= 'b0;
      spi_if7.sig_n_so_en7        <= 'b1;
      spi_if7.sig_so7             <= 'bz;
      spi_if7.sig_n_ss_en7        <= 'b1;
      spi_if7.sig_n_ss_out7       <= '1;
      spi_if7.sig_n_sclk_en7      <= 'b1;
      spi_if7.sig_sclk_out7       <= 'b0;
      spi_if7.sig_n_mo_en7        <= 'b1;
      spi_if7.sig_mo7             <= 'b0;
  endtask : reset_signals7

  // drive_transfer7
  virtual protected task drive_transfer7 (spi_transfer7 trans7);
    if (csr_s7.mode_select7 == 1) begin       //DUT MASTER7 mode, OVC7 SLAVE7 mode
      @monitor7.new_transfer_started7;
      for (int i = 0; i < csr_s7.data_size7; i++) begin
        @monitor7.new_bit_started7;
        spi_if7.sig_n_so_en7 <= 1'b0;
        spi_if7.sig_so7 <= trans7.transfer_data7[i];
      end
      spi_if7.sig_n_so_en7 <= 1'b1;
      `uvm_info("SPI_DRIVER7", $psprintf("Transfer7 sent7 :\n%s", trans7.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer7

endclass : spi_driver7

`endif // SPI_DRIVER_SV7

