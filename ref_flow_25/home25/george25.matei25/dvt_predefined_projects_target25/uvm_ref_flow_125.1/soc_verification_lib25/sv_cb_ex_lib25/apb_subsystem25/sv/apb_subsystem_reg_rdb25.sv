/*---------------------------------------------------------------------
File25 name   : apb_subsystem_reg_rdb25.sv
Title25       : Reg25 Mem25 data base
Project25     :
Created25     :
Description25 : reg data base for APB25 Subsystem25
Notes25       :
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map25 definition25
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c25 extends uvm_reg_block;

  //rand uart_ctrl_rf_c25 uart0_rf25;
  //rand uart_ctrl_rf_c25 uart1_rf25;
  rand uart_ctrl_reg_model_c25 uart0_rm25;
  rand uart_ctrl_reg_model_c25 uart1_rm25;
  rand spi_regfile25 spi_rf25;
  rand gpio_regfile25 gpio_rf25;

  function void build();
    // Now25 define address mappings25
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf25 = uart_ctrl_rf_c25::type_id::create("uart0_rf25", , get_full_name());
    uart0_rf25.configure(this, "rf025");
    uart0_rf25.build();
    uart0_rf25.lock_model();
    default_map.add_submap(uart0_rf25.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model25");
    uart1_rf25 = uart_ctrl_rf_c25::type_id::create("uart1_rf25", , get_full_name());
    uart1_rf25.configure(this, "rf125");
    uart1_rf25.build();
    uart1_rf25.lock_model();
    default_map.add_submap(uart1_rf25.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm25 = uart_ctrl_reg_model_c25::type_id::create("uart0_rm25", , get_full_name());
    uart0_rm25.configure(this, "rf025");
    uart0_rm25.build();
    uart0_rm25.lock_model();
    default_map.add_submap(uart0_rm25.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model25");
    uart1_rm25 = uart_ctrl_reg_model_c25::type_id::create("uart1_rm25", , get_full_name());
    uart1_rm25.configure(this, "rf125");
    uart1_rm25.build();
    uart1_rm25.lock_model();
    default_map.add_submap(uart1_rm25.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model125");

    spi_rf25 = spi_regfile25::type_id::create("spi_rf25", , get_full_name());
    spi_rf25.configure(this, "rf225");
    spi_rf25.build();
    spi_rf25.lock_model();
    default_map.add_submap(spi_rf25.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c25");
    gpio_rf25 = gpio_regfile25::type_id::create("gpio_rf25", , get_full_name());
    gpio_rf25.configure(this, "rf325");
    gpio_rf25.build();
    gpio_rf25.lock_model();
    default_map.add_submap(gpio_rf25.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c25");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c25)

  function new(input string name="unnamed25-apb_ss_reg_model_c25");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c25

