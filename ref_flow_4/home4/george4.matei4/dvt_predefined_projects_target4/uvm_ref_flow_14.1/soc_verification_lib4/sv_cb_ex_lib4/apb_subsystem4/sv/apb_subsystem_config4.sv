/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_config4.svh
Title4       : APB4 Subsystem4 configuration
Project4     :
Created4     :
Description4 : This4 file contains4 multiple configuration classes4:
                apb_config4
                   master_config4
                   slave_configs4[N]
                uart_config4
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV4
`define APB_SUBSYSTEM_CTRL_CONFIG_SV4

// APB4 Subsystem4 Configuration4 Class4
class apb_subsystem_config4 extends uvm_object;

  uart_ctrl_config4 uart_cfg04;
  uart_ctrl_config4 uart_cfg14;
  spi_pkg4::spi_config4 spi_cfg4;  //Sharon4 - ok to use as is, as a shortcut4 - document4 this
  gpio_pkg4::gpio_config4 gpio_cfg4;

  `uvm_object_utils_begin(apb_subsystem_config4)
      `uvm_field_object(uart_cfg04, UVM_DEFAULT)
      `uvm_field_object(uart_cfg14, UVM_DEFAULT)
      `uvm_field_object(spi_cfg4, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg4, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config4");
    super.new(name);
    uart_cfg04 = uart_ctrl_config4::type_id::create("uart_cfg04");
    uart_cfg14 = uart_ctrl_config4::type_id::create("uart_cfg14");
    spi_cfg4   = spi_pkg4::spi_config4::type_id::create("spi_cfg4"); 
    gpio_cfg4  = gpio_pkg4::gpio_config4::type_id::create("gpio_cfg4"); 
  endfunction : new

endclass : apb_subsystem_config4

//================================================================
class default_apb_subsystem_config4 extends apb_subsystem_config4;

  `uvm_object_utils(default_apb_subsystem_config4)

  function new(string name = "default_apb_subsystem_config4");
    super.new(name);
    uart_cfg04 = uart_ctrl_config4::type_id::create("uart_cfg04");
    uart_cfg14 = uart_ctrl_config4::type_id::create("uart_cfg14");
    spi_cfg4   = spi_pkg4::spi_config4::type_id::create("spi_cfg4"); 
    gpio_cfg4  = gpio_pkg4::gpio_config4::type_id::create("gpio_cfg4"); 
    uart_cfg04.apb_cfg4.add_master4("master4", UVM_PASSIVE);
    uart_cfg04.apb_cfg4.add_slave4("spi04",  `AM_SPI0_BASE_ADDRESS4,  `AM_SPI0_END_ADDRESS4,  0, UVM_PASSIVE);
    uart_cfg04.apb_cfg4.add_slave4("uart04", `AM_UART0_BASE_ADDRESS4, `AM_UART0_END_ADDRESS4, 0, UVM_PASSIVE);
    uart_cfg04.apb_cfg4.add_slave4("gpio04", `AM_GPIO0_BASE_ADDRESS4, `AM_GPIO0_END_ADDRESS4, 0, UVM_PASSIVE);
    uart_cfg04.apb_cfg4.add_slave4("uart14", `AM_UART1_BASE_ADDRESS4, `AM_UART1_END_ADDRESS4, 1, UVM_PASSIVE);
    uart_cfg14.apb_cfg4.add_master4("master4", UVM_PASSIVE);
    uart_cfg14.apb_cfg4.add_slave4("spi04",  `AM_SPI0_BASE_ADDRESS4,  `AM_SPI0_END_ADDRESS4,  0, UVM_PASSIVE);
    uart_cfg14.apb_cfg4.add_slave4("uart04", `AM_UART0_BASE_ADDRESS4, `AM_UART0_END_ADDRESS4, 0, UVM_PASSIVE);
    uart_cfg14.apb_cfg4.add_slave4("gpio04", `AM_GPIO0_BASE_ADDRESS4, `AM_GPIO0_END_ADDRESS4, 0, UVM_PASSIVE);
    uart_cfg14.apb_cfg4.add_slave4("uart14", `AM_UART1_BASE_ADDRESS4, `AM_UART1_END_ADDRESS4, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config4

`endif // UART_CTRL_CONFIG_SV4

