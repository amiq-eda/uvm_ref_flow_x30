/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_config6.svh
Title6       : UART6 Controller6 configuration
Project6     :
Created6     :
Description6 : This6 file contains6 multiple configuration classes6:
                apb_config6
                   master_config6
                   slave_configs6[N]
                uart_config6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV6
`define UART_CTRL_CONFIG_SV6

// UART6 Controller6 Configuration6 Class6
class uart_ctrl_config6 extends uvm_object;

  apb_config6 apb_cfg6;
  uart_config6 uart_cfg6;

  `uvm_object_utils_begin(uart_ctrl_config6)
      `uvm_field_object(apb_cfg6, UVM_DEFAULT)
      `uvm_field_object(uart_cfg6, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config6");
    super.new(name);
    uart_cfg6 = uart_config6::type_id::create("uart_cfg6");
    apb_cfg6 = apb_config6::type_id::create("apb_cfg6"); 
  endfunction : new

endclass : uart_ctrl_config6

//================================================================
class default_uart_ctrl_config6 extends uart_ctrl_config6;

  `uvm_object_utils(default_uart_ctrl_config6)

  function new(string name = "default_uart_ctrl_config6");
    super.new(name);
    uart_cfg6 = uart_config6::type_id::create("uart_cfg6");
    apb_cfg6 = apb_config6::type_id::create("apb_cfg6"); 
    apb_cfg6.add_slave6("slave06", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg6.add_master6("master6", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config6

`endif // UART_CTRL_CONFIG_SV6
