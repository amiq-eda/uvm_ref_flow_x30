/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_config22.svh
Title22       : APB22 Subsystem22 configuration
Project22     :
Created22     :
Description22 : This22 file contains22 multiple configuration classes22:
                apb_config22
                   master_config22
                   slave_configs22[N]
                uart_config22
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV22
`define APB_SUBSYSTEM_CTRL_CONFIG_SV22

// APB22 Subsystem22 Configuration22 Class22
class apb_subsystem_config22 extends uvm_object;

  uart_ctrl_config22 uart_cfg022;
  uart_ctrl_config22 uart_cfg122;
  spi_pkg22::spi_config22 spi_cfg22;  //Sharon22 - ok to use as is, as a shortcut22 - document22 this
  gpio_pkg22::gpio_config22 gpio_cfg22;

  `uvm_object_utils_begin(apb_subsystem_config22)
      `uvm_field_object(uart_cfg022, UVM_DEFAULT)
      `uvm_field_object(uart_cfg122, UVM_DEFAULT)
      `uvm_field_object(spi_cfg22, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg22, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config22");
    super.new(name);
    uart_cfg022 = uart_ctrl_config22::type_id::create("uart_cfg022");
    uart_cfg122 = uart_ctrl_config22::type_id::create("uart_cfg122");
    spi_cfg22   = spi_pkg22::spi_config22::type_id::create("spi_cfg22"); 
    gpio_cfg22  = gpio_pkg22::gpio_config22::type_id::create("gpio_cfg22"); 
  endfunction : new

endclass : apb_subsystem_config22

//================================================================
class default_apb_subsystem_config22 extends apb_subsystem_config22;

  `uvm_object_utils(default_apb_subsystem_config22)

  function new(string name = "default_apb_subsystem_config22");
    super.new(name);
    uart_cfg022 = uart_ctrl_config22::type_id::create("uart_cfg022");
    uart_cfg122 = uart_ctrl_config22::type_id::create("uart_cfg122");
    spi_cfg22   = spi_pkg22::spi_config22::type_id::create("spi_cfg22"); 
    gpio_cfg22  = gpio_pkg22::gpio_config22::type_id::create("gpio_cfg22"); 
    uart_cfg022.apb_cfg22.add_master22("master22", UVM_PASSIVE);
    uart_cfg022.apb_cfg22.add_slave22("spi022",  `AM_SPI0_BASE_ADDRESS22,  `AM_SPI0_END_ADDRESS22,  0, UVM_PASSIVE);
    uart_cfg022.apb_cfg22.add_slave22("uart022", `AM_UART0_BASE_ADDRESS22, `AM_UART0_END_ADDRESS22, 0, UVM_PASSIVE);
    uart_cfg022.apb_cfg22.add_slave22("gpio022", `AM_GPIO0_BASE_ADDRESS22, `AM_GPIO0_END_ADDRESS22, 0, UVM_PASSIVE);
    uart_cfg022.apb_cfg22.add_slave22("uart122", `AM_UART1_BASE_ADDRESS22, `AM_UART1_END_ADDRESS22, 1, UVM_PASSIVE);
    uart_cfg122.apb_cfg22.add_master22("master22", UVM_PASSIVE);
    uart_cfg122.apb_cfg22.add_slave22("spi022",  `AM_SPI0_BASE_ADDRESS22,  `AM_SPI0_END_ADDRESS22,  0, UVM_PASSIVE);
    uart_cfg122.apb_cfg22.add_slave22("uart022", `AM_UART0_BASE_ADDRESS22, `AM_UART0_END_ADDRESS22, 0, UVM_PASSIVE);
    uart_cfg122.apb_cfg22.add_slave22("gpio022", `AM_GPIO0_BASE_ADDRESS22, `AM_GPIO0_END_ADDRESS22, 0, UVM_PASSIVE);
    uart_cfg122.apb_cfg22.add_slave22("uart122", `AM_UART1_BASE_ADDRESS22, `AM_UART1_END_ADDRESS22, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config22

`endif // UART_CTRL_CONFIG_SV22

