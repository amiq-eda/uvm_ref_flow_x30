/*-------------------------------------------------------------------------
File19 name   : gpio_driver19.sv
Title19       : GPIO19 SystemVerilog19 UVM OVC19
Project19     : SystemVerilog19 UVM Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV19
`define GPIO_DRIVER_SV19

class gpio_driver19 extends uvm_driver #(gpio_transfer19);

  // The virtual interface used to drive19 and view19 HDL signals19.
  virtual gpio_if19 gpio_if19;

  // Provide19 implmentations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils(gpio_driver19)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if19)::get(this, "", "gpio_if19", gpio_if19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".gpio_if19"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive19();
      reset_signals19();
    join
  endtask : run_phase

  // get_and_drive19 
  virtual protected task get_and_drive19();
    uvm_sequence_item item;
    gpio_transfer19 this_trans19;
    @(posedge gpio_if19.n_p_reset19);
    forever begin
      @(posedge gpio_if19.pclk19);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans19, req))
        `uvm_fatal("CASTFL19", "Failed19 to cast req to this_trans19 in get_and_drive19")
      drive_transfer19(this_trans19);
      seq_item_port.item_done();
    end
  endtask : get_and_drive19

  // reset_signals19
  virtual protected task reset_signals19();
      @(negedge gpio_if19.n_p_reset19);
      gpio_if19.gpio_pin_in19  <= 'b0;
  endtask : reset_signals19

  // drive_transfer19
  virtual protected task drive_transfer19 (gpio_transfer19 trans19);
    if (trans19.transmit_delay19 > 0) begin
      repeat(trans19.transmit_delay19) @(posedge gpio_if19.pclk19);
    end
    drive_data19(trans19);
  endtask : drive_transfer19

  virtual protected task drive_data19 (gpio_transfer19 trans19);
    @gpio_if19.pclk19;
    for (int i = 0; i < `GPIO_DATA_WIDTH19; i++) begin
      if (gpio_if19.n_gpio_pin_oe19[i] == 0) begin
        trans19.transfer_data19[i] = gpio_if19.gpio_pin_out19[i];
        gpio_if19.gpio_pin_in19[i] = gpio_if19.gpio_pin_out19[i];
      end else
        gpio_if19.gpio_pin_in19[i] = trans19.transfer_data19[i];
    end
    `uvm_info("GPIO_DRIVER19", $psprintf("GPIO19 Transfer19:\n%s", trans19.sprint()), UVM_MEDIUM)
  endtask : drive_data19

endclass : gpio_driver19

`endif // GPIO_DRIVER_SV19

