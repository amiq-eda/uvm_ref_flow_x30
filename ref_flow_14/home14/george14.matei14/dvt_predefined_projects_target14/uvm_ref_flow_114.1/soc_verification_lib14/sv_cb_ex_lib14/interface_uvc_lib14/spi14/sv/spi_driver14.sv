/*-------------------------------------------------------------------------
File14 name   : spi_driver14.sv
Title14       : SPI14 SystemVerilog14 UVM UVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV14
`define SPI_DRIVER_SV14

class spi_driver14 extends uvm_driver #(spi_transfer14);

  // The virtual interface used to drive14 and view14 HDL signals14.
  virtual spi_if14 spi_if14;

  spi_monitor14 monitor14;
  spi_csr_s14 csr_s14;

  // Agent14 Id14
  protected int agent_id14;

  // Provide14 implmentations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(spi_driver14)
    `uvm_field_int(agent_id14, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if14)::get(this, "", "spi_if14", spi_if14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".spi_if14"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive14();
      reset_signals14();
    join
  endtask : run_phase

  // get_and_drive14 
  virtual protected task get_and_drive14();
    uvm_sequence_item item;
    spi_transfer14 this_trans14;
    @(posedge spi_if14.sig_n_p_reset14);
    forever begin
      @(posedge spi_if14.sig_pclk14);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans14, req))
        `uvm_fatal("CASTFL14", "Failed14 to cast req to this_trans14 in get_and_drive14")
      drive_transfer14(this_trans14);
      seq_item_port.item_done();
    end
  endtask : get_and_drive14

  // reset_signals14
  virtual protected task reset_signals14();
      @(negedge spi_if14.sig_n_p_reset14);
      spi_if14.sig_slave_out_clk14  <= 'b0;
      spi_if14.sig_n_so_en14        <= 'b1;
      spi_if14.sig_so14             <= 'bz;
      spi_if14.sig_n_ss_en14        <= 'b1;
      spi_if14.sig_n_ss_out14       <= '1;
      spi_if14.sig_n_sclk_en14      <= 'b1;
      spi_if14.sig_sclk_out14       <= 'b0;
      spi_if14.sig_n_mo_en14        <= 'b1;
      spi_if14.sig_mo14             <= 'b0;
  endtask : reset_signals14

  // drive_transfer14
  virtual protected task drive_transfer14 (spi_transfer14 trans14);
    if (csr_s14.mode_select14 == 1) begin       //DUT MASTER14 mode, OVC14 SLAVE14 mode
      @monitor14.new_transfer_started14;
      for (int i = 0; i < csr_s14.data_size14; i++) begin
        @monitor14.new_bit_started14;
        spi_if14.sig_n_so_en14 <= 1'b0;
        spi_if14.sig_so14 <= trans14.transfer_data14[i];
      end
      spi_if14.sig_n_so_en14 <= 1'b1;
      `uvm_info("SPI_DRIVER14", $psprintf("Transfer14 sent14 :\n%s", trans14.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer14

endclass : spi_driver14

`endif // SPI_DRIVER_SV14

