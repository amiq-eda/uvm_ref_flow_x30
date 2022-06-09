/*-------------------------------------------------------------------------
File21 name   : spi_driver21.sv
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


`ifndef SPI_DRIVER_SV21
`define SPI_DRIVER_SV21

class spi_driver21 extends uvm_driver #(spi_transfer21);

  // The virtual interface used to drive21 and view21 HDL signals21.
  virtual spi_if21 spi_if21;

  spi_monitor21 monitor21;
  spi_csr_s21 csr_s21;

  // Agent21 Id21
  protected int agent_id21;

  // Provide21 implmentations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(spi_driver21)
    `uvm_field_int(agent_id21, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
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
      get_and_drive21();
      reset_signals21();
    join
  endtask : run_phase

  // get_and_drive21 
  virtual protected task get_and_drive21();
    uvm_sequence_item item;
    spi_transfer21 this_trans21;
    @(posedge spi_if21.sig_n_p_reset21);
    forever begin
      @(posedge spi_if21.sig_pclk21);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans21, req))
        `uvm_fatal("CASTFL21", "Failed21 to cast req to this_trans21 in get_and_drive21")
      drive_transfer21(this_trans21);
      seq_item_port.item_done();
    end
  endtask : get_and_drive21

  // reset_signals21
  virtual protected task reset_signals21();
      @(negedge spi_if21.sig_n_p_reset21);
      spi_if21.sig_slave_out_clk21  <= 'b0;
      spi_if21.sig_n_so_en21        <= 'b1;
      spi_if21.sig_so21             <= 'bz;
      spi_if21.sig_n_ss_en21        <= 'b1;
      spi_if21.sig_n_ss_out21       <= '1;
      spi_if21.sig_n_sclk_en21      <= 'b1;
      spi_if21.sig_sclk_out21       <= 'b0;
      spi_if21.sig_n_mo_en21        <= 'b1;
      spi_if21.sig_mo21             <= 'b0;
  endtask : reset_signals21

  // drive_transfer21
  virtual protected task drive_transfer21 (spi_transfer21 trans21);
    if (csr_s21.mode_select21 == 1) begin       //DUT MASTER21 mode, OVC21 SLAVE21 mode
      @monitor21.new_transfer_started21;
      for (int i = 0; i < csr_s21.data_size21; i++) begin
        @monitor21.new_bit_started21;
        spi_if21.sig_n_so_en21 <= 1'b0;
        spi_if21.sig_so21 <= trans21.transfer_data21[i];
      end
      spi_if21.sig_n_so_en21 <= 1'b1;
      `uvm_info("SPI_DRIVER21", $psprintf("Transfer21 sent21 :\n%s", trans21.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer21

endclass : spi_driver21

`endif // SPI_DRIVER_SV21

