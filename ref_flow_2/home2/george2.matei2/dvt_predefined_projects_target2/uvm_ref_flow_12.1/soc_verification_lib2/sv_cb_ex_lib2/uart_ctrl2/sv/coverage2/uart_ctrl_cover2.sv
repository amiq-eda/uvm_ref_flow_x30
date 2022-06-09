/*-------------------------------------------------------------------------
File2 name   : uart_cover2.sv
Title2       : APB2<>UART2 coverage2 collection2
Project2     :
Created2     :
Description2 : Collects2 coverage2 around2 the UART2 DUT
            : 
----------------------------------------------------------------------
Copyright2 2007 (c) Cadence2 Design2 Systems2, Inc2. All Rights2 Reserved2.
----------------------------------------------------------------------*/

class uart_ctrl_cover2 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if2 vif2;
  uart_pkg2::uart_config2 uart_cfg2;

  event tx_fifo_ptr_change2;
  event rx_fifo_ptr_change2;


  // Required2 macro2 for UVM automation2 and utilities2
  `uvm_component_utils(uart_ctrl_cover2)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage2();
      collect_rx_coverage2();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if2)::get(this, get_full_name(),"vif2", vif2))
      `uvm_fatal("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
  endfunction : connect_phase

  virtual task collect_tx_coverage2();
    // --------------------------------
    // Extract2 & re-arrange2 to give2 a more useful2 input to covergroups2
    // --------------------------------
    // Calculate2 percentage2 fill2 level of TX2 FIFO
    forever begin
      @(vif2.tx_fifo_ptr2)
    //do any processing here2
      -> tx_fifo_ptr_change2;
    end  
  endtask : collect_tx_coverage2

  virtual task collect_rx_coverage2();
    // --------------------------------
    // Extract2 & re-arrange2 to give2 a more useful2 input to covergroups2
    // --------------------------------
    // Calculate2 percentage2 fill2 level of RX2 FIFO
    forever begin
      @(vif2.rx_fifo_ptr2)
    //do any processing here2
      -> rx_fifo_ptr_change2;
    end  
  endtask : collect_rx_coverage2

  // --------------------------------
  // Covergroup2 definitions2
  // --------------------------------

  // DUT TX2 FIFO covergroup
  covergroup dut_tx_fifo_cg2 @(tx_fifo_ptr_change2);
    tx_level2              : coverpoint vif2.tx_fifo_ptr2 {
                             bins EMPTY2 = {0};
                             bins HALF_FULL2 = {[7:10]};
                             bins FULL2 = {[13:15]};
                            }
  endgroup


  // DUT RX2 FIFO covergroup
  covergroup dut_rx_fifo_cg2 @(rx_fifo_ptr_change2);
    rx_level2              : coverpoint vif2.rx_fifo_ptr2 {
                             bins EMPTY2 = {0};
                             bins HALF_FULL2 = {[7:10]};
                             bins FULL2 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg2 = new();
    dut_rx_fifo_cg2.set_inst_name ("dut_rx_fifo_cg2");

    dut_tx_fifo_cg2 = new();
    dut_tx_fifo_cg2.set_inst_name ("dut_tx_fifo_cg2");

  endfunction
  
endclass : uart_ctrl_cover2
