/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_config21.svh
Title21       : APB21 Subsystem21 configuration
Project21     :
Created21     :
Description21 : This21 file contains21 multiple configuration classes21:
                apb_config21
                   master_config21
                   slave_configs21[N]
                uart_config21
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV21
`define APB_SUBSYSTEM_CTRL_CONFIG_SV21

// APB21 Subsystem21 Configuration21 Class21
class apb_subsystem_config21 extends uvm_object;

  uart_ctrl_config21 uart_cfg021;
  uart_ctrl_config21 uart_cfg121;
  spi_pkg21::spi_config21 spi_cfg21;  //Sharon21 - ok to use as is, as a shortcut21 - document21 this
  gpio_pkg21::gpio_config21 gpio_cfg21;

  `uvm_object_utils_begin(apb_subsystem_config21)
      `uvm_field_object(uart_cfg021, UVM_DEFAULT)
      `uvm_field_object(uart_cfg121, UVM_DEFAULT)
      `uvm_field_object(spi_cfg21, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg21, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config21");
    super.new(name);
    uart_cfg021 = uart_ctrl_config21::type_id::create("uart_cfg021");
    uart_cfg121 = uart_ctrl_config21::type_id::create("uart_cfg121");
    spi_cfg21   = spi_pkg21::spi_config21::type_id::create("spi_cfg21"); 
    gpio_cfg21  = gpio_pkg21::gpio_config21::type_id::create("gpio_cfg21"); 
  endfunction : new

endclass : apb_subsystem_config21

//================================================================
class default_apb_subsystem_config21 extends apb_subsystem_config21;

  `uvm_object_utils(default_apb_subsystem_config21)

  function new(string name = "default_apb_subsystem_config21");
    super.new(name);
    uart_cfg021 = uart_ctrl_config21::type_id::create("uart_cfg021");
    uart_cfg121 = uart_ctrl_config21::type_id::create("uart_cfg121");
    spi_cfg21   = spi_pkg21::spi_config21::type_id::create("spi_cfg21"); 
    gpio_cfg21  = gpio_pkg21::gpio_config21::type_id::create("gpio_cfg21"); 
    uart_cfg021.apb_cfg21.add_master21("master21", UVM_PASSIVE);
    uart_cfg021.apb_cfg21.add_slave21("spi021",  `AM_SPI0_BASE_ADDRESS21,  `AM_SPI0_END_ADDRESS21,  0, UVM_PASSIVE);
    uart_cfg021.apb_cfg21.add_slave21("uart021", `AM_UART0_BASE_ADDRESS21, `AM_UART0_END_ADDRESS21, 0, UVM_PASSIVE);
    uart_cfg021.apb_cfg21.add_slave21("gpio021", `AM_GPIO0_BASE_ADDRESS21, `AM_GPIO0_END_ADDRESS21, 0, UVM_PASSIVE);
    uart_cfg021.apb_cfg21.add_slave21("uart121", `AM_UART1_BASE_ADDRESS21, `AM_UART1_END_ADDRESS21, 1, UVM_PASSIVE);
    uart_cfg121.apb_cfg21.add_master21("master21", UVM_PASSIVE);
    uart_cfg121.apb_cfg21.add_slave21("spi021",  `AM_SPI0_BASE_ADDRESS21,  `AM_SPI0_END_ADDRESS21,  0, UVM_PASSIVE);
    uart_cfg121.apb_cfg21.add_slave21("uart021", `AM_UART0_BASE_ADDRESS21, `AM_UART0_END_ADDRESS21, 0, UVM_PASSIVE);
    uart_cfg121.apb_cfg21.add_slave21("gpio021", `AM_GPIO0_BASE_ADDRESS21, `AM_GPIO0_END_ADDRESS21, 0, UVM_PASSIVE);
    uart_cfg121.apb_cfg21.add_slave21("uart121", `AM_UART1_BASE_ADDRESS21, `AM_UART1_END_ADDRESS21, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config21

`endif // UART_CTRL_CONFIG_SV21

