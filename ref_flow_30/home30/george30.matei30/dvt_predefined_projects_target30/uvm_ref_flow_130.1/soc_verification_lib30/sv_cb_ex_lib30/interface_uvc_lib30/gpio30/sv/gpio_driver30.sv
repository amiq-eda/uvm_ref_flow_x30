/*-------------------------------------------------------------------------
File30 name   : gpio_driver30.sv
Title30       : GPIO30 SystemVerilog30 UVM OVC30
Project30     : SystemVerilog30 UVM Cluster30 Level30 Verification30
Created30     :
Description30 : 
Notes30       :  
---------------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV30
`define GPIO_DRIVER_SV30

class gpio_driver30 extends uvm_driver #(gpio_transfer30);

  // The virtual interface used to drive30 and view30 HDL signals30.
  virtual gpio_if30 gpio_if30;

  // Provide30 implmentations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils(gpio_driver30)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if30)::get(this, "", "gpio_if30", gpio_if30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".gpio_if30"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive30();
      reset_signals30();
    join
  endtask : run_phase

  // get_and_drive30 
  virtual protected task get_and_drive30();
    uvm_sequence_item item;
    gpio_transfer30 this_trans30;
    @(posedge gpio_if30.n_p_reset30);
    forever begin
      @(posedge gpio_if30.pclk30);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans30, req))
        `uvm_fatal("CASTFL30", "Failed30 to cast req to this_trans30 in get_and_drive30")
      drive_transfer30(this_trans30);
      seq_item_port.item_done();
    end
  endtask : get_and_drive30

  // reset_signals30
  virtual protected task reset_signals30();
      @(negedge gpio_if30.n_p_reset30);
      gpio_if30.gpio_pin_in30  <= 'b0;
  endtask : reset_signals30

  // drive_transfer30
  virtual protected task drive_transfer30 (gpio_transfer30 trans30);
    if (trans30.transmit_delay30 > 0) begin
      repeat(trans30.transmit_delay30) @(posedge gpio_if30.pclk30);
    end
    drive_data30(trans30);
  endtask : drive_transfer30

  virtual protected task drive_data30 (gpio_transfer30 trans30);
    @gpio_if30.pclk30;
    for (int i = 0; i < `GPIO_DATA_WIDTH30; i++) begin
      if (gpio_if30.n_gpio_pin_oe30[i] == 0) begin
        trans30.transfer_data30[i] = gpio_if30.gpio_pin_out30[i];
        gpio_if30.gpio_pin_in30[i] = gpio_if30.gpio_pin_out30[i];
      end else
        gpio_if30.gpio_pin_in30[i] = trans30.transfer_data30[i];
    end
    `uvm_info("GPIO_DRIVER30", $psprintf("GPIO30 Transfer30:\n%s", trans30.sprint()), UVM_MEDIUM)
  endtask : drive_data30

endclass : gpio_driver30

`endif // GPIO_DRIVER_SV30

