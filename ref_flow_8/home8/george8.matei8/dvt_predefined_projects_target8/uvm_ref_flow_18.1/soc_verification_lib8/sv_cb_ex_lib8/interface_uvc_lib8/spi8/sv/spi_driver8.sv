/*-------------------------------------------------------------------------
File8 name   : spi_driver8.sv
Title8       : SPI8 SystemVerilog8 UVM UVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV8
`define SPI_DRIVER_SV8

class spi_driver8 extends uvm_driver #(spi_transfer8);

  // The virtual interface used to drive8 and view8 HDL signals8.
  virtual spi_if8 spi_if8;

  spi_monitor8 monitor8;
  spi_csr_s8 csr_s8;

  // Agent8 Id8
  protected int agent_id8;

  // Provide8 implmentations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(spi_driver8)
    `uvm_field_int(agent_id8, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if8)::get(this, "", "spi_if8", spi_if8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".spi_if8"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive8();
      reset_signals8();
    join
  endtask : run_phase

  // get_and_drive8 
  virtual protected task get_and_drive8();
    uvm_sequence_item item;
    spi_transfer8 this_trans8;
    @(posedge spi_if8.sig_n_p_reset8);
    forever begin
      @(posedge spi_if8.sig_pclk8);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans8, req))
        `uvm_fatal("CASTFL8", "Failed8 to cast req to this_trans8 in get_and_drive8")
      drive_transfer8(this_trans8);
      seq_item_port.item_done();
    end
  endtask : get_and_drive8

  // reset_signals8
  virtual protected task reset_signals8();
      @(negedge spi_if8.sig_n_p_reset8);
      spi_if8.sig_slave_out_clk8  <= 'b0;
      spi_if8.sig_n_so_en8        <= 'b1;
      spi_if8.sig_so8             <= 'bz;
      spi_if8.sig_n_ss_en8        <= 'b1;
      spi_if8.sig_n_ss_out8       <= '1;
      spi_if8.sig_n_sclk_en8      <= 'b1;
      spi_if8.sig_sclk_out8       <= 'b0;
      spi_if8.sig_n_mo_en8        <= 'b1;
      spi_if8.sig_mo8             <= 'b0;
  endtask : reset_signals8

  // drive_transfer8
  virtual protected task drive_transfer8 (spi_transfer8 trans8);
    if (csr_s8.mode_select8 == 1) begin       //DUT MASTER8 mode, OVC8 SLAVE8 mode
      @monitor8.new_transfer_started8;
      for (int i = 0; i < csr_s8.data_size8; i++) begin
        @monitor8.new_bit_started8;
        spi_if8.sig_n_so_en8 <= 1'b0;
        spi_if8.sig_so8 <= trans8.transfer_data8[i];
      end
      spi_if8.sig_n_so_en8 <= 1'b1;
      `uvm_info("SPI_DRIVER8", $psprintf("Transfer8 sent8 :\n%s", trans8.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer8

endclass : spi_driver8

`endif // SPI_DRIVER_SV8

