/*-------------------------------------------------------------------------
File9 name   : gpio_driver9.sv
Title9       : GPIO9 SystemVerilog9 UVM OVC9
Project9     : SystemVerilog9 UVM Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV9
`define GPIO_DRIVER_SV9

class gpio_driver9 extends uvm_driver #(gpio_transfer9);

  // The virtual interface used to drive9 and view9 HDL signals9.
  virtual gpio_if9 gpio_if9;

  // Provide9 implmentations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils(gpio_driver9)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if9)::get(this, "", "gpio_if9", gpio_if9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".gpio_if9"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive9();
      reset_signals9();
    join
  endtask : run_phase

  // get_and_drive9 
  virtual protected task get_and_drive9();
    uvm_sequence_item item;
    gpio_transfer9 this_trans9;
    @(posedge gpio_if9.n_p_reset9);
    forever begin
      @(posedge gpio_if9.pclk9);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans9, req))
        `uvm_fatal("CASTFL9", "Failed9 to cast req to this_trans9 in get_and_drive9")
      drive_transfer9(this_trans9);
      seq_item_port.item_done();
    end
  endtask : get_and_drive9

  // reset_signals9
  virtual protected task reset_signals9();
      @(negedge gpio_if9.n_p_reset9);
      gpio_if9.gpio_pin_in9  <= 'b0;
  endtask : reset_signals9

  // drive_transfer9
  virtual protected task drive_transfer9 (gpio_transfer9 trans9);
    if (trans9.transmit_delay9 > 0) begin
      repeat(trans9.transmit_delay9) @(posedge gpio_if9.pclk9);
    end
    drive_data9(trans9);
  endtask : drive_transfer9

  virtual protected task drive_data9 (gpio_transfer9 trans9);
    @gpio_if9.pclk9;
    for (int i = 0; i < `GPIO_DATA_WIDTH9; i++) begin
      if (gpio_if9.n_gpio_pin_oe9[i] == 0) begin
        trans9.transfer_data9[i] = gpio_if9.gpio_pin_out9[i];
        gpio_if9.gpio_pin_in9[i] = gpio_if9.gpio_pin_out9[i];
      end else
        gpio_if9.gpio_pin_in9[i] = trans9.transfer_data9[i];
    end
    `uvm_info("GPIO_DRIVER9", $psprintf("GPIO9 Transfer9:\n%s", trans9.sprint()), UVM_MEDIUM)
  endtask : drive_data9

endclass : gpio_driver9

`endif // GPIO_DRIVER_SV9

