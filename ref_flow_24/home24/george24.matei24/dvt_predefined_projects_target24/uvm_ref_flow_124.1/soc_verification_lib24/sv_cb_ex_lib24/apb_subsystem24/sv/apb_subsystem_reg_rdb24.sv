/*---------------------------------------------------------------------
File24 name   : apb_subsystem_reg_rdb24.sv
Title24       : Reg24 Mem24 data base
Project24     :
Created24     :
Description24 : reg data base for APB24 Subsystem24
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map24 definition24
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c24 extends uvm_reg_block;

  //rand uart_ctrl_rf_c24 uart0_rf24;
  //rand uart_ctrl_rf_c24 uart1_rf24;
  rand uart_ctrl_reg_model_c24 uart0_rm24;
  rand uart_ctrl_reg_model_c24 uart1_rm24;
  rand spi_regfile24 spi_rf24;
  rand gpio_regfile24 gpio_rf24;

  function void build();
    // Now24 define address mappings24
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf24 = uart_ctrl_rf_c24::type_id::create("uart0_rf24", , get_full_name());
    uart0_rf24.configure(this, "rf024");
    uart0_rf24.build();
    uart0_rf24.lock_model();
    default_map.add_submap(uart0_rf24.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model24");
    uart1_rf24 = uart_ctrl_rf_c24::type_id::create("uart1_rf24", , get_full_name());
    uart1_rf24.configure(this, "rf124");
    uart1_rf24.build();
    uart1_rf24.lock_model();
    default_map.add_submap(uart1_rf24.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm24 = uart_ctrl_reg_model_c24::type_id::create("uart0_rm24", , get_full_name());
    uart0_rm24.configure(this, "rf024");
    uart0_rm24.build();
    uart0_rm24.lock_model();
    default_map.add_submap(uart0_rm24.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model24");
    uart1_rm24 = uart_ctrl_reg_model_c24::type_id::create("uart1_rm24", , get_full_name());
    uart1_rm24.configure(this, "rf124");
    uart1_rm24.build();
    uart1_rm24.lock_model();
    default_map.add_submap(uart1_rm24.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model124");

    spi_rf24 = spi_regfile24::type_id::create("spi_rf24", , get_full_name());
    spi_rf24.configure(this, "rf224");
    spi_rf24.build();
    spi_rf24.lock_model();
    default_map.add_submap(spi_rf24.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c24");
    gpio_rf24 = gpio_regfile24::type_id::create("gpio_rf24", , get_full_name());
    gpio_rf24.configure(this, "rf324");
    gpio_rf24.build();
    gpio_rf24.lock_model();
    default_map.add_submap(gpio_rf24.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c24");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c24)

  function new(input string name="unnamed24-apb_ss_reg_model_c24");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c24

