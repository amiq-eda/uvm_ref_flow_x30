/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_config19.svh
Title19       : UART19 Controller19 configuration
Project19     :
Created19     :
Description19 : This19 file contains19 multiple configuration classes19:
                apb_config19
                   master_config19
                   slave_configs19[N]
                uart_config19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV19
`define UART_CTRL_CONFIG_SV19

// UART19 Controller19 Configuration19 Class19
class uart_ctrl_config19 extends uvm_object;

  apb_config19 apb_cfg19;
  uart_config19 uart_cfg19;

  `uvm_object_utils_begin(uart_ctrl_config19)
      `uvm_field_object(apb_cfg19, UVM_DEFAULT)
      `uvm_field_object(uart_cfg19, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config19");
    super.new(name);
    uart_cfg19 = uart_config19::type_id::create("uart_cfg19");
    apb_cfg19 = apb_config19::type_id::create("apb_cfg19"); 
  endfunction : new

endclass : uart_ctrl_config19

//================================================================
class default_uart_ctrl_config19 extends uart_ctrl_config19;

  `uvm_object_utils(default_uart_ctrl_config19)

  function new(string name = "default_uart_ctrl_config19");
    super.new(name);
    uart_cfg19 = uart_config19::type_id::create("uart_cfg19");
    apb_cfg19 = apb_config19::type_id::create("apb_cfg19"); 
    apb_cfg19.add_slave19("slave019", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg19.add_master19("master19", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config19

`endif // UART_CTRL_CONFIG_SV19
