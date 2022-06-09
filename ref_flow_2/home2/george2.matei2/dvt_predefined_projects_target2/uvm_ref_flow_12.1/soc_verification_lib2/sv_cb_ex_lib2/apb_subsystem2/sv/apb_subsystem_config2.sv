/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_config2.svh
Title2       : APB2 Subsystem2 configuration
Project2     :
Created2     :
Description2 : This2 file contains2 multiple configuration classes2:
                apb_config2
                   master_config2
                   slave_configs2[N]
                uart_config2
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_SUBSYSTEM_CTRL_CONFIG_SV2
`define APB_SUBSYSTEM_CTRL_CONFIG_SV2

// APB2 Subsystem2 Configuration2 Class2
class apb_subsystem_config2 extends uvm_object;

  uart_ctrl_config2 uart_cfg02;
  uart_ctrl_config2 uart_cfg12;
  spi_pkg2::spi_config2 spi_cfg2;  //Sharon2 - ok to use as is, as a shortcut2 - document2 this
  gpio_pkg2::gpio_config2 gpio_cfg2;

  `uvm_object_utils_begin(apb_subsystem_config2)
      `uvm_field_object(uart_cfg02, UVM_DEFAULT)
      `uvm_field_object(uart_cfg12, UVM_DEFAULT)
      `uvm_field_object(spi_cfg2, UVM_DEFAULT)
      `uvm_field_object(gpio_cfg2, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "apb_subsystem_config2");
    super.new(name);
    uart_cfg02 = uart_ctrl_config2::type_id::create("uart_cfg02");
    uart_cfg12 = uart_ctrl_config2::type_id::create("uart_cfg12");
    spi_cfg2   = spi_pkg2::spi_config2::type_id::create("spi_cfg2"); 
    gpio_cfg2  = gpio_pkg2::gpio_config2::type_id::create("gpio_cfg2"); 
  endfunction : new

endclass : apb_subsystem_config2

//================================================================
class default_apb_subsystem_config2 extends apb_subsystem_config2;

  `uvm_object_utils(default_apb_subsystem_config2)

  function new(string name = "default_apb_subsystem_config2");
    super.new(name);
    uart_cfg02 = uart_ctrl_config2::type_id::create("uart_cfg02");
    uart_cfg12 = uart_ctrl_config2::type_id::create("uart_cfg12");
    spi_cfg2   = spi_pkg2::spi_config2::type_id::create("spi_cfg2"); 
    gpio_cfg2  = gpio_pkg2::gpio_config2::type_id::create("gpio_cfg2"); 
    uart_cfg02.apb_cfg2.add_master2("master2", UVM_PASSIVE);
    uart_cfg02.apb_cfg2.add_slave2("spi02",  `AM_SPI0_BASE_ADDRESS2,  `AM_SPI0_END_ADDRESS2,  0, UVM_PASSIVE);
    uart_cfg02.apb_cfg2.add_slave2("uart02", `AM_UART0_BASE_ADDRESS2, `AM_UART0_END_ADDRESS2, 0, UVM_PASSIVE);
    uart_cfg02.apb_cfg2.add_slave2("gpio02", `AM_GPIO0_BASE_ADDRESS2, `AM_GPIO0_END_ADDRESS2, 0, UVM_PASSIVE);
    uart_cfg02.apb_cfg2.add_slave2("uart12", `AM_UART1_BASE_ADDRESS2, `AM_UART1_END_ADDRESS2, 1, UVM_PASSIVE);
    uart_cfg12.apb_cfg2.add_master2("master2", UVM_PASSIVE);
    uart_cfg12.apb_cfg2.add_slave2("spi02",  `AM_SPI0_BASE_ADDRESS2,  `AM_SPI0_END_ADDRESS2,  0, UVM_PASSIVE);
    uart_cfg12.apb_cfg2.add_slave2("uart02", `AM_UART0_BASE_ADDRESS2, `AM_UART0_END_ADDRESS2, 0, UVM_PASSIVE);
    uart_cfg12.apb_cfg2.add_slave2("gpio02", `AM_GPIO0_BASE_ADDRESS2, `AM_GPIO0_END_ADDRESS2, 0, UVM_PASSIVE);
    uart_cfg12.apb_cfg2.add_slave2("uart12", `AM_UART1_BASE_ADDRESS2, `AM_UART1_END_ADDRESS2, 1, UVM_PASSIVE);
  endfunction

endclass : default_apb_subsystem_config2

`endif // UART_CTRL_CONFIG_SV2

