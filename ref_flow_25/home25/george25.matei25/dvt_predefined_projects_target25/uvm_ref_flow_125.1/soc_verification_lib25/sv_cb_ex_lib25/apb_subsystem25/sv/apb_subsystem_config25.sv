/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_config25.svh
Title25       : APB25 Subsystem25 configuration
Project25     :
Created25     :
Description25 : This25 file contains25 multiple configuration classes25:
                apb_config25
                   master_config25
                   slave_configs25[N]
                uart_config25
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV25
`define APB_SUBSYSTEM_CTRL_CONFIG_SV25

// APB25 Subsystem25 Configuration25 Class25
class apb_subsystem_config25 extends uvm_object;

  uart_ctrl_config25 uart_cfg025;
  uart_ctrl_config25 uart_cfg125;
  spi_pkg25::spi_config25 spi_cfg25;  //Sharon25 - ok to use as is, as a shortcut25 - document25 this
  gpio_pkg25::gpio_config25 gpio_cfg25;

  `uvm_object_utils_begin(apb_subsystem_config25)
      `uvm_field_object(uart_cfg025, UVM_DEFAULT)
      `uvm_field_object(uart_cfg125, UVM_DEFAULT)
      `uvm_field_object(spi_cfg25, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg25, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config25");
    super.new(name);
    uart_cfg025 = uart_ctrl_config25::type_id::create("uart_cfg025");
    uart_cfg125 = uart_ctrl_config25::type_id::create("uart_cfg125");
    spi_cfg25   = spi_pkg25::spi_config25::type_id::create("spi_cfg25"); 
    gpio_cfg25  = gpio_pkg25::gpio_config25::type_id::create("gpio_cfg25"); 
  endfunction : new

endclass : apb_subsystem_config25

//================================================================
class default_apb_subsystem_config25 extends apb_subsystem_config25;

  `uvm_object_utils(default_apb_subsystem_config25)

  function new(string name = "default_apb_subsystem_config25");
    super.new(name);
    uart_cfg025 = uart_ctrl_config25::type_id::create("uart_cfg025");
    uart_cfg125 = uart_ctrl_config25::type_id::create("uart_cfg125");
    spi_cfg25   = spi_pkg25::spi_config25::type_id::create("spi_cfg25"); 
    gpio_cfg25  = gpio_pkg25::gpio_config25::type_id::create("gpio_cfg25"); 
    uart_cfg025.apb_cfg25.add_master25("master25", UVM_PASSIVE);
    uart_cfg025.apb_cfg25.add_slave25("spi025",  `AM_SPI0_BASE_ADDRESS25,  `AM_SPI0_END_ADDRESS25,  0, UVM_PASSIVE);
    uart_cfg025.apb_cfg25.add_slave25("uart025", `AM_UART0_BASE_ADDRESS25, `AM_UART0_END_ADDRESS25, 0, UVM_PASSIVE);
    uart_cfg025.apb_cfg25.add_slave25("gpio025", `AM_GPIO0_BASE_ADDRESS25, `AM_GPIO0_END_ADDRESS25, 0, UVM_PASSIVE);
    uart_cfg025.apb_cfg25.add_slave25("uart125", `AM_UART1_BASE_ADDRESS25, `AM_UART1_END_ADDRESS25, 1, UVM_PASSIVE);
    uart_cfg125.apb_cfg25.add_master25("master25", UVM_PASSIVE);
    uart_cfg125.apb_cfg25.add_slave25("spi025",  `AM_SPI0_BASE_ADDRESS25,  `AM_SPI0_END_ADDRESS25,  0, UVM_PASSIVE);
    uart_cfg125.apb_cfg25.add_slave25("uart025", `AM_UART0_BASE_ADDRESS25, `AM_UART0_END_ADDRESS25, 0, UVM_PASSIVE);
    uart_cfg125.apb_cfg25.add_slave25("gpio025", `AM_GPIO0_BASE_ADDRESS25, `AM_GPIO0_END_ADDRESS25, 0, UVM_PASSIVE);
    uart_cfg125.apb_cfg25.add_slave25("uart125", `AM_UART1_BASE_ADDRESS25, `AM_UART1_END_ADDRESS25, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config25

`endif // UART_CTRL_CONFIG_SV25

