/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_config12.svh
Title12       : UART12 Controller12 configuration
Project12     :
Created12     :
Description12 : This12 file contains12 multiple configuration classes12:
                apb_config12
                   master_config12
                   slave_configs12[N]
                uart_config12
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV12
`define UART_CTRL_CONFIG_SV12

// UART12 Controller12 Configuration12 Class12
class uart_ctrl_config12 extends uvm_object;

  apb_config12 apb_cfg12;
  uart_config12 uart_cfg12;

  `uvm_object_utils_begin(uart_ctrl_config12)
      `uvm_field_object(apb_cfg12, UVM_DEFAULT)
      `uvm_field_object(uart_cfg12, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config12");
    super.new(name);
    uart_cfg12 = uart_config12::type_id::create("uart_cfg12");
    apb_cfg12 = apb_config12::type_id::create("apb_cfg12"); 
  endfunction : new

endclass : uart_ctrl_config12

//================================================================
class default_uart_ctrl_config12 extends uart_ctrl_config12;

  `uvm_object_utils(default_uart_ctrl_config12)

  function new(string name = "default_uart_ctrl_config12");
    super.new(name);
    uart_cfg12 = uart_config12::type_id::create("uart_cfg12");
    apb_cfg12 = apb_config12::type_id::create("apb_cfg12"); 
    apb_cfg12.add_slave12("slave012", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg12.add_master12("master12", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config12

`endif // UART_CTRL_CONFIG_SV12
