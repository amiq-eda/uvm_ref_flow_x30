/*-------------------------------------------------------------------------
File8 name   : gpio_driver8.sv
Title8       : GPIO8 SystemVerilog8 UVM OVC8
Project8     : SystemVerilog8 UVM Cluster8 Level8 Verification8
Created8     :
Description8 : 
Notes8       :  
---------------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV8
`define GPIO_DRIVER_SV8

class gpio_driver8 extends uvm_driver #(gpio_transfer8);

  // The virtual interface used to drive8 and view8 HDL signals8.
  virtual gpio_if8 gpio_if8;

  // Provide8 implmentations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils(gpio_driver8)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if8)::get(this, "", "gpio_if8", gpio_if8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".gpio_if8"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive8();
      reset_signals8();
    join
  endtask : run_phase

  // get_and_drive8 
  virtual protected task get_and_drive8();
    uvm_sequence_item item;
    gpio_transfer8 this_trans8;
    @(posedge gpio_if8.n_p_reset8);
    forever begin
      @(posedge gpio_if8.pclk8);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans8, req))
        `uvm_fatal("CASTFL8", "Failed8 to cast req to this_trans8 in get_and_drive8")
      drive_transfer8(this_trans8);
      seq_item_port.item_done();
    end
  endtask : get_and_drive8

  // reset_signals8
  virtual protected task reset_signals8();
      @(negedge gpio_if8.n_p_reset8);
      gpio_if8.gpio_pin_in8  <= 'b0;
  endtask : reset_signals8

  // drive_transfer8
  virtual protected task drive_transfer8 (gpio_transfer8 trans8);
    if (trans8.transmit_delay8 > 0) begin
      repeat(trans8.transmit_delay8) @(posedge gpio_if8.pclk8);
    end
    drive_data8(trans8);
  endtask : drive_transfer8

  virtual protected task drive_data8 (gpio_transfer8 trans8);
    @gpio_if8.pclk8;
    for (int i = 0; i < `GPIO_DATA_WIDTH8; i++) begin
      if (gpio_if8.n_gpio_pin_oe8[i] == 0) begin
        trans8.transfer_data8[i] = gpio_if8.gpio_pin_out8[i];
        gpio_if8.gpio_pin_in8[i] = gpio_if8.gpio_pin_out8[i];
      end else
        gpio_if8.gpio_pin_in8[i] = trans8.transfer_data8[i];
    end
    `uvm_info("GPIO_DRIVER8", $psprintf("GPIO8 Transfer8:\n%s", trans8.sprint()), UVM_MEDIUM)
  endtask : drive_data8

endclass : gpio_driver8

`endif // GPIO_DRIVER_SV8

