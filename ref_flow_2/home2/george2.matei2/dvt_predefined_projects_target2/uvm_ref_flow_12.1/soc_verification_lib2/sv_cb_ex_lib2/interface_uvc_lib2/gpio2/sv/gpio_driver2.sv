/*-------------------------------------------------------------------------
File2 name   : gpio_driver2.sv
Title2       : GPIO2 SystemVerilog2 UVM OVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef GPIO_DRIVER_SV2
`define GPIO_DRIVER_SV2

class gpio_driver2 extends uvm_driver #(gpio_transfer2);

  // The virtual interface used to drive2 and view2 HDL signals2.
  virtual gpio_if2 gpio_if2;

  // Provide2 implmentations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils(gpio_driver2)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

//UVM connect_phase
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual gpio_if2)::get(this, "", "gpio_if2", gpio_if2))
   `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".gpio_if2"})
endfunction : connect_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive2();
      reset_signals2();
    join
  endtask : run_phase

  // get_and_drive2 
  virtual protected task get_and_drive2();
    uvm_sequence_item item;
    gpio_transfer2 this_trans2;
    @(posedge gpio_if2.n_p_reset2);
    forever begin
      @(posedge gpio_if2.pclk2);
      seq_item_port.get_next_item(req);
      if (!$cast(this_trans2, req))
        `uvm_fatal("CASTFL2", "Failed2 to cast req to this_trans2 in get_and_drive2")
      drive_transfer2(this_trans2);
      seq_item_port.item_done();
    end
  endtask : get_and_drive2

  // reset_signals2
  virtual protected task reset_signals2();
      @(negedge gpio_if2.n_p_reset2);
      gpio_if2.gpio_pin_in2  <= 'b0;
  endtask : reset_signals2

  // drive_transfer2
  virtual protected task drive_transfer2 (gpio_transfer2 trans2);
    if (trans2.transmit_delay2 > 0) begin
      repeat(trans2.transmit_delay2) @(posedge gpio_if2.pclk2);
    end
    drive_data2(trans2);
  endtask : drive_transfer2

  virtual protected task drive_data2 (gpio_transfer2 trans2);
    @gpio_if2.pclk2;
    for (int i = 0; i < `GPIO_DATA_WIDTH2; i++) begin
      if (gpio_if2.n_gpio_pin_oe2[i] == 0) begin
        trans2.transfer_data2[i] = gpio_if2.gpio_pin_out2[i];
        gpio_if2.gpio_pin_in2[i] = gpio_if2.gpio_pin_out2[i];
      end else
        gpio_if2.gpio_pin_in2[i] = trans2.transfer_data2[i];
    end
    `uvm_info("GPIO_DRIVER2", $psprintf("GPIO2 Transfer2:\n%s", trans2.sprint()), UVM_MEDIUM)
  endtask : drive_data2

endclass : gpio_driver2

`endif // GPIO_DRIVER_SV2

