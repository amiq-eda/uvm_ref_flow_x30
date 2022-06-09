/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_config27.svh
Title27       : UART27 Controller27 configuration
Project27     :
Created27     :
Description27 : This27 file contains27 multiple configuration classes27:
                apb_config27
                   master_config27
                   slave_configs27[N]
                uart_config27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV27
`define UART_CTRL_CONFIG_SV27

// UART27 Controller27 Configuration27 Class27
class uart_ctrl_config27 extends uvm_object;

  apb_config27 apb_cfg27;
  uart_config27 uart_cfg27;

  `uvm_object_utils_begin(uart_ctrl_config27)
      `uvm_field_object(apb_cfg27, UVM_DEFAULT)
      `uvm_field_object(uart_cfg27, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config27");
    super.new(name);
    uart_cfg27 = uart_config27::type_id::create("uart_cfg27");
    apb_cfg27 = apb_config27::type_id::create("apb_cfg27"); 
  endfunction : new

endclass : uart_ctrl_config27

//================================================================
class default_uart_ctrl_config27 extends uart_ctrl_config27;

  `uvm_object_utils(default_uart_ctrl_config27)

  function new(string name = "default_uart_ctrl_config27");
    super.new(name);
    uart_cfg27 = uart_config27::type_id::create("uart_cfg27");
    apb_cfg27 = apb_config27::type_id::create("apb_cfg27"); 
    apb_cfg27.add_slave27("slave027", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg27.add_master27("master27", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config27

`endif // UART_CTRL_CONFIG_SV27
