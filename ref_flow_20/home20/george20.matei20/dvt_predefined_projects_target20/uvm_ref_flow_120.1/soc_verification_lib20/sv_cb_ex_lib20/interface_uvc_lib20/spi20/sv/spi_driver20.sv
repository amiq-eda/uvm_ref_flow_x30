/*-------------------------------------------------------------------------
File20 name   : spi_driver20.sv
Title20       : SPI20 SystemVerilog20 UVM UVC20
Project20     : SystemVerilog20 UVM Cluster20 Level20 Verification20
Created20     :
Description20 : 
Notes20       :  
---------------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV20
`define SPI_DRIVER_SV20

class spi_driver20 extends uvm_driver #(spi_transfer20);

  // The virtual interface used to drive20 and view20 HDL signals20.
  virtual spi_if20 spi_if20;

  spi_monitor20 monitor20;
  spi_csr_s20 csr_s20;

  // Agent20 Id20
  protected int agent_id20;

  // Provide20 implmentations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(spi_driver20)
    `uvm_field_int(agent_id20, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if20)::get(this, "", "spi_if20", spi_if20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".spi_if20"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive20();
      reset_signals20();
    join
  endtask : run_phase

  // get_and_drive20 
  virtual protected task get_and_drive20();
    uvm_sequence_item item;
    spi_transfer20 this_trans20;
    @(posedge spi_if20.sig_n_p_reset20);
    forever begin
      @(posedge spi_if20.sig_pclk20);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans20, req))
        `uvm_fatal("CASTFL20", "Failed20 to cast req to this_trans20 in get_and_drive20")
      drive_transfer20(this_trans20);
      seq_item_port.item_done();
    end
  endtask : get_and_drive20

  // reset_signals20
  virtual protected task reset_signals20();
      @(negedge spi_if20.sig_n_p_reset20);
      spi_if20.sig_slave_out_clk20  <= 'b0;
      spi_if20.sig_n_so_en20        <= 'b1;
      spi_if20.sig_so20             <= 'bz;
      spi_if20.sig_n_ss_en20        <= 'b1;
      spi_if20.sig_n_ss_out20       <= '1;
      spi_if20.sig_n_sclk_en20      <= 'b1;
      spi_if20.sig_sclk_out20       <= 'b0;
      spi_if20.sig_n_mo_en20        <= 'b1;
      spi_if20.sig_mo20             <= 'b0;
  endtask : reset_signals20

  // drive_transfer20
  virtual protected task drive_transfer20 (spi_transfer20 trans20);
    if (csr_s20.mode_select20 == 1) begin       //DUT MASTER20 mode, OVC20 SLAVE20 mode
      @monitor20.new_transfer_started20;
      for (int i = 0; i < csr_s20.data_size20; i++) begin
        @monitor20.new_bit_started20;
        spi_if20.sig_n_so_en20 <= 1'b0;
        spi_if20.sig_so20 <= trans20.transfer_data20[i];
      end
      spi_if20.sig_n_so_en20 <= 1'b1;
      `uvm_info("SPI_DRIVER20", $psprintf("Transfer20 sent20 :\n%s", trans20.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer20

endclass : spi_driver20

`endif // SPI_DRIVER_SV20

