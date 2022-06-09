/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_config10.svh
Title10       : APB10 Subsystem10 configuration
Project10     :
Created10     :
Description10 : This10 file contains10 multiple configuration classes10:
                apb_config10
                   master_config10
                   slave_configs10[N]
                uart_config10
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV10
`define APB_SUBSYSTEM_CTRL_CONFIG_SV10

// APB10 Subsystem10 Configuration10 Class10
class apb_subsystem_config10 extends uvm_object;

  uart_ctrl_config10 uart_cfg010;
  uart_ctrl_config10 uart_cfg110;
  spi_pkg10::spi_config10 spi_cfg10;  //Sharon10 - ok to use as is, as a shortcut10 - document10 this
  gpio_pkg10::gpio_config10 gpio_cfg10;

  `uvm_object_utils_begin(apb_subsystem_config10)
      `uvm_field_object(uart_cfg010, UVM_DEFAULT)
      `uvm_field_object(uart_cfg110, UVM_DEFAULT)
      `uvm_field_object(spi_cfg10, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg10, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config10");
    super.new(name);
    uart_cfg010 = uart_ctrl_config10::type_id::create("uart_cfg010");
    uart_cfg110 = uart_ctrl_config10::type_id::create("uart_cfg110");
    spi_cfg10   = spi_pkg10::spi_config10::type_id::create("spi_cfg10"); 
    gpio_cfg10  = gpio_pkg10::gpio_config10::type_id::create("gpio_cfg10"); 
  endfunction : new

endclass : apb_subsystem_config10

//================================================================
class default_apb_subsystem_config10 extends apb_subsystem_config10;

  `uvm_object_utils(default_apb_subsystem_config10)

  function new(string name = "default_apb_subsystem_config10");
    super.new(name);
    uart_cfg010 = uart_ctrl_config10::type_id::create("uart_cfg010");
    uart_cfg110 = uart_ctrl_config10::type_id::create("uart_cfg110");
    spi_cfg10   = spi_pkg10::spi_config10::type_id::create("spi_cfg10"); 
    gpio_cfg10  = gpio_pkg10::gpio_config10::type_id::create("gpio_cfg10"); 
    uart_cfg010.apb_cfg10.add_master10("master10", UVM_PASSIVE);
    uart_cfg010.apb_cfg10.add_slave10("spi010",  `AM_SPI0_BASE_ADDRESS10,  `AM_SPI0_END_ADDRESS10,  0, UVM_PASSIVE);
    uart_cfg010.apb_cfg10.add_slave10("uart010", `AM_UART0_BASE_ADDRESS10, `AM_UART0_END_ADDRESS10, 0, UVM_PASSIVE);
    uart_cfg010.apb_cfg10.add_slave10("gpio010", `AM_GPIO0_BASE_ADDRESS10, `AM_GPIO0_END_ADDRESS10, 0, UVM_PASSIVE);
    uart_cfg010.apb_cfg10.add_slave10("uart110", `AM_UART1_BASE_ADDRESS10, `AM_UART1_END_ADDRESS10, 1, UVM_PASSIVE);
    uart_cfg110.apb_cfg10.add_master10("master10", UVM_PASSIVE);
    uart_cfg110.apb_cfg10.add_slave10("spi010",  `AM_SPI0_BASE_ADDRESS10,  `AM_SPI0_END_ADDRESS10,  0, UVM_PASSIVE);
    uart_cfg110.apb_cfg10.add_slave10("uart010", `AM_UART0_BASE_ADDRESS10, `AM_UART0_END_ADDRESS10, 0, UVM_PASSIVE);
    uart_cfg110.apb_cfg10.add_slave10("gpio010", `AM_GPIO0_BASE_ADDRESS10, `AM_GPIO0_END_ADDRESS10, 0, UVM_PASSIVE);
    uart_cfg110.apb_cfg10.add_slave10("uart110", `AM_UART1_BASE_ADDRESS10, `AM_UART1_END_ADDRESS10, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config10

`endif // UART_CTRL_CONFIG_SV10

