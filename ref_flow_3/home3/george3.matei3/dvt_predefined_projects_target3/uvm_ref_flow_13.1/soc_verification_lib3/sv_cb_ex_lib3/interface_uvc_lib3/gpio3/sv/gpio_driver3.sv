/*-------------------------------------------------------------------------
File3 name   : gpio_driver3.sv
Title3       : GPIO3 SystemVerilog3 UVM OVC3
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


`ifndef GPIO_DRIVER_SV3
`define GPIO_DRIVER_SV3

class gpio_driver3 extends uvm_driver #(gpio_transfer3);

  // The virtual interface used to drive3 and view3 HDL signals3.
  virtual gpio_if3 gpio_if3;

  // Provide3 implmentations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils(gpio_driver3)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if3)::get(this, "", "gpio_if3", gpio_if3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".gpio_if3"})
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
    gpio_transfer3 this_trans3;
    @(posedge gpio_if3.n_p_reset3);
    forever begin
      @(posedge gpio_if3.pclk3);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans3, req))
        `uvm_fatal("CASTFL3", "Failed3 to cast req to this_trans3 in get_and_drive3")
      drive_transfer3(this_trans3);
      seq_item_port.item_done();
    end
  endtask : get_and_drive3

  // reset_signals3
  virtual protected task reset_signals3();
      @(negedge gpio_if3.n_p_reset3);
      gpio_if3.gpio_pin_in3  <= 'b0;
  endtask : reset_signals3

  // drive_transfer3
  virtual protected task drive_transfer3 (gpio_transfer3 trans3);
    if (trans3.transmit_delay3 > 0) begin
      repeat(trans3.transmit_delay3) @(posedge gpio_if3.pclk3);
    end
    drive_data3(trans3);
  endtask : drive_transfer3

  virtual protected task drive_data3 (gpio_transfer3 trans3);
    @gpio_if3.pclk3;
    for (int i = 0; i < `GPIO_DATA_WIDTH3; i++) begin
      if (gpio_if3.n_gpio_pin_oe3[i] == 0) begin
        trans3.transfer_data3[i] = gpio_if3.gpio_pin_out3[i];
        gpio_if3.gpio_pin_in3[i] = gpio_if3.gpio_pin_out3[i];
      end else
        gpio_if3.gpio_pin_in3[i] = trans3.transfer_data3[i];
    end
    `uvm_info("GPIO_DRIVER3", $psprintf("GPIO3 Transfer3:\n%s", trans3.sprint()), UVM_MEDIUM)
  endtask : drive_data3

endclass : gpio_driver3

`endif // GPIO_DRIVER_SV3

