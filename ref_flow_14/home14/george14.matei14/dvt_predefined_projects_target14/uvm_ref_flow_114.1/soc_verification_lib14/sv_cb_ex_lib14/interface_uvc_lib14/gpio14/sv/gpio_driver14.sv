/*-------------------------------------------------------------------------
File14 name   : gpio_driver14.sv
Title14       : GPIO14 SystemVerilog14 UVM OVC14
Project14     : SystemVerilog14 UVM Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV14
`define GPIO_DRIVER_SV14

class gpio_driver14 extends uvm_driver #(gpio_transfer14);

  // The virtual interface used to drive14 and view14 HDL signals14.
  virtual gpio_if14 gpio_if14;

  // Provide14 implmentations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils(gpio_driver14)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if14)::get(this, "", "gpio_if14", gpio_if14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".gpio_if14"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive14();
      reset_signals14();
    join
  endtask : run_phase

  // get_and_drive14 
  virtual protected task get_and_drive14();
    uvm_sequence_item item;
    gpio_transfer14 this_trans14;
    @(posedge gpio_if14.n_p_reset14);
    forever begin
      @(posedge gpio_if14.pclk14);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans14, req))
        `uvm_fatal("CASTFL14", "Failed14 to cast req to this_trans14 in get_and_drive14")
      drive_transfer14(this_trans14);
      seq_item_port.item_done();
    end
  endtask : get_and_drive14

  // reset_signals14
  virtual protected task reset_signals14();
      @(negedge gpio_if14.n_p_reset14);
      gpio_if14.gpio_pin_in14  <= 'b0;
  endtask : reset_signals14

  // drive_transfer14
  virtual protected task drive_transfer14 (gpio_transfer14 trans14);
    if (trans14.transmit_delay14 > 0) begin
      repeat(trans14.transmit_delay14) @(posedge gpio_if14.pclk14);
    end
    drive_data14(trans14);
  endtask : drive_transfer14

  virtual protected task drive_data14 (gpio_transfer14 trans14);
    @gpio_if14.pclk14;
    for (int i = 0; i < `GPIO_DATA_WIDTH14; i++) begin
      if (gpio_if14.n_gpio_pin_oe14[i] == 0) begin
        trans14.transfer_data14[i] = gpio_if14.gpio_pin_out14[i];
        gpio_if14.gpio_pin_in14[i] = gpio_if14.gpio_pin_out14[i];
      end else
        gpio_if14.gpio_pin_in14[i] = trans14.transfer_data14[i];
    end
    `uvm_info("GPIO_DRIVER14", $psprintf("GPIO14 Transfer14:\n%s", trans14.sprint()), UVM_MEDIUM)
  endtask : drive_data14

endclass : gpio_driver14

`endif // GPIO_DRIVER_SV14

