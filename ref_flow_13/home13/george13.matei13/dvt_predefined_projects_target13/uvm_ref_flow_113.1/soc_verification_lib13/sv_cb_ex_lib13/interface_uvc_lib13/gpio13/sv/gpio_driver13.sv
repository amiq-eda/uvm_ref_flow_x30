/*-------------------------------------------------------------------------
File13 name   : gpio_driver13.sv
Title13       : GPIO13 SystemVerilog13 UVM OVC13
Project13     : SystemVerilog13 UVM Cluster13 Level13 Verification13
Created13     :
Description13 : 
Notes13       :  
---------------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV13
`define GPIO_DRIVER_SV13

class gpio_driver13 extends uvm_driver #(gpio_transfer13);

  // The virtual interface used to drive13 and view13 HDL signals13.
  virtual gpio_if13 gpio_if13;

  // Provide13 implmentations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils(gpio_driver13)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if13)::get(this, "", "gpio_if13", gpio_if13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".gpio_if13"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive13();
      reset_signals13();
    join
  endtask : run_phase

  // get_and_drive13 
  virtual protected task get_and_drive13();
    uvm_sequence_item item;
    gpio_transfer13 this_trans13;
    @(posedge gpio_if13.n_p_reset13);
    forever begin
      @(posedge gpio_if13.pclk13);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans13, req))
        `uvm_fatal("CASTFL13", "Failed13 to cast req to this_trans13 in get_and_drive13")
      drive_transfer13(this_trans13);
      seq_item_port.item_done();
    end
  endtask : get_and_drive13

  // reset_signals13
  virtual protected task reset_signals13();
      @(negedge gpio_if13.n_p_reset13);
      gpio_if13.gpio_pin_in13  <= 'b0;
  endtask : reset_signals13

  // drive_transfer13
  virtual protected task drive_transfer13 (gpio_transfer13 trans13);
    if (trans13.transmit_delay13 > 0) begin
      repeat(trans13.transmit_delay13) @(posedge gpio_if13.pclk13);
    end
    drive_data13(trans13);
  endtask : drive_transfer13

  virtual protected task drive_data13 (gpio_transfer13 trans13);
    @gpio_if13.pclk13;
    for (int i = 0; i < `GPIO_DATA_WIDTH13; i++) begin
      if (gpio_if13.n_gpio_pin_oe13[i] == 0) begin
        trans13.transfer_data13[i] = gpio_if13.gpio_pin_out13[i];
        gpio_if13.gpio_pin_in13[i] = gpio_if13.gpio_pin_out13[i];
      end else
        gpio_if13.gpio_pin_in13[i] = trans13.transfer_data13[i];
    end
    `uvm_info("GPIO_DRIVER13", $psprintf("GPIO13 Transfer13:\n%s", trans13.sprint()), UVM_MEDIUM)
  endtask : drive_data13

endclass : gpio_driver13

`endif // GPIO_DRIVER_SV13

