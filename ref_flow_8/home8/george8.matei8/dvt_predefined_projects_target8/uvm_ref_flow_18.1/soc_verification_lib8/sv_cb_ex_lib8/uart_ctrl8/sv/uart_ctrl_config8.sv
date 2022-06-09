/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_config8.svh
Title8       : UART8 Controller8 configuration
Project8     :
Created8     :
Description8 : This8 file contains8 multiple configuration classes8:
                apb_config8
                   master_config8
                   slave_configs8[N]
                uart_config8
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV8
`define UART_CTRL_CONFIG_SV8

// UART8 Controller8 Configuration8 Class8
class uart_ctrl_config8 extends uvm_object;

  apb_config8 apb_cfg8;
  uart_config8 uart_cfg8;

  `uvm_object_utils_begin(uart_ctrl_config8)
      `uvm_field_object(apb_cfg8, UVM_DEFAULT)
      `uvm_field_object(uart_cfg8, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config8");
    super.new(name);
    uart_cfg8 = uart_config8::type_id::create("uart_cfg8");
    apb_cfg8 = apb_config8::type_id::create("apb_cfg8"); 
  endfunction : new

endclass : uart_ctrl_config8

//================================================================
class default_uart_ctrl_config8 extends uart_ctrl_config8;

  `uvm_object_utils(default_uart_ctrl_config8)

  function new(string name = "default_uart_ctrl_config8");
    super.new(name);
    uart_cfg8 = uart_config8::type_id::create("uart_cfg8");
    apb_cfg8 = apb_config8::type_id::create("apb_cfg8"); 
    apb_cfg8.add_slave8("slave08", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg8.add_master8("master8", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config8

`endif // UART_CTRL_CONFIG_SV8
