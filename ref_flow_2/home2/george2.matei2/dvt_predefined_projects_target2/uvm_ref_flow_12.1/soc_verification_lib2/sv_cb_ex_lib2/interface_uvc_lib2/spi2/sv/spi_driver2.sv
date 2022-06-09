/*-------------------------------------------------------------------------
File2 name   : spi_driver2.sv
Title2       : SPI2 SystemVerilog2 UVM UVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef SPI_DRIVER_SV2
`define SPI_DRIVER_SV2

class spi_driver2 extends uvm_driver #(spi_transfer2);

  // The virtual interface used to drive2 and view2 HDL signals2.
  virtual spi_if2 spi_if2;

  spi_monitor2 monitor2;
  spi_csr_s2 csr_s2;

  // Agent2 Id2
  protected int agent_id2;

  // Provide2 implmentations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(spi_driver2)
    `uvm_field_int(agent_id2, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual spi_if2)::get(this, "", "spi_if2", spi_if2))
   `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".spi_if2"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive2();
      reset_signals2();
    join
  endtask : run_phase

  // get_and_drive2 
  virtual protected task get_and_drive2();
    uvm_sequence_item item;
    spi_transfer2 this_trans2;
    @(posedge spi_if2.sig_n_p_reset2);
    forever begin
      @(posedge spi_if2.sig_pclk2);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans2, req))
        `uvm_fatal("CASTFL2", "Failed2 to cast req to this_trans2 in get_and_drive2")
      drive_transfer2(this_trans2);
      seq_item_port.item_done();
    end
  endtask : get_and_drive2

  // reset_signals2
  virtual protected task reset_signals2();
      @(negedge spi_if2.sig_n_p_reset2);
      spi_if2.sig_slave_out_clk2  <= 'b0;
      spi_if2.sig_n_so_en2        <= 'b1;
      spi_if2.sig_so2             <= 'bz;
      spi_if2.sig_n_ss_en2        <= 'b1;
      spi_if2.sig_n_ss_out2       <= '1;
      spi_if2.sig_n_sclk_en2      <= 'b1;
      spi_if2.sig_sclk_out2       <= 'b0;
      spi_if2.sig_n_mo_en2        <= 'b1;
      spi_if2.sig_mo2             <= 'b0;
  endtask : reset_signals2

  // drive_transfer2
  virtual protected task drive_transfer2 (spi_transfer2 trans2);
    if (csr_s2.mode_select2 == 1) begin       //DUT MASTER2 mode, OVC2 SLAVE2 mode
      @monitor2.new_transfer_started2;
      for (int i = 0; i < csr_s2.data_size2; i++) begin
        @monitor2.new_bit_started2;
        spi_if2.sig_n_so_en2 <= 1'b0;
        spi_if2.sig_so2 <= trans2.transfer_data2[i];
      end
      spi_if2.sig_n_so_en2 <= 1'b1;
      `uvm_info("SPI_DRIVER2", $psprintf("Transfer2 sent2 :\n%s", trans2.sprint()), UVM_MEDIUM)
    end
  endtask : drive_transfer2

endclass : spi_driver2

`endif // SPI_DRIVER_SV2

