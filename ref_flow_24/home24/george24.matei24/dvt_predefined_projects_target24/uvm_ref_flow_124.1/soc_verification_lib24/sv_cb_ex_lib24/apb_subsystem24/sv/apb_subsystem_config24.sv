/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_config24.svh
Title24       : APB24 Subsystem24 configuration
Project24     :
Created24     :
Description24 : This24 file contains24 multiple configuration classes24:
                apb_config24
                   master_config24
                   slave_configs24[N]
                uart_config24
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV24
`define APB_SUBSYSTEM_CTRL_CONFIG_SV24

// APB24 Subsystem24 Configuration24 Class24
class apb_subsystem_config24 extends uvm_object;

  uart_ctrl_config24 uart_cfg024;
  uart_ctrl_config24 uart_cfg124;
  spi_pkg24::spi_config24 spi_cfg24;  //Sharon24 - ok to use as is, as a shortcut24 - document24 this
  gpio_pkg24::gpio_config24 gpio_cfg24;

  `uvm_object_utils_begin(apb_subsystem_config24)
      `uvm_field_object(uart_cfg024, UVM_DEFAULT)
      `uvm_field_object(uart_cfg124, UVM_DEFAULT)
      `uvm_field_object(spi_cfg24, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg24, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config24");
    super.new(name);
    uart_cfg024 = uart_ctrl_config24::type_id::create("uart_cfg024");
    uart_cfg124 = uart_ctrl_config24::type_id::create("uart_cfg124");
    spi_cfg24   = spi_pkg24::spi_config24::type_id::create("spi_cfg24"); 
    gpio_cfg24  = gpio_pkg24::gpio_config24::type_id::create("gpio_cfg24"); 
  endfunction : new

endclass : apb_subsystem_config24

//================================================================
class default_apb_subsystem_config24 extends apb_subsystem_config24;

  `uvm_object_utils(default_apb_subsystem_config24)

  function new(string name = "default_apb_subsystem_config24");
    super.new(name);
    uart_cfg024 = uart_ctrl_config24::type_id::create("uart_cfg024");
    uart_cfg124 = uart_ctrl_config24::type_id::create("uart_cfg124");
    spi_cfg24   = spi_pkg24::spi_config24::type_id::create("spi_cfg24"); 
    gpio_cfg24  = gpio_pkg24::gpio_config24::type_id::create("gpio_cfg24"); 
    uart_cfg024.apb_cfg24.add_master24("master24", UVM_PASSIVE);
    uart_cfg024.apb_cfg24.add_slave24("spi024",  `AM_SPI0_BASE_ADDRESS24,  `AM_SPI0_END_ADDRESS24,  0, UVM_PASSIVE);
    uart_cfg024.apb_cfg24.add_slave24("uart024", `AM_UART0_BASE_ADDRESS24, `AM_UART0_END_ADDRESS24, 0, UVM_PASSIVE);
    uart_cfg024.apb_cfg24.add_slave24("gpio024", `AM_GPIO0_BASE_ADDRESS24, `AM_GPIO0_END_ADDRESS24, 0, UVM_PASSIVE);
    uart_cfg024.apb_cfg24.add_slave24("uart124", `AM_UART1_BASE_ADDRESS24, `AM_UART1_END_ADDRESS24, 1, UVM_PASSIVE);
    uart_cfg124.apb_cfg24.add_master24("master24", UVM_PASSIVE);
    uart_cfg124.apb_cfg24.add_slave24("spi024",  `AM_SPI0_BASE_ADDRESS24,  `AM_SPI0_END_ADDRESS24,  0, UVM_PASSIVE);
    uart_cfg124.apb_cfg24.add_slave24("uart024", `AM_UART0_BASE_ADDRESS24, `AM_UART0_END_ADDRESS24, 0, UVM_PASSIVE);
    uart_cfg124.apb_cfg24.add_slave24("gpio024", `AM_GPIO0_BASE_ADDRESS24, `AM_GPIO0_END_ADDRESS24, 0, UVM_PASSIVE);
    uart_cfg124.apb_cfg24.add_slave24("uart124", `AM_UART1_BASE_ADDRESS24, `AM_UART1_END_ADDRESS24, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config24

`endif // UART_CTRL_CONFIG_SV24

