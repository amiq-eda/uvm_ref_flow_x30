/*-------------------------------------------------------------------------
File4 name   : spi_driver4.sv
Title4       : SPI4 SystemVerilog4 UVM UVC4
Project4     : SystemVerilog4 UVM Cluster4 Level4 Verification4
Created4     :
Description4 : 
Notes4       :  
---------------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV4
`define SPI_DRIVER_SV4

class spi_driver4 extends uvm_driver #(spi_transfer4);

  // The virtual interface used to drive4 and view4 HDL signals4.
  virtual spi_if4 spi_if4;

  spi_monitor4 monitor4;
  spi_csr_s4 csr_s4;

  // Agent4 Id4
  protected int agent_id4;

  // Provide4 implmentations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(spi_driver4)
    `uvm_field_int(agent_id4, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if4)::get(this, "", "spi_if4", spi_if4))
   `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".spi_if4"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive4();
      reset_signals4();
    join
  endtask : run_phase

  // get_and_drive4 
  virtual protected task get_and_drive4();
    uvm_sequence_item item;
    spi_transfer4 this_trans4;
    @(posedge spi_if4.sig_n_p_reset4);
    forever begin
      @(posedge spi_if4.sig_pclk4);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans4, req))
        `uvm_fatal("CASTFL4", "Failed4 to cast req to this_trans4 in get_and_drive4")
      drive_transfer4(this_trans4);
      seq_item_port.item_done();
    end
  endtask : get_and_drive4

  // reset_signals4
  virtual protected task reset_signals4();
      @(negedge spi_if4.sig_n_p_reset4);
      spi_if4.sig_slave_out_clk4  <= 'b0;
      spi_if4.sig_n_so_en4        <= 'b1;
      spi_if4.sig_so4             <= 'bz;
      spi_if4.sig_n_ss_en4        <= 'b1;
      spi_if4.sig_n_ss_out4       <= '1;
      spi_if4.sig_n_sclk_en4      <= 'b1;
      spi_if4.sig_sclk_out4       <= 'b0;
      spi_if4.sig_n_mo_en4        <= 'b1;
      spi_if4.sig_mo4             <= 'b0;
  endtask : reset_signals4

  // drive_transfer4
  virtual protected task drive_transfer4 (spi_transfer4 trans4);
    if (csr_s4.mode_select4 == 1) begin       //DUT MASTER4 mode, OVC4 SLAVE4 mode
      @monitor4.new_transfer_started4;
      for (int i = 0; i < csr_s4.data_size4; i++) begin
        @monitor4.new_bit_started4;
        spi_if4.sig_n_so_en4 <= 1'b0;
        spi_if4.sig_so4 <= trans4.transfer_data4[i];
      end
      spi_if4.sig_n_so_en4 <= 1'b1;
      `uvm_info("SPI_DRIVER4", $psprintf("Transfer4 sent4 :\n%s", trans4.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer4

endclass : spi_driver4

`endif // SPI_DRIVER_SV4

