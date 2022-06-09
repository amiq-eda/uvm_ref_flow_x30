/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_config5.svh
Title5       : UART5 Controller5 configuration
Project5     :
Created5     :
Description5 : This5 file contains5 multiple configuration classes5:
                apb_config5
                   master_config5
                   slave_configs5[N]
                uart_config5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV5
`define UART_CTRL_CONFIG_SV5

// UART5 Controller5 Configuration5 Class5
class uart_ctrl_config5 extends uvm_object;

  apb_config5 apb_cfg5;
  uart_config5 uart_cfg5;

  `uvm_object_utils_begin(uart_ctrl_config5)
      `uvm_field_object(apb_cfg5, UVM_DEFAULT)
      `uvm_field_object(uart_cfg5, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config5");
    super.new(name);
    uart_cfg5 = uart_config5::type_id::create("uart_cfg5");
    apb_cfg5 = apb_config5::type_id::create("apb_cfg5"); 
  endfunction : new

endclass : uart_ctrl_config5

//================================================================
class default_uart_ctrl_config5 extends uart_ctrl_config5;

  `uvm_object_utils(default_uart_ctrl_config5)

  function new(string name = "default_uart_ctrl_config5");
    super.new(name);
    uart_cfg5 = uart_config5::type_id::create("uart_cfg5");
    apb_cfg5 = apb_config5::type_id::create("apb_cfg5"); 
    apb_cfg5.add_slave5("slave05", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg5.add_master5("master5", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config5

`endif // UART_CTRL_CONFIG_SV5
