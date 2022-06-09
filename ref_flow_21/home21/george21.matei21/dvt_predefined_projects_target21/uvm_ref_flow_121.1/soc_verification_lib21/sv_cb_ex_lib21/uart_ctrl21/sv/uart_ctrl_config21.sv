/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_config21.svh
Title21       : UART21 Controller21 configuration
Project21     :
Created21     :
Description21 : This21 file contains21 multiple configuration classes21:
                apb_config21
                   master_config21
                   slave_configs21[N]
                uart_config21
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV21
`define UART_CTRL_CONFIG_SV21

// UART21 Controller21 Configuration21 Class21
class uart_ctrl_config21 extends uvm_object;

  apb_config21 apb_cfg21;
  uart_config21 uart_cfg21;

  `uvm_object_utils_begin(uart_ctrl_config21)
      `uvm_field_object(apb_cfg21, UVM_DEFAULT)
      `uvm_field_object(uart_cfg21, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config21");
    super.new(name);
    uart_cfg21 = uart_config21::type_id::create("uart_cfg21");
    apb_cfg21 = apb_config21::type_id::create("apb_cfg21"); 
  endfunction : new

endclass : uart_ctrl_config21

//================================================================
class default_uart_ctrl_config21 extends uart_ctrl_config21;

  `uvm_object_utils(default_uart_ctrl_config21)

  function new(string name = "default_uart_ctrl_config21");
    super.new(name);
    uart_cfg21 = uart_config21::type_id::create("uart_cfg21");
    apb_cfg21 = apb_config21::type_id::create("apb_cfg21"); 
    apb_cfg21.add_slave21("slave021", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    apb_cfg21.add_master21("master21", UVM_ACTIVE);
  endfunction

endclass : default_uart_ctrl_config21

`endif // UART_CTRL_CONFIG_SV21
