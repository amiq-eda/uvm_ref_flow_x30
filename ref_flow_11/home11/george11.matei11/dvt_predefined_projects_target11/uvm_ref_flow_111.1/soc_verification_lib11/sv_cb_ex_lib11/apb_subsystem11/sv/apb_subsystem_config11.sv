/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_config11.svh
Title11       : APB11 Subsystem11 configuration
Project11     :
Created11     :
Description11 : This11 file contains11 multiple configuration classes11:
                apb_config11
                   master_config11
                   slave_configs11[N]
                uart_config11
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV11
`define APB_SUBSYSTEM_CTRL_CONFIG_SV11

// APB11 Subsystem11 Configuration11 Class11
class apb_subsystem_config11 extends uvm_object;

  uart_ctrl_config11 uart_cfg011;
  uart_ctrl_config11 uart_cfg111;
  spi_pkg11::spi_config11 spi_cfg11;  //Sharon11 - ok to use as is, as a shortcut11 - document11 this
  gpio_pkg11::gpio_config11 gpio_cfg11;

  `uvm_object_utils_begin(apb_subsystem_config11)
      `uvm_field_object(uart_cfg011, UVM_DEFAULT)
      `uvm_field_object(uart_cfg111, UVM_DEFAULT)
      `uvm_field_object(spi_cfg11, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg11, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config11");
    super.new(name);
    uart_cfg011 = uart_ctrl_config11::type_id::create("uart_cfg011");
    uart_cfg111 = uart_ctrl_config11::type_id::create("uart_cfg111");
    spi_cfg11   = spi_pkg11::spi_config11::type_id::create("spi_cfg11"); 
    gpio_cfg11  = gpio_pkg11::gpio_config11::type_id::create("gpio_cfg11"); 
  endfunction : new

endclass : apb_subsystem_config11

//================================================================
class default_apb_subsystem_config11 extends apb_subsystem_config11;

  `uvm_object_utils(default_apb_subsystem_config11)

  function new(string name = "default_apb_subsystem_config11");
    super.new(name);
    uart_cfg011 = uart_ctrl_config11::type_id::create("uart_cfg011");
    uart_cfg111 = uart_ctrl_config11::type_id::create("uart_cfg111");
    spi_cfg11   = spi_pkg11::spi_config11::type_id::create("spi_cfg11"); 
    gpio_cfg11  = gpio_pkg11::gpio_config11::type_id::create("gpio_cfg11"); 
    uart_cfg011.apb_cfg11.add_master11("master11", UVM_PASSIVE);
    uart_cfg011.apb_cfg11.add_slave11("spi011",  `AM_SPI0_BASE_ADDRESS11,  `AM_SPI0_END_ADDRESS11,  0, UVM_PASSIVE);
    uart_cfg011.apb_cfg11.add_slave11("uart011", `AM_UART0_BASE_ADDRESS11, `AM_UART0_END_ADDRESS11, 0, UVM_PASSIVE);
    uart_cfg011.apb_cfg11.add_slave11("gpio011", `AM_GPIO0_BASE_ADDRESS11, `AM_GPIO0_END_ADDRESS11, 0, UVM_PASSIVE);
    uart_cfg011.apb_cfg11.add_slave11("uart111", `AM_UART1_BASE_ADDRESS11, `AM_UART1_END_ADDRESS11, 1, UVM_PASSIVE);
    uart_cfg111.apb_cfg11.add_master11("master11", UVM_PASSIVE);
    uart_cfg111.apb_cfg11.add_slave11("spi011",  `AM_SPI0_BASE_ADDRESS11,  `AM_SPI0_END_ADDRESS11,  0, UVM_PASSIVE);
    uart_cfg111.apb_cfg11.add_slave11("uart011", `AM_UART0_BASE_ADDRESS11, `AM_UART0_END_ADDRESS11, 0, UVM_PASSIVE);
    uart_cfg111.apb_cfg11.add_slave11("gpio011", `AM_GPIO0_BASE_ADDRESS11, `AM_GPIO0_END_ADDRESS11, 0, UVM_PASSIVE);
    uart_cfg111.apb_cfg11.add_slave11("uart111", `AM_UART1_BASE_ADDRESS11, `AM_UART1_END_ADDRESS11, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config11

`endif // UART_CTRL_CONFIG_SV11

