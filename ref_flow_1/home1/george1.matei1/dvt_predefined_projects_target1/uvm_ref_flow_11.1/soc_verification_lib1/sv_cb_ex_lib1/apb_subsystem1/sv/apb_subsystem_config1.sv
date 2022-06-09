/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_config1.svh
Title1       : APB1 Subsystem1 configuration
Project1     :
Created1     :
Description1 : This1 file contains1 multiple configuration classes1:
                apb_config1
                   master_config1
                   slave_configs1[N]
                uart_config1
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV1
`define APB_SUBSYSTEM_CTRL_CONFIG_SV1

// APB1 Subsystem1 Configuration1 Class1
class apb_subsystem_config1 extends uvm_object;

  uart_ctrl_config1 uart_cfg01;
  uart_ctrl_config1 uart_cfg11;
  spi_pkg1::spi_config1 spi_cfg1;  //Sharon1 - ok to use as is, as a shortcut1 - document1 this
  gpio_pkg1::gpio_config1 gpio_cfg1;

  `uvm_object_utils_begin(apb_subsystem_config1)
      `uvm_field_object(uart_cfg01, UVM_DEFAULT)
      `uvm_field_object(uart_cfg11, UVM_DEFAULT)
      `uvm_field_object(spi_cfg1, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg1, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config1");
    super.new(name);
    uart_cfg01 = uart_ctrl_config1::type_id::create("uart_cfg01");
    uart_cfg11 = uart_ctrl_config1::type_id::create("uart_cfg11");
    spi_cfg1   = spi_pkg1::spi_config1::type_id::create("spi_cfg1"); 
    gpio_cfg1  = gpio_pkg1::gpio_config1::type_id::create("gpio_cfg1"); 
  endfunction : new

endclass : apb_subsystem_config1

//================================================================
class default_apb_subsystem_config1 extends apb_subsystem_config1;

  `uvm_object_utils(default_apb_subsystem_config1)

  function new(string name = "default_apb_subsystem_config1");
    super.new(name);
    uart_cfg01 = uart_ctrl_config1::type_id::create("uart_cfg01");
    uart_cfg11 = uart_ctrl_config1::type_id::create("uart_cfg11");
    spi_cfg1   = spi_pkg1::spi_config1::type_id::create("spi_cfg1"); 
    gpio_cfg1  = gpio_pkg1::gpio_config1::type_id::create("gpio_cfg1"); 
    uart_cfg01.apb_cfg1.add_master1("master1", UVM_PASSIVE);
    uart_cfg01.apb_cfg1.add_slave1("spi01",  `AM_SPI0_BASE_ADDRESS1,  `AM_SPI0_END_ADDRESS1,  0, UVM_PASSIVE);
    uart_cfg01.apb_cfg1.add_slave1("uart01", `AM_UART0_BASE_ADDRESS1, `AM_UART0_END_ADDRESS1, 0, UVM_PASSIVE);
    uart_cfg01.apb_cfg1.add_slave1("gpio01", `AM_GPIO0_BASE_ADDRESS1, `AM_GPIO0_END_ADDRESS1, 0, UVM_PASSIVE);
    uart_cfg01.apb_cfg1.add_slave1("uart11", `AM_UART1_BASE_ADDRESS1, `AM_UART1_END_ADDRESS1, 1, UVM_PASSIVE);
    uart_cfg11.apb_cfg1.add_master1("master1", UVM_PASSIVE);
    uart_cfg11.apb_cfg1.add_slave1("spi01",  `AM_SPI0_BASE_ADDRESS1,  `AM_SPI0_END_ADDRESS1,  0, UVM_PASSIVE);
    uart_cfg11.apb_cfg1.add_slave1("uart01", `AM_UART0_BASE_ADDRESS1, `AM_UART0_END_ADDRESS1, 0, UVM_PASSIVE);
    uart_cfg11.apb_cfg1.add_slave1("gpio01", `AM_GPIO0_BASE_ADDRESS1, `AM_GPIO0_END_ADDRESS1, 0, UVM_PASSIVE);
    uart_cfg11.apb_cfg1.add_slave1("uart11", `AM_UART1_BASE_ADDRESS1, `AM_UART1_END_ADDRESS1, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config1

`endif // UART_CTRL_CONFIG_SV1

