/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_config12.svh
Title12       : APB12 Subsystem12 configuration
Project12     :
Created12     :
Description12 : This12 file contains12 multiple configuration classes12:
                apb_config12
                   master_config12
                   slave_configs12[N]
                uart_config12
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV12
`define APB_SUBSYSTEM_CTRL_CONFIG_SV12

// APB12 Subsystem12 Configuration12 Class12
class apb_subsystem_config12 extends uvm_object;

  uart_ctrl_config12 uart_cfg012;
  uart_ctrl_config12 uart_cfg112;
  spi_pkg12::spi_config12 spi_cfg12;  //Sharon12 - ok to use as is, as a shortcut12 - document12 this
  gpio_pkg12::gpio_config12 gpio_cfg12;

  `uvm_object_utils_begin(apb_subsystem_config12)
      `uvm_field_object(uart_cfg012, UVM_DEFAULT)
      `uvm_field_object(uart_cfg112, UVM_DEFAULT)
      `uvm_field_object(spi_cfg12, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg12, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config12");
    super.new(name);
    uart_cfg012 = uart_ctrl_config12::type_id::create("uart_cfg012");
    uart_cfg112 = uart_ctrl_config12::type_id::create("uart_cfg112");
    spi_cfg12   = spi_pkg12::spi_config12::type_id::create("spi_cfg12"); 
    gpio_cfg12  = gpio_pkg12::gpio_config12::type_id::create("gpio_cfg12"); 
  endfunction : new

endclass : apb_subsystem_config12

//================================================================
class default_apb_subsystem_config12 extends apb_subsystem_config12;

  `uvm_object_utils(default_apb_subsystem_config12)

  function new(string name = "default_apb_subsystem_config12");
    super.new(name);
    uart_cfg012 = uart_ctrl_config12::type_id::create("uart_cfg012");
    uart_cfg112 = uart_ctrl_config12::type_id::create("uart_cfg112");
    spi_cfg12   = spi_pkg12::spi_config12::type_id::create("spi_cfg12"); 
    gpio_cfg12  = gpio_pkg12::gpio_config12::type_id::create("gpio_cfg12"); 
    uart_cfg012.apb_cfg12.add_master12("master12", UVM_PASSIVE);
    uart_cfg012.apb_cfg12.add_slave12("spi012",  `AM_SPI0_BASE_ADDRESS12,  `AM_SPI0_END_ADDRESS12,  0, UVM_PASSIVE);
    uart_cfg012.apb_cfg12.add_slave12("uart012", `AM_UART0_BASE_ADDRESS12, `AM_UART0_END_ADDRESS12, 0, UVM_PASSIVE);
    uart_cfg012.apb_cfg12.add_slave12("gpio012", `AM_GPIO0_BASE_ADDRESS12, `AM_GPIO0_END_ADDRESS12, 0, UVM_PASSIVE);
    uart_cfg012.apb_cfg12.add_slave12("uart112", `AM_UART1_BASE_ADDRESS12, `AM_UART1_END_ADDRESS12, 1, UVM_PASSIVE);
    uart_cfg112.apb_cfg12.add_master12("master12", UVM_PASSIVE);
    uart_cfg112.apb_cfg12.add_slave12("spi012",  `AM_SPI0_BASE_ADDRESS12,  `AM_SPI0_END_ADDRESS12,  0, UVM_PASSIVE);
    uart_cfg112.apb_cfg12.add_slave12("uart012", `AM_UART0_BASE_ADDRESS12, `AM_UART0_END_ADDRESS12, 0, UVM_PASSIVE);
    uart_cfg112.apb_cfg12.add_slave12("gpio012", `AM_GPIO0_BASE_ADDRESS12, `AM_GPIO0_END_ADDRESS12, 0, UVM_PASSIVE);
    uart_cfg112.apb_cfg12.add_slave12("uart112", `AM_UART1_BASE_ADDRESS12, `AM_UART1_END_ADDRESS12, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config12

`endif // UART_CTRL_CONFIG_SV12

