/*-------------------------------------------------------------------------
File3 name   : spi_driver3.sv
Title3       : SPI3 SystemVerilog3 UVM UVC3
Project3     : SystemVerilog3 UVM Cluster3 Level3 Verification3
Created3     :
Description3 : 
Notes3       :  
---------------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV3
`define SPI_DRIVER_SV3

class spi_driver3 extends uvm_driver #(spi_transfer3);

  // The virtual interface used to drive3 and view3 HDL signals3.
  virtual spi_if3 spi_if3;

  spi_monitor3 monitor3;
  spi_csr_s3 csr_s3;

  // Agent3 Id3
  protected int agent_id3;

  // Provide3 implmentations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(spi_driver3)
    `uvm_field_int(agent_id3, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if3)::get(this, "", "spi_if3", spi_if3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".spi_if3"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive3();
      reset_signals3();
    join
  endtask : run_phase

  // get_and_drive3 
  virtual protected task get_and_drive3();
    uvm_sequence_item item;
    spi_transfer3 this_trans3;
    @(posedge spi_if3.sig_n_p_reset3);
    forever begin
      @(posedge spi_if3.sig_pclk3);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans3, req))
        `uvm_fatal("CASTFL3", "Failed3 to cast req to this_trans3 in get_and_drive3")
      drive_transfer3(this_trans3);
      seq_item_port.item_done();
    end
  endtask : get_and_drive3

  // reset_signals3
  virtual protected task reset_signals3();
      @(negedge spi_if3.sig_n_p_reset3);
      spi_if3.sig_slave_out_clk3  <= 'b0;
      spi_if3.sig_n_so_en3        <= 'b1;
      spi_if3.sig_so3             <= 'bz;
      spi_if3.sig_n_ss_en3        <= 'b1;
      spi_if3.sig_n_ss_out3       <= '1;
      spi_if3.sig_n_sclk_en3      <= 'b1;
      spi_if3.sig_sclk_out3       <= 'b0;
      spi_if3.sig_n_mo_en3        <= 'b1;
      spi_if3.sig_mo3             <= 'b0;
  endtask : reset_signals3

  // drive_transfer3
  virtual protected task drive_transfer3 (spi_transfer3 trans3);
    if (csr_s3.mode_select3 == 1) begin       //DUT MASTER3 mode, OVC3 SLAVE3 mode
      @monitor3.new_transfer_started3;
      for (int i = 0; i < csr_s3.data_size3; i++) begin
        @monitor3.new_bit_started3;
        spi_if3.sig_n_so_en3 <= 1'b0;
        spi_if3.sig_so3 <= trans3.transfer_data3[i];
      end
      spi_if3.sig_n_so_en3 <= 1'b1;
      `uvm_info("SPI_DRIVER3", $psprintf("Transfer3 sent3 :\n%s", trans3.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer3

endclass : spi_driver3

`endif // SPI_DRIVER_SV3

