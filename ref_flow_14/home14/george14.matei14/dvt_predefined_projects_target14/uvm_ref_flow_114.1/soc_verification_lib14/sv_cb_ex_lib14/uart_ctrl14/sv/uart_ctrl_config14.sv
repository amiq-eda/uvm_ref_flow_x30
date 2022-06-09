/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_config14.svh
Title14       : UART14 Controller14 configuration
Project14     :
Created14     :
Description14 : This14 file contains14 multiple configuration classes14:
                apb_config14
                   master_config14
                   slave_configs14[N]
                uart_config14
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV14
`define UART_CTRL_CONFIG_SV14

// UART14 Controller14 Configuration14 Class14
class uart_ctrl_config14 extends uvm_object;

  apb_config14 apb_cfg14;
  uart_config14 uart_cfg14;

  `uvm_object_utils_begin(uart_ctrl_config14)
      `uvm_field_object(apb_cfg14, UVM_DEFAULT)
      `uvm_field_object(uart_cfg14, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config14");
    super.new(name);
    uart_cfg14 = uart_config14::type_id::create("uart_cfg14");
    apb_cfg14 = apb_config14::type_id::create("apb_cfg14"); 
  endfunction : new

endclass : uart_ctrl_config14

//================================================================
class default_uart_ctrl_config14 extends uart_ctrl_config14;

  `uvm_object_utils(default_uart_ctrl_config14)

  function new(string name = "default_uart_ctrl_config14");
    super.new(name);
    uart_cfg14 = uart_config14::type_id::create("uart_cfg14");
    apb_cfg14 = apb_config14::type_id::create("apb_cfg14"); 
    apb_cfg14.add_slave14("slave014", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg14.add_master14("master14", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config14

`endif // UART_CTRL_CONFIG_SV14
