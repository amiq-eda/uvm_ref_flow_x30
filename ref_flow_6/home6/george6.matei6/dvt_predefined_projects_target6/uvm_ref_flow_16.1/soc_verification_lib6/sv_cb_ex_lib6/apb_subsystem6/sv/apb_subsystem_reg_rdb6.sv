/*---------------------------------------------------------------------
File6 name   : apb_subsystem_reg_rdb6.sv
Title6       : Reg6 Mem6 data base
Project6     :
Created6     :
Description6 : reg data base for APB6 Subsystem6
Notes6       :
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map6 definition6
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c6 extends uvm_reg_block;

  //rand uart_ctrl_rf_c6 uart0_rf6;
  //rand uart_ctrl_rf_c6 uart1_rf6;
  rand uart_ctrl_reg_model_c6 uart0_rm6;
  rand uart_ctrl_reg_model_c6 uart1_rm6;
  rand spi_regfile6 spi_rf6;
  rand gpio_regfile6 gpio_rf6;

  function void build();
    // Now6 define address mappings6
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf6 = uart_ctrl_rf_c6::type_id::create("uart0_rf6", , get_full_name());
    uart0_rf6.configure(this, "rf06");
    uart0_rf6.build();
    uart0_rf6.lock_model();
    default_map.add_submap(uart0_rf6.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model6");
    uart1_rf6 = uart_ctrl_rf_c6::type_id::create("uart1_rf6", , get_full_name());
    uart1_rf6.configure(this, "rf16");
    uart1_rf6.build();
    uart1_rf6.lock_model();
    default_map.add_submap(uart1_rf6.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm6 = uart_ctrl_reg_model_c6::type_id::create("uart0_rm6", , get_full_name());
    uart0_rm6.configure(this, "rf06");
    uart0_rm6.build();
    uart0_rm6.lock_model();
    default_map.add_submap(uart0_rm6.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model6");
    uart1_rm6 = uart_ctrl_reg_model_c6::type_id::create("uart1_rm6", , get_full_name());
    uart1_rm6.configure(this, "rf16");
    uart1_rm6.build();
    uart1_rm6.lock_model();
    default_map.add_submap(uart1_rm6.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model16");

    spi_rf6 = spi_regfile6::type_id::create("spi_rf6", , get_full_name());
    spi_rf6.configure(this, "rf26");
    spi_rf6.build();
    spi_rf6.lock_model();
    default_map.add_submap(spi_rf6.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c6");
    gpio_rf6 = gpio_regfile6::type_id::create("gpio_rf6", , get_full_name());
    gpio_rf6.configure(this, "rf36");
    gpio_rf6.build();
    gpio_rf6.lock_model();
    default_map.add_submap(gpio_rf6.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c6");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c6)

  function new(input string name="unnamed6-apb_ss_reg_model_c6");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c6

