/*-------------------------------------------------------------------------
File20 name   : gpio_driver20.sv
Title20       : GPIO20 SystemVerilog20 UVM OVC20
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


`ifndef GPIO_DRIVER_SV20
`define GPIO_DRIVER_SV20

class gpio_driver20 extends uvm_driver #(gpio_transfer20);

  // The virtual interface used to drive20 and view20 HDL signals20.
  virtual gpio_if20 gpio_if20;

  // Provide20 implmentations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils(gpio_driver20)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if20)::get(this, "", "gpio_if20", gpio_if20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".gpio_if20"})
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
    gpio_transfer20 this_trans20;
    @(posedge gpio_if20.n_p_reset20);
    forever begin
      @(posedge gpio_if20.pclk20);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans20, req))
        `uvm_fatal("CASTFL20", "Failed20 to cast req to this_trans20 in get_and_drive20")
      drive_transfer20(this_trans20);
      seq_item_port.item_done();
    end
  endtask : get_and_drive20

  // reset_signals20
  virtual protected task reset_signals20();
      @(negedge gpio_if20.n_p_reset20);
      gpio_if20.gpio_pin_in20  <= 'b0;
  endtask : reset_signals20

  // drive_transfer20
  virtual protected task drive_transfer20 (gpio_transfer20 trans20);
    if (trans20.transmit_delay20 > 0) begin
      repeat(trans20.transmit_delay20) @(posedge gpio_if20.pclk20);
    end
    drive_data20(trans20);
  endtask : drive_transfer20

  virtual protected task drive_data20 (gpio_transfer20 trans20);
    @gpio_if20.pclk20;
    for (int i = 0; i < `GPIO_DATA_WIDTH20; i++) begin
      if (gpio_if20.n_gpio_pin_oe20[i] == 0) begin
        trans20.transfer_data20[i] = gpio_if20.gpio_pin_out20[i];
        gpio_if20.gpio_pin_in20[i] = gpio_if20.gpio_pin_out20[i];
      end else
        gpio_if20.gpio_pin_in20[i] = trans20.transfer_data20[i];
    end
    `uvm_info("GPIO_DRIVER20", $psprintf("GPIO20 Transfer20:\n%s", trans20.sprint()), UVM_MEDIUM)
  endtask : drive_data20

endclass : gpio_driver20

`endif // GPIO_DRIVER_SV20

