/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_config3.svh
Title3       : UART3 Controller3 configuration
Project3     :
Created3     :
Description3 : This3 file contains3 multiple configuration classes3:
                apb_config3
                   master_config3
                   slave_configs3[N]
                uart_config3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV3
`define UART_CTRL_CONFIG_SV3

// UART3 Controller3 Configuration3 Class3
class uart_ctrl_config3 extends uvm_object;

  apb_config3 apb_cfg3;
  uart_config3 uart_cfg3;

  `uvm_object_utils_begin(uart_ctrl_config3)
      `uvm_field_object(apb_cfg3, UVM_DEFAULT)
      `uvm_field_object(uart_cfg3, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config3");
    super.new(name);
    uart_cfg3 = uart_config3::type_id::create("uart_cfg3");
    apb_cfg3 = apb_config3::type_id::create("apb_cfg3"); 
  endfunction : new

endclass : uart_ctrl_config3

//================================================================
class default_uart_ctrl_config3 extends uart_ctrl_config3;

  `uvm_object_utils(default_uart_ctrl_config3)

  function new(string name = "default_uart_ctrl_config3");
    super.new(name);
    uart_cfg3 = uart_config3::type_id::create("uart_cfg3");
    apb_cfg3 = apb_config3::type_id::create("apb_cfg3"); 
    apb_cfg3.add_slave3("slave03", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg3.add_master3("master3", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config3

`endif // UART_CTRL_CONFIG_SV3
