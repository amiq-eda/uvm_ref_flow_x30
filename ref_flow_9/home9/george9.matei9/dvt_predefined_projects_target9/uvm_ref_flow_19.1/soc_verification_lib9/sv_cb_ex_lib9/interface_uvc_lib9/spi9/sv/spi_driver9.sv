/*-------------------------------------------------------------------------
File9 name   : spi_driver9.sv
Title9       : SPI9 SystemVerilog9 UVM UVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV9
`define SPI_DRIVER_SV9

class spi_driver9 extends uvm_driver #(spi_transfer9);

  // The virtual interface used to drive9 and view9 HDL signals9.
  virtual spi_if9 spi_if9;

  spi_monitor9 monitor9;
  spi_csr_s9 csr_s9;

  // Agent9 Id9
  protected int agent_id9;

  // Provide9 implmentations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(spi_driver9)
    `uvm_field_int(agent_id9, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if9)::get(this, "", "spi_if9", spi_if9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".spi_if9"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive9();
      reset_signals9();
    join
  endtask : run_phase

  // get_and_drive9 
  virtual protected task get_and_drive9();
    uvm_sequence_item item;
    spi_transfer9 this_trans9;
    @(posedge spi_if9.sig_n_p_reset9);
    forever begin
      @(posedge spi_if9.sig_pclk9);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans9, req))
        `uvm_fatal("CASTFL9", "Failed9 to cast req to this_trans9 in get_and_drive9")
      drive_transfer9(this_trans9);
      seq_item_port.item_done();
    end
  endtask : get_and_drive9

  // reset_signals9
  virtual protected task reset_signals9();
      @(negedge spi_if9.sig_n_p_reset9);
      spi_if9.sig_slave_out_clk9  <= 'b0;
      spi_if9.sig_n_so_en9        <= 'b1;
      spi_if9.sig_so9             <= 'bz;
      spi_if9.sig_n_ss_en9        <= 'b1;
      spi_if9.sig_n_ss_out9       <= '1;
      spi_if9.sig_n_sclk_en9      <= 'b1;
      spi_if9.sig_sclk_out9       <= 'b0;
      spi_if9.sig_n_mo_en9        <= 'b1;
      spi_if9.sig_mo9             <= 'b0;
  endtask : reset_signals9

  // drive_transfer9
  virtual protected task drive_transfer9 (spi_transfer9 trans9);
    if (csr_s9.mode_select9 == 1) begin       //DUT MASTER9 mode, OVC9 SLAVE9 mode
      @monitor9.new_transfer_started9;
      for (int i = 0; i < csr_s9.data_size9; i++) begin
        @monitor9.new_bit_started9;
        spi_if9.sig_n_so_en9 <= 1'b0;
        spi_if9.sig_so9 <= trans9.transfer_data9[i];
      end
      spi_if9.sig_n_so_en9 <= 1'b1;
      `uvm_info("SPI_DRIVER9", $psprintf("Transfer9 sent9 :\n%s", trans9.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer9

endclass : spi_driver9

`endif // SPI_DRIVER_SV9

