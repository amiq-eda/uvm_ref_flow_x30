/*-------------------------------------------------------------------------
File27 name   : gpio_driver27.sv
Title27       : GPIO27 SystemVerilog27 UVM OVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV27
`define GPIO_DRIVER_SV27

class gpio_driver27 extends uvm_driver #(gpio_transfer27);

  // The virtual interface used to drive27 and view27 HDL signals27.
  virtual gpio_if27 gpio_if27;

  // Provide27 implmentations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils(gpio_driver27)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if27)::get(this, "", "gpio_if27", gpio_if27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".gpio_if27"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive27();
      reset_signals27();
    join
  endtask : run_phase

  // get_and_drive27 
  virtual protected task get_and_drive27();
    uvm_sequence_item item;
    gpio_transfer27 this_trans27;
    @(posedge gpio_if27.n_p_reset27);
    forever begin
      @(posedge gpio_if27.pclk27);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans27, req))
        `uvm_fatal("CASTFL27", "Failed27 to cast req to this_trans27 in get_and_drive27")
      drive_transfer27(this_trans27);
      seq_item_port.item_done();
    end
  endtask : get_and_drive27

  // reset_signals27
  virtual protected task reset_signals27();
      @(negedge gpio_if27.n_p_reset27);
      gpio_if27.gpio_pin_in27  <= 'b0;
  endtask : reset_signals27

  // drive_transfer27
  virtual protected task drive_transfer27 (gpio_transfer27 trans27);
    if (trans27.transmit_delay27 > 0) begin
      repeat(trans27.transmit_delay27) @(posedge gpio_if27.pclk27);
    end
    drive_data27(trans27);
  endtask : drive_transfer27

  virtual protected task drive_data27 (gpio_transfer27 trans27);
    @gpio_if27.pclk27;
    for (int i = 0; i < `GPIO_DATA_WIDTH27; i++) begin
      if (gpio_if27.n_gpio_pin_oe27[i] == 0) begin
        trans27.transfer_data27[i] = gpio_if27.gpio_pin_out27[i];
        gpio_if27.gpio_pin_in27[i] = gpio_if27.gpio_pin_out27[i];
      end else
        gpio_if27.gpio_pin_in27[i] = trans27.transfer_data27[i];
    end
    `uvm_info("GPIO_DRIVER27", $psprintf("GPIO27 Transfer27:\n%s", trans27.sprint()), UVM_MEDIUM)
  endtask : drive_data27

endclass : gpio_driver27

`endif // GPIO_DRIVER_SV27

