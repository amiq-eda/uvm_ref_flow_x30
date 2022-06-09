/*---------------------------------------------------------------------
File21 name   : apb_subsystem_reg_rdb21.sv
Title21       : Reg21 Mem21 data base
Project21     :
Created21     :
Description21 : reg data base for APB21 Subsystem21
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map21 definition21
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c21 extends uvm_reg_block;

  //rand uart_ctrl_rf_c21 uart0_rf21;
  //rand uart_ctrl_rf_c21 uart1_rf21;
  rand uart_ctrl_reg_model_c21 uart0_rm21;
  rand uart_ctrl_reg_model_c21 uart1_rm21;
  rand spi_regfile21 spi_rf21;
  rand gpio_regfile21 gpio_rf21;

  function void build();
    // Now21 define address mappings21
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf21 = uart_ctrl_rf_c21::type_id::create("uart0_rf21", , get_full_name());
    uart0_rf21.configure(this, "rf021");
    uart0_rf21.build();
    uart0_rf21.lock_model();
    default_map.add_submap(uart0_rf21.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model21");
    uart1_rf21 = uart_ctrl_rf_c21::type_id::create("uart1_rf21", , get_full_name());
    uart1_rf21.configure(this, "rf121");
    uart1_rf21.build();
    uart1_rf21.lock_model();
    default_map.add_submap(uart1_rf21.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm21 = uart_ctrl_reg_model_c21::type_id::create("uart0_rm21", , get_full_name());
    uart0_rm21.configure(this, "rf021");
    uart0_rm21.build();
    uart0_rm21.lock_model();
    default_map.add_submap(uart0_rm21.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model21");
    uart1_rm21 = uart_ctrl_reg_model_c21::type_id::create("uart1_rm21", , get_full_name());
    uart1_rm21.configure(this, "rf121");
    uart1_rm21.build();
    uart1_rm21.lock_model();
    default_map.add_submap(uart1_rm21.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model121");

    spi_rf21 = spi_regfile21::type_id::create("spi_rf21", , get_full_name());
    spi_rf21.configure(this, "rf221");
    spi_rf21.build();
    spi_rf21.lock_model();
    default_map.add_submap(spi_rf21.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c21");
    gpio_rf21 = gpio_regfile21::type_id::create("gpio_rf21", , get_full_name());
    gpio_rf21.configure(this, "rf321");
    gpio_rf21.build();
    gpio_rf21.lock_model();
    default_map.add_submap(gpio_rf21.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c21");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c21)

  function new(input string name="unnamed21-apb_ss_reg_model_c21");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c21

