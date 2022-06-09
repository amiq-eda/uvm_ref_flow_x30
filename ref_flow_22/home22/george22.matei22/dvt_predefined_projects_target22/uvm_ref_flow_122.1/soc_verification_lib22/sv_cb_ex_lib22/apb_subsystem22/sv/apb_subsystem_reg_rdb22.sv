/*---------------------------------------------------------------------
File22 name   : apb_subsystem_reg_rdb22.sv
Title22       : Reg22 Mem22 data base
Project22     :
Created22     :
Description22 : reg data base for APB22 Subsystem22
Notes22       :
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map22 definition22
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c22 extends uvm_reg_block;

  //rand uart_ctrl_rf_c22 uart0_rf22;
  //rand uart_ctrl_rf_c22 uart1_rf22;
  rand uart_ctrl_reg_model_c22 uart0_rm22;
  rand uart_ctrl_reg_model_c22 uart1_rm22;
  rand spi_regfile22 spi_rf22;
  rand gpio_regfile22 gpio_rf22;

  function void build();
    // Now22 define address mappings22
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf22 = uart_ctrl_rf_c22::type_id::create("uart0_rf22", , get_full_name());
    uart0_rf22.configure(this, "rf022");
    uart0_rf22.build();
    uart0_rf22.lock_model();
    default_map.add_submap(uart0_rf22.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model22");
    uart1_rf22 = uart_ctrl_rf_c22::type_id::create("uart1_rf22", , get_full_name());
    uart1_rf22.configure(this, "rf122");
    uart1_rf22.build();
    uart1_rf22.lock_model();
    default_map.add_submap(uart1_rf22.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm22 = uart_ctrl_reg_model_c22::type_id::create("uart0_rm22", , get_full_name());
    uart0_rm22.configure(this, "rf022");
    uart0_rm22.build();
    uart0_rm22.lock_model();
    default_map.add_submap(uart0_rm22.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model22");
    uart1_rm22 = uart_ctrl_reg_model_c22::type_id::create("uart1_rm22", , get_full_name());
    uart1_rm22.configure(this, "rf122");
    uart1_rm22.build();
    uart1_rm22.lock_model();
    default_map.add_submap(uart1_rm22.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model122");

    spi_rf22 = spi_regfile22::type_id::create("spi_rf22", , get_full_name());
    spi_rf22.configure(this, "rf222");
    spi_rf22.build();
    spi_rf22.lock_model();
    default_map.add_submap(spi_rf22.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c22");
    gpio_rf22 = gpio_regfile22::type_id::create("gpio_rf22", , get_full_name());
    gpio_rf22.configure(this, "rf322");
    gpio_rf22.build();
    gpio_rf22.lock_model();
    default_map.add_submap(gpio_rf22.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c22");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c22)

  function new(input string name="unnamed22-apb_ss_reg_model_c22");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c22

