/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_config24.svh
Title24       : UART24 Controller24 configuration
Project24     :
Created24     :
Description24 : This24 file contains24 multiple configuration classes24:
                apb_config24
                   master_config24
                   slave_configs24[N]
                uart_config24
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV24
`define UART_CTRL_CONFIG_SV24

// UART24 Controller24 Configuration24 Class24
class uart_ctrl_config24 extends uvm_object;

  apb_config24 apb_cfg24;
  uart_config24 uart_cfg24;

  `uvm_object_utils_begin(uart_ctrl_config24)
      `uvm_field_object(apb_cfg24, UVM_DEFAULT)
      `uvm_field_object(uart_cfg24, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config24");
    super.new(name);
    uart_cfg24 = uart_config24::type_id::create("uart_cfg24");
    apb_cfg24 = apb_config24::type_id::create("apb_cfg24"); 
  endfunction : new

endclass : uart_ctrl_config24

//================================================================
class default_uart_ctrl_config24 extends uart_ctrl_config24;

  `uvm_object_utils(default_uart_ctrl_config24)

  function new(string name = "default_uart_ctrl_config24");
    super.new(name);
    uart_cfg24 = uart_config24::type_id::create("uart_cfg24");
    apb_cfg24 = apb_config24::type_id::create("apb_cfg24"); 
    apb_cfg24.add_slave24("slave024", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg24.add_master24("master24", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config24

`endif // UART_CTRL_CONFIG_SV24
