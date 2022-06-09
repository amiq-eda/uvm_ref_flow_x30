/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_config13.svh
Title13       : APB13 Subsystem13 configuration
Project13     :
Created13     :
Description13 : This13 file contains13 multiple configuration classes13:
                apb_config13
                   master_config13
                   slave_configs13[N]
                uart_config13
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV13
`define APB_SUBSYSTEM_CTRL_CONFIG_SV13

// APB13 Subsystem13 Configuration13 Class13
class apb_subsystem_config13 extends uvm_object;

  uart_ctrl_config13 uart_cfg013;
  uart_ctrl_config13 uart_cfg113;
  spi_pkg13::spi_config13 spi_cfg13;  //Sharon13 - ok to use as is, as a shortcut13 - document13 this
  gpio_pkg13::gpio_config13 gpio_cfg13;

  `uvm_object_utils_begin(apb_subsystem_config13)
      `uvm_field_object(uart_cfg013, UVM_DEFAULT)
      `uvm_field_object(uart_cfg113, UVM_DEFAULT)
      `uvm_field_object(spi_cfg13, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg13, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config13");
    super.new(name);
    uart_cfg013 = uart_ctrl_config13::type_id::create("uart_cfg013");
    uart_cfg113 = uart_ctrl_config13::type_id::create("uart_cfg113");
    spi_cfg13   = spi_pkg13::spi_config13::type_id::create("spi_cfg13"); 
    gpio_cfg13  = gpio_pkg13::gpio_config13::type_id::create("gpio_cfg13"); 
  endfunction : new

endclass : apb_subsystem_config13

//================================================================
class default_apb_subsystem_config13 extends apb_subsystem_config13;

  `uvm_object_utils(default_apb_subsystem_config13)

  function new(string name = "default_apb_subsystem_config13");
    super.new(name);
    uart_cfg013 = uart_ctrl_config13::type_id::create("uart_cfg013");
    uart_cfg113 = uart_ctrl_config13::type_id::create("uart_cfg113");
    spi_cfg13   = spi_pkg13::spi_config13::type_id::create("spi_cfg13"); 
    gpio_cfg13  = gpio_pkg13::gpio_config13::type_id::create("gpio_cfg13"); 
    uart_cfg013.apb_cfg13.add_master13("master13", UVM_PASSIVE);
    uart_cfg013.apb_cfg13.add_slave13("spi013",  `AM_SPI0_BASE_ADDRESS13,  `AM_SPI0_END_ADDRESS13,  0, UVM_PASSIVE);
    uart_cfg013.apb_cfg13.add_slave13("uart013", `AM_UART0_BASE_ADDRESS13, `AM_UART0_END_ADDRESS13, 0, UVM_PASSIVE);
    uart_cfg013.apb_cfg13.add_slave13("gpio013", `AM_GPIO0_BASE_ADDRESS13, `AM_GPIO0_END_ADDRESS13, 0, UVM_PASSIVE);
    uart_cfg013.apb_cfg13.add_slave13("uart113", `AM_UART1_BASE_ADDRESS13, `AM_UART1_END_ADDRESS13, 1, UVM_PASSIVE);
    uart_cfg113.apb_cfg13.add_master13("master13", UVM_PASSIVE);
    uart_cfg113.apb_cfg13.add_slave13("spi013",  `AM_SPI0_BASE_ADDRESS13,  `AM_SPI0_END_ADDRESS13,  0, UVM_PASSIVE);
    uart_cfg113.apb_cfg13.add_slave13("uart013", `AM_UART0_BASE_ADDRESS13, `AM_UART0_END_ADDRESS13, 0, UVM_PASSIVE);
    uart_cfg113.apb_cfg13.add_slave13("gpio013", `AM_GPIO0_BASE_ADDRESS13, `AM_GPIO0_END_ADDRESS13, 0, UVM_PASSIVE);
    uart_cfg113.apb_cfg13.add_slave13("uart113", `AM_UART1_BASE_ADDRESS13, `AM_UART1_END_ADDRESS13, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config13

`endif // UART_CTRL_CONFIG_SV13

