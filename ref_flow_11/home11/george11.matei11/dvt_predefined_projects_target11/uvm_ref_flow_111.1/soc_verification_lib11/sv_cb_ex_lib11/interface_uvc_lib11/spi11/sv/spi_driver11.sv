/*-------------------------------------------------------------------------
File11 name   : spi_driver11.sv
Title11       : SPI11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV11
`define SPI_DRIVER_SV11

class spi_driver11 extends uvm_driver #(spi_transfer11);

  // The virtual interface used to drive11 and view11 HDL signals11.
  virtual spi_if11 spi_if11;

  spi_monitor11 monitor11;
  spi_csr_s11 csr_s11;

  // Agent11 Id11
  protected int agent_id11;

  // Provide11 implmentations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(spi_driver11)
    `uvm_field_int(agent_id11, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if11)::get(this, "", "spi_if11", spi_if11))
   `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".spi_if11"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive11();
      reset_signals11();
    join
  endtask : run_phase

  // get_and_drive11 
  virtual protected task get_and_drive11();
    uvm_sequence_item item;
    spi_transfer11 this_trans11;
    @(posedge spi_if11.sig_n_p_reset11);
    forever begin
      @(posedge spi_if11.sig_pclk11);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans11, req))
        `uvm_fatal("CASTFL11", "Failed11 to cast req to this_trans11 in get_and_drive11")
      drive_transfer11(this_trans11);
      seq_item_port.item_done();
    end
  endtask : get_and_drive11

  // reset_signals11
  virtual protected task reset_signals11();
      @(negedge spi_if11.sig_n_p_reset11);
      spi_if11.sig_slave_out_clk11  <= 'b0;
      spi_if11.sig_n_so_en11        <= 'b1;
      spi_if11.sig_so11             <= 'bz;
      spi_if11.sig_n_ss_en11        <= 'b1;
      spi_if11.sig_n_ss_out11       <= '1;
      spi_if11.sig_n_sclk_en11      <= 'b1;
      spi_if11.sig_sclk_out11       <= 'b0;
      spi_if11.sig_n_mo_en11        <= 'b1;
      spi_if11.sig_mo11             <= 'b0;
  endtask : reset_signals11

  // drive_transfer11
  virtual protected task drive_transfer11 (spi_transfer11 trans11);
    if (csr_s11.mode_select11 == 1) begin       //DUT MASTER11 mode, OVC11 SLAVE11 mode
      @monitor11.new_transfer_started11;
      for (int i = 0; i < csr_s11.data_size11; i++) begin
        @monitor11.new_bit_started11;
        spi_if11.sig_n_so_en11 <= 1'b0;
        spi_if11.sig_so11 <= trans11.transfer_data11[i];
      end
      spi_if11.sig_n_so_en11 <= 1'b1;
      `uvm_info("SPI_DRIVER11", $psprintf("Transfer11 sent11 :\n%s", trans11.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer11

endclass : spi_driver11

`endif // SPI_DRIVER_SV11

