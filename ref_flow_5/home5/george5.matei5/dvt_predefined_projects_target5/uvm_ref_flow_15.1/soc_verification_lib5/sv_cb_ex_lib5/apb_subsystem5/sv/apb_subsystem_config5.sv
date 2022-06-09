/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_config5.svh
Title5       : APB5 Subsystem5 configuration
Project5     :
Created5     :
Description5 : This5 file contains5 multiple configuration classes5:
                apb_config5
                   master_config5
                   slave_configs5[N]
                uart_config5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV5
`define APB_SUBSYSTEM_CTRL_CONFIG_SV5

// APB5 Subsystem5 Configuration5 Class5
class apb_subsystem_config5 extends uvm_object;

  uart_ctrl_config5 uart_cfg05;
  uart_ctrl_config5 uart_cfg15;
  spi_pkg5::spi_config5 spi_cfg5;  //Sharon5 - ok to use as is, as a shortcut5 - document5 this
  gpio_pkg5::gpio_config5 gpio_cfg5;

  `uvm_object_utils_begin(apb_subsystem_config5)
      `uvm_field_object(uart_cfg05, UVM_DEFAULT)
      `uvm_field_object(uart_cfg15, UVM_DEFAULT)
      `uvm_field_object(spi_cfg5, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg5, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config5");
    super.new(name);
    uart_cfg05 = uart_ctrl_config5::type_id::create("uart_cfg05");
    uart_cfg15 = uart_ctrl_config5::type_id::create("uart_cfg15");
    spi_cfg5   = spi_pkg5::spi_config5::type_id::create("spi_cfg5"); 
    gpio_cfg5  = gpio_pkg5::gpio_config5::type_id::create("gpio_cfg5"); 
  endfunction : new

endclass : apb_subsystem_config5

//================================================================
class default_apb_subsystem_config5 extends apb_subsystem_config5;

  `uvm_object_utils(default_apb_subsystem_config5)

  function new(string name = "default_apb_subsystem_config5");
    super.new(name);
    uart_cfg05 = uart_ctrl_config5::type_id::create("uart_cfg05");
    uart_cfg15 = uart_ctrl_config5::type_id::create("uart_cfg15");
    spi_cfg5   = spi_pkg5::spi_config5::type_id::create("spi_cfg5"); 
    gpio_cfg5  = gpio_pkg5::gpio_config5::type_id::create("gpio_cfg5"); 
    uart_cfg05.apb_cfg5.add_master5("master5", UVM_PASSIVE);
    uart_cfg05.apb_cfg5.add_slave5("spi05",  `AM_SPI0_BASE_ADDRESS5,  `AM_SPI0_END_ADDRESS5,  0, UVM_PASSIVE);
    uart_cfg05.apb_cfg5.add_slave5("uart05", `AM_UART0_BASE_ADDRESS5, `AM_UART0_END_ADDRESS5, 0, UVM_PASSIVE);
    uart_cfg05.apb_cfg5.add_slave5("gpio05", `AM_GPIO0_BASE_ADDRESS5, `AM_GPIO0_END_ADDRESS5, 0, UVM_PASSIVE);
    uart_cfg05.apb_cfg5.add_slave5("uart15", `AM_UART1_BASE_ADDRESS5, `AM_UART1_END_ADDRESS5, 1, UVM_PASSIVE);
    uart_cfg15.apb_cfg5.add_master5("master5", UVM_PASSIVE);
    uart_cfg15.apb_cfg5.add_slave5("spi05",  `AM_SPI0_BASE_ADDRESS5,  `AM_SPI0_END_ADDRESS5,  0, UVM_PASSIVE);
    uart_cfg15.apb_cfg5.add_slave5("uart05", `AM_UART0_BASE_ADDRESS5, `AM_UART0_END_ADDRESS5, 0, UVM_PASSIVE);
    uart_cfg15.apb_cfg5.add_slave5("gpio05", `AM_GPIO0_BASE_ADDRESS5, `AM_GPIO0_END_ADDRESS5, 0, UVM_PASSIVE);
    uart_cfg15.apb_cfg5.add_slave5("uart15", `AM_UART1_BASE_ADDRESS5, `AM_UART1_END_ADDRESS5, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config5

`endif // UART_CTRL_CONFIG_SV5

