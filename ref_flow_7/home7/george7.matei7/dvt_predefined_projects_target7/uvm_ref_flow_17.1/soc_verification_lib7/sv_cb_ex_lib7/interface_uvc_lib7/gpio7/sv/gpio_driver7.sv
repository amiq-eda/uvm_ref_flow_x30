/*-------------------------------------------------------------------------
File7 name   : gpio_driver7.sv
Title7       : GPIO7 SystemVerilog7 UVM OVC7
Project7     : SystemVerilog7 UVM Cluster7 Level7 Verification7
Created7     :
Description7 : 
Notes7       :  
---------------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV7
`define GPIO_DRIVER_SV7

class gpio_driver7 extends uvm_driver #(gpio_transfer7);

  // The virtual interface used to drive7 and view7 HDL signals7.
  virtual gpio_if7 gpio_if7;

  // Provide7 implmentations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils(gpio_driver7)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if7)::get(this, "", "gpio_if7", gpio_if7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".gpio_if7"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive7();
      reset_signals7();
    join
  endtask : run_phase

  // get_and_drive7 
  virtual protected task get_and_drive7();
    uvm_sequence_item item;
    gpio_transfer7 this_trans7;
    @(posedge gpio_if7.n_p_reset7);
    forever begin
      @(posedge gpio_if7.pclk7);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans7, req))
        `uvm_fatal("CASTFL7", "Failed7 to cast req to this_trans7 in get_and_drive7")
      drive_transfer7(this_trans7);
      seq_item_port.item_done();
    end
  endtask : get_and_drive7

  // reset_signals7
  virtual protected task reset_signals7();
      @(negedge gpio_if7.n_p_reset7);
      gpio_if7.gpio_pin_in7  <= 'b0;
  endtask : reset_signals7

  // drive_transfer7
  virtual protected task drive_transfer7 (gpio_transfer7 trans7);
    if (trans7.transmit_delay7 > 0) begin
      repeat(trans7.transmit_delay7) @(posedge gpio_if7.pclk7);
    end
    drive_data7(trans7);
  endtask : drive_transfer7

  virtual protected task drive_data7 (gpio_transfer7 trans7);
    @gpio_if7.pclk7;
    for (int i = 0; i < `GPIO_DATA_WIDTH7; i++) begin
      if (gpio_if7.n_gpio_pin_oe7[i] == 0) begin
        trans7.transfer_data7[i] = gpio_if7.gpio_pin_out7[i];
        gpio_if7.gpio_pin_in7[i] = gpio_if7.gpio_pin_out7[i];
      end else
        gpio_if7.gpio_pin_in7[i] = trans7.transfer_data7[i];
    end
    `uvm_info("GPIO_DRIVER7", $psprintf("GPIO7 Transfer7:\n%s", trans7.sprint()), UVM_MEDIUM)
  endtask : drive_data7

endclass : gpio_driver7

`endif // GPIO_DRIVER_SV7

