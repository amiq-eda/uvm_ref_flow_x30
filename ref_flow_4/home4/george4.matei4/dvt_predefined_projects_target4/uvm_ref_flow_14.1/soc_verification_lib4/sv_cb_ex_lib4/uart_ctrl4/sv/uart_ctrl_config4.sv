/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_config4.svh
Title4       : UART4 Controller4 configuration
Project4     :
Created4     :
Description4 : This4 file contains4 multiple configuration classes4:
                apb_config4
                   master_config4
                   slave_configs4[N]
                uart_config4
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV4
`define UART_CTRL_CONFIG_SV4

// UART4 Controller4 Configuration4 Class4
class uart_ctrl_config4 extends uvm_object;

  apb_config4 apb_cfg4;
  uart_config4 uart_cfg4;

  `uvm_object_utils_begin(uart_ctrl_config4)
      `uvm_field_object(apb_cfg4, UVM_DEFAULT)
      `uvm_field_object(uart_cfg4, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config4");
    super.new(name);
    uart_cfg4 = uart_config4::type_id::create("uart_cfg4");
    apb_cfg4 = apb_config4::type_id::create("apb_cfg4"); 
  endfunction : new

endclass : uart_ctrl_config4

//================================================================
class default_uart_ctrl_config4 extends uart_ctrl_config4;

  `uvm_object_utils(default_uart_ctrl_config4)

  function new(string name = "default_uart_ctrl_config4");
    super.new(name);
    uart_cfg4 = uart_config4::type_id::create("uart_cfg4");
    apb_cfg4 = apb_config4::type_id::create("apb_cfg4"); 
    apb_cfg4.add_slave4("slave04", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg4.add_master4("master4", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config4

`endif // UART_CTRL_CONFIG_SV4
