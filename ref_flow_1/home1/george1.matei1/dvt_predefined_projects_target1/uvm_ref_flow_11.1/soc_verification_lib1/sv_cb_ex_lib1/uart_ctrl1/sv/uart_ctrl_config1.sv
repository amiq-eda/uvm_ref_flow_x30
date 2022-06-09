/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_config1.svh
Title1       : UART1 Controller1 configuration
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


`ifndef UART_CTRL_CONFIG_SV1
`define UART_CTRL_CONFIG_SV1

// UART1 Controller1 Configuration1 Class1
class uart_ctrl_config1 extends uvm_object;

  apb_config1 apb_cfg1;
  uart_config1 uart_cfg1;

  `uvm_object_utils_begin(uart_ctrl_config1)
      `uvm_field_object(apb_cfg1, UVM_DEFAULT)
      `uvm_field_object(uart_cfg1, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config1");
    super.new(name);
    uart_cfg1 = uart_config1::type_id::create("uart_cfg1");
    apb_cfg1 = apb_config1::type_id::create("apb_cfg1"); 
  endfunction : new

endclass : uart_ctrl_config1

//================================================================
class default_uart_ctrl_config1 extends uart_ctrl_config1;

  `uvm_object_utils(default_uart_ctrl_config1)

  function new(string name = "default_uart_ctrl_config1");
    super.new(name);
    uart_cfg1 = uart_config1::type_id::create("uart_cfg1");
    apb_cfg1 = apb_config1::type_id::create("apb_cfg1"); 
    apb_cfg1.add_slave1("slave01", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg1.add_master1("master1", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config1

`endif // UART_CTRL_CONFIG_SV1
