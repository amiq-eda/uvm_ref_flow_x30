/*---------------------------------------------------------------------
File17 name   : apb_subsystem_reg_rdb17.sv
Title17       : Reg17 Mem17 data base
Project17     :
Created17     :
Description17 : reg data base for APB17 Subsystem17
Notes17       :
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map17 definition17
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c17 extends uvm_reg_block;

  //rand uart_ctrl_rf_c17 uart0_rf17;
  //rand uart_ctrl_rf_c17 uart1_rf17;
  rand uart_ctrl_reg_model_c17 uart0_rm17;
  rand uart_ctrl_reg_model_c17 uart1_rm17;
  rand spi_regfile17 spi_rf17;
  rand gpio_regfile17 gpio_rf17;

  function void build();
    // Now17 define address mappings17
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf17 = uart_ctrl_rf_c17::type_id::create("uart0_rf17", , get_full_name());
    uart0_rf17.configure(this, "rf017");
    uart0_rf17.build();
    uart0_rf17.lock_model();
    default_map.add_submap(uart0_rf17.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model17");
    uart1_rf17 = uart_ctrl_rf_c17::type_id::create("uart1_rf17", , get_full_name());
    uart1_rf17.configure(this, "rf117");
    uart1_rf17.build();
    uart1_rf17.lock_model();
    default_map.add_submap(uart1_rf17.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm17 = uart_ctrl_reg_model_c17::type_id::create("uart0_rm17", , get_full_name());
    uart0_rm17.configure(this, "rf017");
    uart0_rm17.build();
    uart0_rm17.lock_model();
    default_map.add_submap(uart0_rm17.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model17");
    uart1_rm17 = uart_ctrl_reg_model_c17::type_id::create("uart1_rm17", , get_full_name());
    uart1_rm17.configure(this, "rf117");
    uart1_rm17.build();
    uart1_rm17.lock_model();
    default_map.add_submap(uart1_rm17.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model117");

    spi_rf17 = spi_regfile17::type_id::create("spi_rf17", , get_full_name());
    spi_rf17.configure(this, "rf217");
    spi_rf17.build();
    spi_rf17.lock_model();
    default_map.add_submap(spi_rf17.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c17");
    gpio_rf17 = gpio_regfile17::type_id::create("gpio_rf17", , get_full_name());
    gpio_rf17.configure(this, "rf317");
    gpio_rf17.build();
    gpio_rf17.lock_model();
    default_map.add_submap(gpio_rf17.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c17");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c17)

  function new(input string name="unnamed17-apb_ss_reg_model_c17");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c17

