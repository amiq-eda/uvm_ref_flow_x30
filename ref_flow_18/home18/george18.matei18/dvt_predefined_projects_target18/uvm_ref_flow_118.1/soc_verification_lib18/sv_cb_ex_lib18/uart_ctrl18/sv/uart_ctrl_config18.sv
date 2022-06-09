/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_config18.svh
Title18       : UART18 Controller18 configuration
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


`ifndef UART_CTRL_CONFIG_SV18
`define UART_CTRL_CONFIG_SV18

// UART18 Controller18 Configuration18 Class18
class uart_ctrl_config18 extends uvm_object;

  apb_config18 apb_cfg18;
  uart_config18 uart_cfg18;

  `uvm_object_utils_begin(uart_ctrl_config18)
      `uvm_field_object(apb_cfg18, UVM_DEFAULT)
      `uvm_field_object(uart_cfg18, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config18");
    super.new(name);
    uart_cfg18 = uart_config18::type_id::create("uart_cfg18");
    apb_cfg18 = apb_config18::type_id::create("apb_cfg18"); 
  endfunction : new

endclass : uart_ctrl_config18

//================================================================
class default_uart_ctrl_config18 extends uart_ctrl_config18;

  `uvm_object_utils(default_uart_ctrl_config18)

  function new(string name = "default_uart_ctrl_config18");
    super.new(name);
    uart_cfg18 = uart_config18::type_id::create("uart_cfg18");
    apb_cfg18 = apb_config18::type_id::create("apb_cfg18"); 
    apb_cfg18.add_slave18("slave018", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg18.add_master18("master18", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config18

`endif // UART_CTRL_CONFIG_SV18
