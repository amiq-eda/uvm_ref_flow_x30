/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_config20.svh
Title20       : APB20 Subsystem20 configuration
Project20     :
Created20     :
Description20 : This20 file contains20 multiple configuration classes20:
                apb_config20
                   master_config20
                   slave_configs20[N]
                uart_config20
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV20
`define APB_SUBSYSTEM_CTRL_CONFIG_SV20

// APB20 Subsystem20 Configuration20 Class20
class apb_subsystem_config20 extends uvm_object;

  uart_ctrl_config20 uart_cfg020;
  uart_ctrl_config20 uart_cfg120;
  spi_pkg20::spi_config20 spi_cfg20;  //Sharon20 - ok to use as is, as a shortcut20 - document20 this
  gpio_pkg20::gpio_config20 gpio_cfg20;

  `uvm_object_utils_begin(apb_subsystem_config20)
      `uvm_field_object(uart_cfg020, UVM_DEFAULT)
      `uvm_field_object(uart_cfg120, UVM_DEFAULT)
      `uvm_field_object(spi_cfg20, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg20, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config20");
    super.new(name);
    uart_cfg020 = uart_ctrl_config20::type_id::create("uart_cfg020");
    uart_cfg120 = uart_ctrl_config20::type_id::create("uart_cfg120");
    spi_cfg20   = spi_pkg20::spi_config20::type_id::create("spi_cfg20"); 
    gpio_cfg20  = gpio_pkg20::gpio_config20::type_id::create("gpio_cfg20"); 
  endfunction : new

endclass : apb_subsystem_config20

//================================================================
class default_apb_subsystem_config20 extends apb_subsystem_config20;

  `uvm_object_utils(default_apb_subsystem_config20)

  function new(string name = "default_apb_subsystem_config20");
    super.new(name);
    uart_cfg020 = uart_ctrl_config20::type_id::create("uart_cfg020");
    uart_cfg120 = uart_ctrl_config20::type_id::create("uart_cfg120");
    spi_cfg20   = spi_pkg20::spi_config20::type_id::create("spi_cfg20"); 
    gpio_cfg20  = gpio_pkg20::gpio_config20::type_id::create("gpio_cfg20"); 
    uart_cfg020.apb_cfg20.add_master20("master20", UVM_PASSIVE);
    uart_cfg020.apb_cfg20.add_slave20("spi020",  `AM_SPI0_BASE_ADDRESS20,  `AM_SPI0_END_ADDRESS20,  0, UVM_PASSIVE);
    uart_cfg020.apb_cfg20.add_slave20("uart020", `AM_UART0_BASE_ADDRESS20, `AM_UART0_END_ADDRESS20, 0, UVM_PASSIVE);
    uart_cfg020.apb_cfg20.add_slave20("gpio020", `AM_GPIO0_BASE_ADDRESS20, `AM_GPIO0_END_ADDRESS20, 0, UVM_PASSIVE);
    uart_cfg020.apb_cfg20.add_slave20("uart120", `AM_UART1_BASE_ADDRESS20, `AM_UART1_END_ADDRESS20, 1, UVM_PASSIVE);
    uart_cfg120.apb_cfg20.add_master20("master20", UVM_PASSIVE);
    uart_cfg120.apb_cfg20.add_slave20("spi020",  `AM_SPI0_BASE_ADDRESS20,  `AM_SPI0_END_ADDRESS20,  0, UVM_PASSIVE);
    uart_cfg120.apb_cfg20.add_slave20("uart020", `AM_UART0_BASE_ADDRESS20, `AM_UART0_END_ADDRESS20, 0, UVM_PASSIVE);
    uart_cfg120.apb_cfg20.add_slave20("gpio020", `AM_GPIO0_BASE_ADDRESS20, `AM_GPIO0_END_ADDRESS20, 0, UVM_PASSIVE);
    uart_cfg120.apb_cfg20.add_slave20("uart120", `AM_UART1_BASE_ADDRESS20, `AM_UART1_END_ADDRESS20, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config20

`endif // UART_CTRL_CONFIG_SV20

