/*-------------------------------------------------------------------------
File13 name   : spi_driver13.sv
Title13       : SPI13 SystemVerilog13 UVM UVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV13
`define SPI_DRIVER_SV13

class spi_driver13 extends uvm_driver #(spi_transfer13);

  // The virtual interface used to drive13 and view13 HDL signals13.
  virtual spi_if13 spi_if13;

  spi_monitor13 monitor13;
  spi_csr_s13 csr_s13;

  // Agent13 Id13
  protected int agent_id13;

  // Provide13 implmentations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(spi_driver13)
    `uvm_field_int(agent_id13, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if13)::get(this, "", "spi_if13", spi_if13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".spi_if13"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive13();
      reset_signals13();
    join
  endtask : run_phase

  // get_and_drive13 
  virtual protected task get_and_drive13();
    uvm_sequence_item item;
    spi_transfer13 this_trans13;
    @(posedge spi_if13.sig_n_p_reset13);
    forever begin
      @(posedge spi_if13.sig_pclk13);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans13, req))
        `uvm_fatal("CASTFL13", "Failed13 to cast req to this_trans13 in get_and_drive13")
      drive_transfer13(this_trans13);
      seq_item_port.item_done();
    end
  endtask : get_and_drive13

  // reset_signals13
  virtual protected task reset_signals13();
      @(negedge spi_if13.sig_n_p_reset13);
      spi_if13.sig_slave_out_clk13  <= 'b0;
      spi_if13.sig_n_so_en13        <= 'b1;
      spi_if13.sig_so13             <= 'bz;
      spi_if13.sig_n_ss_en13        <= 'b1;
      spi_if13.sig_n_ss_out13       <= '1;
      spi_if13.sig_n_sclk_en13      <= 'b1;
      spi_if13.sig_sclk_out13       <= 'b0;
      spi_if13.sig_n_mo_en13        <= 'b1;
      spi_if13.sig_mo13             <= 'b0;
  endtask : reset_signals13

  // drive_transfer13
  virtual protected task drive_transfer13 (spi_transfer13 trans13);
    if (csr_s13.mode_select13 == 1) begin       //DUT MASTER13 mode, OVC13 SLAVE13 mode
      @monitor13.new_transfer_started13;
      for (int i = 0; i < csr_s13.data_size13; i++) begin
        @monitor13.new_bit_started13;
        spi_if13.sig_n_so_en13 <= 1'b0;
        spi_if13.sig_so13 <= trans13.transfer_data13[i];
      end
      spi_if13.sig_n_so_en13 <= 1'b1;
      `uvm_info("SPI_DRIVER13", $psprintf("Transfer13 sent13 :\n%s", trans13.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer13

endclass : spi_driver13

`endif // SPI_DRIVER_SV13

