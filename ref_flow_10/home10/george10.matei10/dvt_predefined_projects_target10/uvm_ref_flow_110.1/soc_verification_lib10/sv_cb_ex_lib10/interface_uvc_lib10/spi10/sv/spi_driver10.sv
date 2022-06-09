/*-------------------------------------------------------------------------
File10 name   : spi_driver10.sv
Title10       : SPI10 SystemVerilog10 UVM UVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV10
`define SPI_DRIVER_SV10

class spi_driver10 extends uvm_driver #(spi_transfer10);

  // The virtual interface used to drive10 and view10 HDL signals10.
  virtual spi_if10 spi_if10;

  spi_monitor10 monitor10;
  spi_csr_s10 csr_s10;

  // Agent10 Id10
  protected int agent_id10;

  // Provide10 implmentations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(spi_driver10)
    `uvm_field_int(agent_id10, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if10)::get(this, "", "spi_if10", spi_if10))
   `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".spi_if10"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive10();
      reset_signals10();
    join
  endtask : run_phase

  // get_and_drive10 
  virtual protected task get_and_drive10();
    uvm_sequence_item item;
    spi_transfer10 this_trans10;
    @(posedge spi_if10.sig_n_p_reset10);
    forever begin
      @(posedge spi_if10.sig_pclk10);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans10, req))
        `uvm_fatal("CASTFL10", "Failed10 to cast req to this_trans10 in get_and_drive10")
      drive_transfer10(this_trans10);
      seq_item_port.item_done();
    end
  endtask : get_and_drive10

  // reset_signals10
  virtual protected task reset_signals10();
      @(negedge spi_if10.sig_n_p_reset10);
      spi_if10.sig_slave_out_clk10  <= 'b0;
      spi_if10.sig_n_so_en10        <= 'b1;
      spi_if10.sig_so10             <= 'bz;
      spi_if10.sig_n_ss_en10        <= 'b1;
      spi_if10.sig_n_ss_out10       <= '1;
      spi_if10.sig_n_sclk_en10      <= 'b1;
      spi_if10.sig_sclk_out10       <= 'b0;
      spi_if10.sig_n_mo_en10        <= 'b1;
      spi_if10.sig_mo10             <= 'b0;
  endtask : reset_signals10

  // drive_transfer10
  virtual protected task drive_transfer10 (spi_transfer10 trans10);
    if (csr_s10.mode_select10 == 1) begin       //DUT MASTER10 mode, OVC10 SLAVE10 mode
      @monitor10.new_transfer_started10;
      for (int i = 0; i < csr_s10.data_size10; i++) begin
        @monitor10.new_bit_started10;
        spi_if10.sig_n_so_en10 <= 1'b0;
        spi_if10.sig_so10 <= trans10.transfer_data10[i];
      end
      spi_if10.sig_n_so_en10 <= 1'b1;
      `uvm_info("SPI_DRIVER10", $psprintf("Transfer10 sent10 :\n%s", trans10.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer10

endclass : spi_driver10

`endif // SPI_DRIVER_SV10

