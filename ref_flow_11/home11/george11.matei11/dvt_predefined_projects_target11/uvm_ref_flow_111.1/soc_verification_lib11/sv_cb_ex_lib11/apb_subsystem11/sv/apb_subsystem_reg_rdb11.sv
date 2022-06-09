/*---------------------------------------------------------------------
File11 name   : apb_subsystem_reg_rdb11.sv
Title11       : Reg11 Mem11 data base
Project11     :
Created11     :
Description11 : reg data base for APB11 Subsystem11
Notes11       :
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map11 definition11
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c11 extends uvm_reg_block;

  //rand uart_ctrl_rf_c11 uart0_rf11;
  //rand uart_ctrl_rf_c11 uart1_rf11;
  rand uart_ctrl_reg_model_c11 uart0_rm11;
  rand uart_ctrl_reg_model_c11 uart1_rm11;
  rand spi_regfile11 spi_rf11;
  rand gpio_regfile11 gpio_rf11;

  function void build();
    // Now11 define address mappings11
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf11 = uart_ctrl_rf_c11::type_id::create("uart0_rf11", , get_full_name());
    uart0_rf11.configure(this, "rf011");
    uart0_rf11.build();
    uart0_rf11.lock_model();
    default_map.add_submap(uart0_rf11.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model11");
    uart1_rf11 = uart_ctrl_rf_c11::type_id::create("uart1_rf11", , get_full_name());
    uart1_rf11.configure(this, "rf111");
    uart1_rf11.build();
    uart1_rf11.lock_model();
    default_map.add_submap(uart1_rf11.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm11 = uart_ctrl_reg_model_c11::type_id::create("uart0_rm11", , get_full_name());
    uart0_rm11.configure(this, "rf011");
    uart0_rm11.build();
    uart0_rm11.lock_model();
    default_map.add_submap(uart0_rm11.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model11");
    uart1_rm11 = uart_ctrl_reg_model_c11::type_id::create("uart1_rm11", , get_full_name());
    uart1_rm11.configure(this, "rf111");
    uart1_rm11.build();
    uart1_rm11.lock_model();
    default_map.add_submap(uart1_rm11.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model111");

    spi_rf11 = spi_regfile11::type_id::create("spi_rf11", , get_full_name());
    spi_rf11.configure(this, "rf211");
    spi_rf11.build();
    spi_rf11.lock_model();
    default_map.add_submap(spi_rf11.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c11");
    gpio_rf11 = gpio_regfile11::type_id::create("gpio_rf11", , get_full_name());
    gpio_rf11.configure(this, "rf311");
    gpio_rf11.build();
    gpio_rf11.lock_model();
    default_map.add_submap(gpio_rf11.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c11");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c11)

  function new(input string name="unnamed11-apb_ss_reg_model_c11");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c11

