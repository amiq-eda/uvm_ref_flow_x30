/*-------------------------------------------------------------------------
File5 name   : gpio_driver5.sv
Title5       : GPIO5 SystemVerilog5 UVM OVC5
Project5     : SystemVerilog5 UVM Cluster5 Level5 Verification5
Created5     :
Description5 : 
Notes5       :  
---------------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV5
`define GPIO_DRIVER_SV5

class gpio_driver5 extends uvm_driver #(gpio_transfer5);

  // The virtual interface used to drive5 and view5 HDL signals5.
  virtual gpio_if5 gpio_if5;

  // Provide5 implmentations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils(gpio_driver5)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if5)::get(this, "", "gpio_if5", gpio_if5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".gpio_if5"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive5();
      reset_signals5();
    join
  endtask : run_phase

  // get_and_drive5 
  virtual protected task get_and_drive5();
    uvm_sequence_item item;
    gpio_transfer5 this_trans5;
    @(posedge gpio_if5.n_p_reset5);
    forever begin
      @(posedge gpio_if5.pclk5);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans5, req))
        `uvm_fatal("CASTFL5", "Failed5 to cast req to this_trans5 in get_and_drive5")
      drive_transfer5(this_trans5);
      seq_item_port.item_done();
    end
  endtask : get_and_drive5

  // reset_signals5
  virtual protected task reset_signals5();
      @(negedge gpio_if5.n_p_reset5);
      gpio_if5.gpio_pin_in5  <= 'b0;
  endtask : reset_signals5

  // drive_transfer5
  virtual protected task drive_transfer5 (gpio_transfer5 trans5);
    if (trans5.transmit_delay5 > 0) begin
      repeat(trans5.transmit_delay5) @(posedge gpio_if5.pclk5);
    end
    drive_data5(trans5);
  endtask : drive_transfer5

  virtual protected task drive_data5 (gpio_transfer5 trans5);
    @gpio_if5.pclk5;
    for (int i = 0; i < `GPIO_DATA_WIDTH5; i++) begin
      if (gpio_if5.n_gpio_pin_oe5[i] == 0) begin
        trans5.transfer_data5[i] = gpio_if5.gpio_pin_out5[i];
        gpio_if5.gpio_pin_in5[i] = gpio_if5.gpio_pin_out5[i];
      end else
        gpio_if5.gpio_pin_in5[i] = trans5.transfer_data5[i];
    end
    `uvm_info("GPIO_DRIVER5", $psprintf("GPIO5 Transfer5:\n%s", trans5.sprint()), UVM_MEDIUM)
  endtask : drive_data5

endclass : gpio_driver5

`endif // GPIO_DRIVER_SV5

