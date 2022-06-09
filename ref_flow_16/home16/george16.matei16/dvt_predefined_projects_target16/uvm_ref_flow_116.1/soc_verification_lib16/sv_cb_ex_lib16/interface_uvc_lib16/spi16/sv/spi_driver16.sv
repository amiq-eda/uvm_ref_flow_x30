/*-------------------------------------------------------------------------
File16 name   : spi_driver16.sv
Title16       : SPI16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV16
`define SPI_DRIVER_SV16

class spi_driver16 extends uvm_driver #(spi_transfer16);

  // The virtual interface used to drive16 and view16 HDL signals16.
  virtual spi_if16 spi_if16;

  spi_monitor16 monitor16;
  spi_csr_s16 csr_s16;

  // Agent16 Id16
  protected int agent_id16;

  // Provide16 implmentations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(spi_driver16)
    `uvm_field_int(agent_id16, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if16)::get(this, "", "spi_if16", spi_if16))
   `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".spi_if16"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive16();
      reset_signals16();
    join
  endtask : run_phase

  // get_and_drive16 
  virtual protected task get_and_drive16();
    uvm_sequence_item item;
    spi_transfer16 this_trans16;
    @(posedge spi_if16.sig_n_p_reset16);
    forever begin
      @(posedge spi_if16.sig_pclk16);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans16, req))
        `uvm_fatal("CASTFL16", "Failed16 to cast req to this_trans16 in get_and_drive16")
      drive_transfer16(this_trans16);
      seq_item_port.item_done();
    end
  endtask : get_and_drive16

  // reset_signals16
  virtual protected task reset_signals16();
      @(negedge spi_if16.sig_n_p_reset16);
      spi_if16.sig_slave_out_clk16  <= 'b0;
      spi_if16.sig_n_so_en16        <= 'b1;
      spi_if16.sig_so16             <= 'bz;
      spi_if16.sig_n_ss_en16        <= 'b1;
      spi_if16.sig_n_ss_out16       <= '1;
      spi_if16.sig_n_sclk_en16      <= 'b1;
      spi_if16.sig_sclk_out16       <= 'b0;
      spi_if16.sig_n_mo_en16        <= 'b1;
      spi_if16.sig_mo16             <= 'b0;
  endtask : reset_signals16

  // drive_transfer16
  virtual protected task drive_transfer16 (spi_transfer16 trans16);
    if (csr_s16.mode_select16 == 1) begin       //DUT MASTER16 mode, OVC16 SLAVE16 mode
      @monitor16.new_transfer_started16;
      for (int i = 0; i < csr_s16.data_size16; i++) begin
        @monitor16.new_bit_started16;
        spi_if16.sig_n_so_en16 <= 1'b0;
        spi_if16.sig_so16 <= trans16.transfer_data16[i];
      end
      spi_if16.sig_n_so_en16 <= 1'b1;
      `uvm_info("SPI_DRIVER16", $psprintf("Transfer16 sent16 :\n%s", trans16.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer16

endclass : spi_driver16

`endif // SPI_DRIVER_SV16

