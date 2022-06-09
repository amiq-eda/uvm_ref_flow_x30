/*---------------------------------------------------------------------
File28 name   : apb_subsystem_reg_rdb28.sv
Title28       : Reg28 Mem28 data base
Project28     :
Created28     :
Description28 : reg data base for APB28 Subsystem28
Notes28       :
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map28 definition28
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c28 extends uvm_reg_block;

  //rand uart_ctrl_rf_c28 uart0_rf28;
  //rand uart_ctrl_rf_c28 uart1_rf28;
  rand uart_ctrl_reg_model_c28 uart0_rm28;
  rand uart_ctrl_reg_model_c28 uart1_rm28;
  rand spi_regfile28 spi_rf28;
  rand gpio_regfile28 gpio_rf28;

  function void build();
    // Now28 define address mappings28
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf28 = uart_ctrl_rf_c28::type_id::create("uart0_rf28", , get_full_name());
    uart0_rf28.configure(this, "rf028");
    uart0_rf28.build();
    uart0_rf28.lock_model();
    default_map.add_submap(uart0_rf28.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model28");
    uart1_rf28 = uart_ctrl_rf_c28::type_id::create("uart1_rf28", , get_full_name());
    uart1_rf28.configure(this, "rf128");
    uart1_rf28.build();
    uart1_rf28.lock_model();
    default_map.add_submap(uart1_rf28.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm28 = uart_ctrl_reg_model_c28::type_id::create("uart0_rm28", , get_full_name());
    uart0_rm28.configure(this, "rf028");
    uart0_rm28.build();
    uart0_rm28.lock_model();
    default_map.add_submap(uart0_rm28.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model28");
    uart1_rm28 = uart_ctrl_reg_model_c28::type_id::create("uart1_rm28", , get_full_name());
    uart1_rm28.configure(this, "rf128");
    uart1_rm28.build();
    uart1_rm28.lock_model();
    default_map.add_submap(uart1_rm28.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model128");

    spi_rf28 = spi_regfile28::type_id::create("spi_rf28", , get_full_name());
    spi_rf28.configure(this, "rf228");
    spi_rf28.build();
    spi_rf28.lock_model();
    default_map.add_submap(spi_rf28.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c28");
    gpio_rf28 = gpio_regfile28::type_id::create("gpio_rf28", , get_full_name());
    gpio_rf28.configure(this, "rf328");
    gpio_rf28.build();
    gpio_rf28.lock_model();
    default_map.add_submap(gpio_rf28.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c28");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c28)

  function new(input string name="unnamed28-apb_ss_reg_model_c28");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c28

