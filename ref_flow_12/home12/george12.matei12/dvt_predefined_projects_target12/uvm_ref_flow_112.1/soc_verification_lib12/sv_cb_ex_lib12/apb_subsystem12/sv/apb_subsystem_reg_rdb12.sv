/*---------------------------------------------------------------------
File12 name   : apb_subsystem_reg_rdb12.sv
Title12       : Reg12 Mem12 data base
Project12     :
Created12     :
Description12 : reg data base for APB12 Subsystem12
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map12 definition12
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c12 extends uvm_reg_block;

  //rand uart_ctrl_rf_c12 uart0_rf12;
  //rand uart_ctrl_rf_c12 uart1_rf12;
  rand uart_ctrl_reg_model_c12 uart0_rm12;
  rand uart_ctrl_reg_model_c12 uart1_rm12;
  rand spi_regfile12 spi_rf12;
  rand gpio_regfile12 gpio_rf12;

  function void build();
    // Now12 define address mappings12
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf12 = uart_ctrl_rf_c12::type_id::create("uart0_rf12", , get_full_name());
    uart0_rf12.configure(this, "rf012");
    uart0_rf12.build();
    uart0_rf12.lock_model();
    default_map.add_submap(uart0_rf12.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model12");
    uart1_rf12 = uart_ctrl_rf_c12::type_id::create("uart1_rf12", , get_full_name());
    uart1_rf12.configure(this, "rf112");
    uart1_rf12.build();
    uart1_rf12.lock_model();
    default_map.add_submap(uart1_rf12.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm12 = uart_ctrl_reg_model_c12::type_id::create("uart0_rm12", , get_full_name());
    uart0_rm12.configure(this, "rf012");
    uart0_rm12.build();
    uart0_rm12.lock_model();
    default_map.add_submap(uart0_rm12.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model12");
    uart1_rm12 = uart_ctrl_reg_model_c12::type_id::create("uart1_rm12", , get_full_name());
    uart1_rm12.configure(this, "rf112");
    uart1_rm12.build();
    uart1_rm12.lock_model();
    default_map.add_submap(uart1_rm12.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model112");

    spi_rf12 = spi_regfile12::type_id::create("spi_rf12", , get_full_name());
    spi_rf12.configure(this, "rf212");
    spi_rf12.build();
    spi_rf12.lock_model();
    default_map.add_submap(spi_rf12.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c12");
    gpio_rf12 = gpio_regfile12::type_id::create("gpio_rf12", , get_full_name());
    gpio_rf12.configure(this, "rf312");
    gpio_rf12.build();
    gpio_rf12.lock_model();
    default_map.add_submap(gpio_rf12.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c12");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c12)

  function new(input string name="unnamed12-apb_ss_reg_model_c12");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c12

