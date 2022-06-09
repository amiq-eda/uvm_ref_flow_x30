/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_config29.svh
Title29       : UART29 Controller29 configuration
Project29     :
Created29     :
Description29 : This29 file contains29 multiple configuration classes29:
                apb_config29
                   master_config29
                   slave_configs29[N]
                uart_config29
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV29
`define UART_CTRL_CONFIG_SV29

// UART29 Controller29 Configuration29 Class29
class uart_ctrl_config29 extends uvm_object;

  apb_config29 apb_cfg29;
  uart_config29 uart_cfg29;

  `uvm_object_utils_begin(uart_ctrl_config29)
      `uvm_field_object(apb_cfg29, UVM_DEFAULT)
      `uvm_field_object(uart_cfg29, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config29");
    super.new(name);
    uart_cfg29 = uart_config29::type_id::create("uart_cfg29");
    apb_cfg29 = apb_config29::type_id::create("apb_cfg29"); 
  endfunction : new

endclass : uart_ctrl_config29

//================================================================
class default_uart_ctrl_config29 extends uart_ctrl_config29;

  `uvm_object_utils(default_uart_ctrl_config29)

  function new(string name = "default_uart_ctrl_config29");
    super.new(name);
    uart_cfg29 = uart_config29::type_id::create("uart_cfg29");
    apb_cfg29 = apb_config29::type_id::create("apb_cfg29"); 
    apb_cfg29.add_slave29("slave029", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg29.add_master29("master29", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config29

`endif // UART_CTRL_CONFIG_SV29
