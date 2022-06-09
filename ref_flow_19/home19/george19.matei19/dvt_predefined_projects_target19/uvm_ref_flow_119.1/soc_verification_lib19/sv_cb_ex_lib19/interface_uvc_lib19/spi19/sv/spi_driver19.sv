/*-------------------------------------------------------------------------
File19 name   : spi_driver19.sv
Title19       : SPI19 SystemVerilog19 UVM UVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV19
`define SPI_DRIVER_SV19

class spi_driver19 extends uvm_driver #(spi_transfer19);

  // The virtual interface used to drive19 and view19 HDL signals19.
  virtual spi_if19 spi_if19;

  spi_monitor19 monitor19;
  spi_csr_s19 csr_s19;

  // Agent19 Id19
  protected int agent_id19;

  // Provide19 implmentations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(spi_driver19)
    `uvm_field_int(agent_id19, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if19)::get(this, "", "spi_if19", spi_if19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".spi_if19"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive19();
      reset_signals19();
    join
  endtask : run_phase

  // get_and_drive19 
  virtual protected task get_and_drive19();
    uvm_sequence_item item;
    spi_transfer19 this_trans19;
    @(posedge spi_if19.sig_n_p_reset19);
    forever begin
      @(posedge spi_if19.sig_pclk19);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans19, req))
        `uvm_fatal("CASTFL19", "Failed19 to cast req to this_trans19 in get_and_drive19")
      drive_transfer19(this_trans19);
      seq_item_port.item_done();
    end
  endtask : get_and_drive19

  // reset_signals19
  virtual protected task reset_signals19();
      @(negedge spi_if19.sig_n_p_reset19);
      spi_if19.sig_slave_out_clk19  <= 'b0;
      spi_if19.sig_n_so_en19        <= 'b1;
      spi_if19.sig_so19             <= 'bz;
      spi_if19.sig_n_ss_en19        <= 'b1;
      spi_if19.sig_n_ss_out19       <= '1;
      spi_if19.sig_n_sclk_en19      <= 'b1;
      spi_if19.sig_sclk_out19       <= 'b0;
      spi_if19.sig_n_mo_en19        <= 'b1;
      spi_if19.sig_mo19             <= 'b0;
  endtask : reset_signals19

  // drive_transfer19
  virtual protected task drive_transfer19 (spi_transfer19 trans19);
    if (csr_s19.mode_select19 == 1) begin       //DUT MASTER19 mode, OVC19 SLAVE19 mode
      @monitor19.new_transfer_started19;
      for (int i = 0; i < csr_s19.data_size19; i++) begin
        @monitor19.new_bit_started19;
        spi_if19.sig_n_so_en19 <= 1'b0;
        spi_if19.sig_so19 <= trans19.transfer_data19[i];
      end
      spi_if19.sig_n_so_en19 <= 1'b1;
      `uvm_info("SPI_DRIVER19", $psprintf("Transfer19 sent19 :\n%s", trans19.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer19

endclass : spi_driver19

`endif // SPI_DRIVER_SV19

