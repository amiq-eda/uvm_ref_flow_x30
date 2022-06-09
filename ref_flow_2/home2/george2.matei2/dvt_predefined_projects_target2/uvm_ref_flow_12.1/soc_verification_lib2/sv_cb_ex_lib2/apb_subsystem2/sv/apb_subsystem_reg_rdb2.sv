/*---------------------------------------------------------------------
File2 name   : apb_subsystem_reg_rdb2.sv
Title2       : Reg2 Mem2 data base
Project2     :
Created2     :
Description2 : reg data base for APB2 Subsystem2
Notes2       :
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map2 definition2
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c2 extends uvm_reg_block;

  //rand uart_ctrl_rf_c2 uart0_rf2;
  //rand uart_ctrl_rf_c2 uart1_rf2;
  rand uart_ctrl_reg_model_c2 uart0_rm2;
  rand uart_ctrl_reg_model_c2 uart1_rm2;
  rand spi_regfile2 spi_rf2;
  rand gpio_regfile2 gpio_rf2;

  function void build();
    // Now2 define address mappings2
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf2 = uart_ctrl_rf_c2::type_id::create("uart0_rf2", , get_full_name());
    uart0_rf2.configure(this, "rf02");
    uart0_rf2.build();
    uart0_rf2.lock_model();
    default_map.add_submap(uart0_rf2.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model2");
    uart1_rf2 = uart_ctrl_rf_c2::type_id::create("uart1_rf2", , get_full_name());
    uart1_rf2.configure(this, "rf12");
    uart1_rf2.build();
    uart1_rf2.lock_model();
    default_map.add_submap(uart1_rf2.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm2 = uart_ctrl_reg_model_c2::type_id::create("uart0_rm2", , get_full_name());
    uart0_rm2.configure(this, "rf02");
    uart0_rm2.build();
    uart0_rm2.lock_model();
    default_map.add_submap(uart0_rm2.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model2");
    uart1_rm2 = uart_ctrl_reg_model_c2::type_id::create("uart1_rm2", , get_full_name());
    uart1_rm2.configure(this, "rf12");
    uart1_rm2.build();
    uart1_rm2.lock_model();
    default_map.add_submap(uart1_rm2.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model12");

    spi_rf2 = spi_regfile2::type_id::create("spi_rf2", , get_full_name());
    spi_rf2.configure(this, "rf22");
    spi_rf2.build();
    spi_rf2.lock_model();
    default_map.add_submap(spi_rf2.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c2");
    gpio_rf2 = gpio_regfile2::type_id::create("gpio_rf2", , get_full_name());
    gpio_rf2.configure(this, "rf32");
    gpio_rf2.build();
    gpio_rf2.lock_model();
    default_map.add_submap(gpio_rf2.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c2");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c2)

  function new(input string name="unnamed2-apb_ss_reg_model_c2");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c2

