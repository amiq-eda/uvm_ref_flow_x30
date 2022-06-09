/*-------------------------------------------------------------------------
File9 name   : uart_cover9.sv
Title9       : APB9<>UART9 coverage9 collection9
Project9     :
Created9     :
Description9 : Collects9 coverage9 around9 the UART9 DUT
            : 
----------------------------------------------------------------------
Copyright9 2007 (c) Cadence9 Design9 Systems9, Inc9. All Rights9 Reserved9.
----------------------------------------------------------------------*/

class uart_ctrl_cover9 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if9 vif9;
  uart_pkg9::uart_config9 uart_cfg9;

  event tx_fifo_ptr_change9;
  event rx_fifo_ptr_change9;


  // Required9 macro9 for UVM automation9 and utilities9
  `uvm_component_utils(uart_ctrl_cover9)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage9();
      collect_rx_coverage9();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if9)::get(this, get_full_name(),"vif9", vif9))
      `uvm_fatal("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
  endfunction : connect_phase

  virtual task collect_tx_coverage9();
    // --------------------------------
    // Extract9 & re-arrange9 to give9 a more useful9 input to covergroups9
    // --------------------------------
    // Calculate9 percentage9 fill9 level of TX9 FIFO
    forever begin
      @(vif9.tx_fifo_ptr9)
    //do any processing here9
      -> tx_fifo_ptr_change9;
    end  
  endtask : collect_tx_coverage9

  virtual task collect_rx_coverage9();
    // --------------------------------
    // Extract9 & re-arrange9 to give9 a more useful9 input to covergroups9
    // --------------------------------
    // Calculate9 percentage9 fill9 level of RX9 FIFO
    forever begin
      @(vif9.rx_fifo_ptr9)
    //do any processing here9
      -> rx_fifo_ptr_change9;
    end  
  endtask : collect_rx_coverage9

  // --------------------------------
  // Covergroup9 definitions9
  // --------------------------------

  // DUT TX9 FIFO covergroup
  covergroup dut_tx_fifo_cg9 @(tx_fifo_ptr_change9);
    tx_level9              : coverpoint vif9.tx_fifo_ptr9 {
                             bins EMPTY9 = {0};
                             bins HALF_FULL9 = {[7:10]};
                             bins FULL9 = {[13:15]};
                            }
  endgroup


  // DUT RX9 FIFO covergroup
  covergroup dut_rx_fifo_cg9 @(rx_fifo_ptr_change9);
    rx_level9              : coverpoint vif9.rx_fifo_ptr9 {
                             bins EMPTY9 = {0};
                             bins HALF_FULL9 = {[7:10]};
                             bins FULL9 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg9 = new();
    dut_rx_fifo_cg9.set_inst_name ("dut_rx_fifo_cg9");

    dut_tx_fifo_cg9 = new();
    dut_tx_fifo_cg9.set_inst_name ("dut_tx_fifo_cg9");

  endfunction
  
endclass : uart_ctrl_cover9
