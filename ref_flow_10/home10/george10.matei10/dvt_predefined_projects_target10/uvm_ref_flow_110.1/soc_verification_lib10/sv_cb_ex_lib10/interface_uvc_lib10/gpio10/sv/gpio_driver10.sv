/*-------------------------------------------------------------------------
File10 name   : gpio_driver10.sv
Title10       : GPIO10 SystemVerilog10 UVM OVC10
Project10     : SystemVerilog10 UVM Cluster10 Level10 Verification10
Created10     :
Description10 : 
Notes10       :  
---------------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV10
`define GPIO_DRIVER_SV10

class gpio_driver10 extends uvm_driver #(gpio_transfer10);

  // The virtual interface used to drive10 and view10 HDL signals10.
  virtual gpio_if10 gpio_if10;

  // Provide10 implmentations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils(gpio_driver10)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if10)::get(this, "", "gpio_if10", gpio_if10))
   `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".gpio_if10"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive10();
      reset_signals10();
    join
  endtask : run_phase

  // get_and_drive10 
  virtual protected task get_and_drive10();
    uvm_sequence_item item;
    gpio_transfer10 this_trans10;
    @(posedge gpio_if10.n_p_reset10);
    forever begin
      @(posedge gpio_if10.pclk10);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans10, req))
        `uvm_fatal("CASTFL10", "Failed10 to cast req to this_trans10 in get_and_drive10")
      drive_transfer10(this_trans10);
      seq_item_port.item_done();
    end
  endtask : get_and_drive10

  // reset_signals10
  virtual protected task reset_signals10();
      @(negedge gpio_if10.n_p_reset10);
      gpio_if10.gpio_pin_in10  <= 'b0;
  endtask : reset_signals10

  // drive_transfer10
  virtual protected task drive_transfer10 (gpio_transfer10 trans10);
    if (trans10.transmit_delay10 > 0) begin
      repeat(trans10.transmit_delay10) @(posedge gpio_if10.pclk10);
    end
    drive_data10(trans10);
  endtask : drive_transfer10

  virtual protected task drive_data10 (gpio_transfer10 trans10);
    @gpio_if10.pclk10;
    for (int i = 0; i < `GPIO_DATA_WIDTH10; i++) begin
      if (gpio_if10.n_gpio_pin_oe10[i] == 0) begin
        trans10.transfer_data10[i] = gpio_if10.gpio_pin_out10[i];
        gpio_if10.gpio_pin_in10[i] = gpio_if10.gpio_pin_out10[i];
      end else
        gpio_if10.gpio_pin_in10[i] = trans10.transfer_data10[i];
    end
    `uvm_info("GPIO_DRIVER10", $psprintf("GPIO10 Transfer10:\n%s", trans10.sprint()), UVM_MEDIUM)
  endtask : drive_data10

endclass : gpio_driver10

`endif // GPIO_DRIVER_SV10

