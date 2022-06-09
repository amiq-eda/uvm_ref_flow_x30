/*-------------------------------------------------------------------------
File6 name   : gpio_driver6.sv
Title6       : GPIO6 SystemVerilog6 UVM OVC6
Project6     : SystemVerilog6 UVM Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV6
`define GPIO_DRIVER_SV6

class gpio_driver6 extends uvm_driver #(gpio_transfer6);

  // The virtual interface used to drive6 and view6 HDL signals6.
  virtual gpio_if6 gpio_if6;

  // Provide6 implmentations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils(gpio_driver6)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if6)::get(this, "", "gpio_if6", gpio_if6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".gpio_if6"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive6();
      reset_signals6();
    join
  endtask : run_phase

  // get_and_drive6 
  virtual protected task get_and_drive6();
    uvm_sequence_item item;
    gpio_transfer6 this_trans6;
    @(posedge gpio_if6.n_p_reset6);
    forever begin
      @(posedge gpio_if6.pclk6);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans6, req))
        `uvm_fatal("CASTFL6", "Failed6 to cast req to this_trans6 in get_and_drive6")
      drive_transfer6(this_trans6);
      seq_item_port.item_done();
    end
  endtask : get_and_drive6

  // reset_signals6
  virtual protected task reset_signals6();
      @(negedge gpio_if6.n_p_reset6);
      gpio_if6.gpio_pin_in6  <= 'b0;
  endtask : reset_signals6

  // drive_transfer6
  virtual protected task drive_transfer6 (gpio_transfer6 trans6);
    if (trans6.transmit_delay6 > 0) begin
      repeat(trans6.transmit_delay6) @(posedge gpio_if6.pclk6);
    end
    drive_data6(trans6);
  endtask : drive_transfer6

  virtual protected task drive_data6 (gpio_transfer6 trans6);
    @gpio_if6.pclk6;
    for (int i = 0; i < `GPIO_DATA_WIDTH6; i++) begin
      if (gpio_if6.n_gpio_pin_oe6[i] == 0) begin
        trans6.transfer_data6[i] = gpio_if6.gpio_pin_out6[i];
        gpio_if6.gpio_pin_in6[i] = gpio_if6.gpio_pin_out6[i];
      end else
        gpio_if6.gpio_pin_in6[i] = trans6.transfer_data6[i];
    end
    `uvm_info("GPIO_DRIVER6", $psprintf("GPIO6 Transfer6:\n%s", trans6.sprint()), UVM_MEDIUM)
  endtask : drive_data6

endclass : gpio_driver6

`endif // GPIO_DRIVER_SV6

