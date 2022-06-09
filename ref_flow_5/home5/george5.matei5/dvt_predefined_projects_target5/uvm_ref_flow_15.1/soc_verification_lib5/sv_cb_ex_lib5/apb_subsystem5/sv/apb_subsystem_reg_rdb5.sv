/*---------------------------------------------------------------------
File5 name   : apb_subsystem_reg_rdb5.sv
Title5       : Reg5 Mem5 data base
Project5     :
Created5     :
Description5 : reg data base for APB5 Subsystem5
Notes5       :
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map5 definition5
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c5 extends uvm_reg_block;

  //rand uart_ctrl_rf_c5 uart0_rf5;
  //rand uart_ctrl_rf_c5 uart1_rf5;
  rand uart_ctrl_reg_model_c5 uart0_rm5;
  rand uart_ctrl_reg_model_c5 uart1_rm5;
  rand spi_regfile5 spi_rf5;
  rand gpio_regfile5 gpio_rf5;

  function void build();
    // Now5 define address mappings5
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf5 = uart_ctrl_rf_c5::type_id::create("uart0_rf5", , get_full_name());
    uart0_rf5.configure(this, "rf05");
    uart0_rf5.build();
    uart0_rf5.lock_model();
    default_map.add_submap(uart0_rf5.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model5");
    uart1_rf5 = uart_ctrl_rf_c5::type_id::create("uart1_rf5", , get_full_name());
    uart1_rf5.configure(this, "rf15");
    uart1_rf5.build();
    uart1_rf5.lock_model();
    default_map.add_submap(uart1_rf5.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm5 = uart_ctrl_reg_model_c5::type_id::create("uart0_rm5", , get_full_name());
    uart0_rm5.configure(this, "rf05");
    uart0_rm5.build();
    uart0_rm5.lock_model();
    default_map.add_submap(uart0_rm5.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model5");
    uart1_rm5 = uart_ctrl_reg_model_c5::type_id::create("uart1_rm5", , get_full_name());
    uart1_rm5.configure(this, "rf15");
    uart1_rm5.build();
    uart1_rm5.lock_model();
    default_map.add_submap(uart1_rm5.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model15");

    spi_rf5 = spi_regfile5::type_id::create("spi_rf5", , get_full_name());
    spi_rf5.configure(this, "rf25");
    spi_rf5.build();
    spi_rf5.lock_model();
    default_map.add_submap(spi_rf5.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c5");
    gpio_rf5 = gpio_regfile5::type_id::create("gpio_rf5", , get_full_name());
    gpio_rf5.configure(this, "rf35");
    gpio_rf5.build();
    gpio_rf5.lock_model();
    default_map.add_submap(gpio_rf5.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c5");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c5)

  function new(input string name="unnamed5-apb_ss_reg_model_c5");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c5

