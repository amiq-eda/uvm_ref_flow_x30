/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_config18.svh
Title18       : APB18 Subsystem18 configuration
Project18     :
Created18     :
Description18 : This18 file contains18 multiple configuration classes18:
                apb_config18
                   master_config18
                   slave_configs18[N]
                uart_config18
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV18
`define APB_SUBSYSTEM_CTRL_CONFIG_SV18

// APB18 Subsystem18 Configuration18 Class18
class apb_subsystem_config18 extends uvm_object;

  uart_ctrl_config18 uart_cfg018;
  uart_ctrl_config18 uart_cfg118;
  spi_pkg18::spi_config18 spi_cfg18;  //Sharon18 - ok to use as is, as a shortcut18 - document18 this
  gpio_pkg18::gpio_config18 gpio_cfg18;

  `uvm_object_utils_begin(apb_subsystem_config18)
      `uvm_field_object(uart_cfg018, UVM_DEFAULT)
      `uvm_field_object(uart_cfg118, UVM_DEFAULT)
      `uvm_field_object(spi_cfg18, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg18, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config18");
    super.new(name);
    uart_cfg018 = uart_ctrl_config18::type_id::create("uart_cfg018");
    uart_cfg118 = uart_ctrl_config18::type_id::create("uart_cfg118");
    spi_cfg18   = spi_pkg18::spi_config18::type_id::create("spi_cfg18"); 
    gpio_cfg18  = gpio_pkg18::gpio_config18::type_id::create("gpio_cfg18"); 
  endfunction : new

endclass : apb_subsystem_config18

//================================================================
class default_apb_subsystem_config18 extends apb_subsystem_config18;

  `uvm_object_utils(default_apb_subsystem_config18)

  function new(string name = "default_apb_subsystem_config18");
    super.new(name);
    uart_cfg018 = uart_ctrl_config18::type_id::create("uart_cfg018");
    uart_cfg118 = uart_ctrl_config18::type_id::create("uart_cfg118");
    spi_cfg18   = spi_pkg18::spi_config18::type_id::create("spi_cfg18"); 
    gpio_cfg18  = gpio_pkg18::gpio_config18::type_id::create("gpio_cfg18"); 
    uart_cfg018.apb_cfg18.add_master18("master18", UVM_PASSIVE);
    uart_cfg018.apb_cfg18.add_slave18("spi018",  `AM_SPI0_BASE_ADDRESS18,  `AM_SPI0_END_ADDRESS18,  0, UVM_PASSIVE);
    uart_cfg018.apb_cfg18.add_slave18("uart018", `AM_UART0_BASE_ADDRESS18, `AM_UART0_END_ADDRESS18, 0, UVM_PASSIVE);
    uart_cfg018.apb_cfg18.add_slave18("gpio018", `AM_GPIO0_BASE_ADDRESS18, `AM_GPIO0_END_ADDRESS18, 0, UVM_PASSIVE);
    uart_cfg018.apb_cfg18.add_slave18("uart118", `AM_UART1_BASE_ADDRESS18, `AM_UART1_END_ADDRESS18, 1, UVM_PASSIVE);
    uart_cfg118.apb_cfg18.add_master18("master18", UVM_PASSIVE);
    uart_cfg118.apb_cfg18.add_slave18("spi018",  `AM_SPI0_BASE_ADDRESS18,  `AM_SPI0_END_ADDRESS18,  0, UVM_PASSIVE);
    uart_cfg118.apb_cfg18.add_slave18("uart018", `AM_UART0_BASE_ADDRESS18, `AM_UART0_END_ADDRESS18, 0, UVM_PASSIVE);
    uart_cfg118.apb_cfg18.add_slave18("gpio018", `AM_GPIO0_BASE_ADDRESS18, `AM_GPIO0_END_ADDRESS18, 0, UVM_PASSIVE);
    uart_cfg118.apb_cfg18.add_slave18("uart118", `AM_UART1_BASE_ADDRESS18, `AM_UART1_END_ADDRESS18, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config18

`endif // UART_CTRL_CONFIG_SV18

