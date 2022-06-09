/*-------------------------------------------------------------------------
File18 name   : gpio_driver18.sv
Title18       : GPIO18 SystemVerilog18 UVM OVC18
Project18     : SystemVerilog18 UVM Cluster18 Level18 Verification18
Created18     :
Description18 : 
Notes18       :  
---------------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV18
`define GPIO_DRIVER_SV18

class gpio_driver18 extends uvm_driver #(gpio_transfer18);

  // The virtual interface used to drive18 and view18 HDL signals18.
  virtual gpio_if18 gpio_if18;

  // Provide18 implmentations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils(gpio_driver18)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if18)::get(this, "", "gpio_if18", gpio_if18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".gpio_if18"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive18();
      reset_signals18();
    join
  endtask : run_phase

  // get_and_drive18 
  virtual protected task get_and_drive18();
    uvm_sequence_item item;
    gpio_transfer18 this_trans18;
    @(posedge gpio_if18.n_p_reset18);
    forever begin
      @(posedge gpio_if18.pclk18);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans18, req))
        `uvm_fatal("CASTFL18", "Failed18 to cast req to this_trans18 in get_and_drive18")
      drive_transfer18(this_trans18);
      seq_item_port.item_done();
    end
  endtask : get_and_drive18

  // reset_signals18
  virtual protected task reset_signals18();
      @(negedge gpio_if18.n_p_reset18);
      gpio_if18.gpio_pin_in18  <= 'b0;
  endtask : reset_signals18

  // drive_transfer18
  virtual protected task drive_transfer18 (gpio_transfer18 trans18);
    if (trans18.transmit_delay18 > 0) begin
      repeat(trans18.transmit_delay18) @(posedge gpio_if18.pclk18);
    end
    drive_data18(trans18);
  endtask : drive_transfer18

  virtual protected task drive_data18 (gpio_transfer18 trans18);
    @gpio_if18.pclk18;
    for (int i = 0; i < `GPIO_DATA_WIDTH18; i++) begin
      if (gpio_if18.n_gpio_pin_oe18[i] == 0) begin
        trans18.transfer_data18[i] = gpio_if18.gpio_pin_out18[i];
        gpio_if18.gpio_pin_in18[i] = gpio_if18.gpio_pin_out18[i];
      end else
        gpio_if18.gpio_pin_in18[i] = trans18.transfer_data18[i];
    end
    `uvm_info("GPIO_DRIVER18", $psprintf("GPIO18 Transfer18:\n%s", trans18.sprint()), UVM_MEDIUM)
  endtask : drive_data18

endclass : gpio_driver18

`endif // GPIO_DRIVER_SV18

