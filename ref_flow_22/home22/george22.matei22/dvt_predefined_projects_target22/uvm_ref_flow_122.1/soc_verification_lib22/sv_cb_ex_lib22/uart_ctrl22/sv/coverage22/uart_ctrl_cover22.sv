/*-------------------------------------------------------------------------
File22 name   : uart_cover22.sv
Title22       : APB22<>UART22 coverage22 collection22
Project22     :
Created22     :
Description22 : Collects22 coverage22 around22 the UART22 DUT
            : 
----------------------------------------------------------------------
Copyright22 2007 (c) Cadence22 Design22 Systems22, Inc22. All Rights22 Reserved22.
----------------------------------------------------------------------*/

class uart_ctrl_cover22 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if22 vif22;
  uart_pkg22::uart_config22 uart_cfg22;

  event tx_fifo_ptr_change22;
  event rx_fifo_ptr_change22;


  // Required22 macro22 for UVM automation22 and utilities22
  `uvm_component_utils(uart_ctrl_cover22)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage22();
      collect_rx_coverage22();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if22)::get(this, get_full_name(),"vif22", vif22))
      `uvm_fatal("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
  endfunction : connect_phase

  virtual task collect_tx_coverage22();
    // --------------------------------
    // Extract22 & re-arrange22 to give22 a more useful22 input to covergroups22
    // --------------------------------
    // Calculate22 percentage22 fill22 level of TX22 FIFO
    forever begin
      @(vif22.tx_fifo_ptr22)
    //do any processing here22
      -> tx_fifo_ptr_change22;
    end  
  endtask : collect_tx_coverage22

  virtual task collect_rx_coverage22();
    // --------------------------------
    // Extract22 & re-arrange22 to give22 a more useful22 input to covergroups22
    // --------------------------------
    // Calculate22 percentage22 fill22 level of RX22 FIFO
    forever begin
      @(vif22.rx_fifo_ptr22)
    //do any processing here22
      -> rx_fifo_ptr_change22;
    end  
  endtask : collect_rx_coverage22

  // --------------------------------
  // Covergroup22 definitions22
  // --------------------------------

  // DUT TX22 FIFO covergroup
  covergroup dut_tx_fifo_cg22 @(tx_fifo_ptr_change22);
    tx_level22              : coverpoint vif22.tx_fifo_ptr22 {
                             bins EMPTY22 = {0};
                             bins HALF_FULL22 = {[7:10]};
                             bins FULL22 = {[13:15]};
                            }
  endgroup


  // DUT RX22 FIFO covergroup
  covergroup dut_rx_fifo_cg22 @(rx_fifo_ptr_change22);
    rx_level22              : coverpoint vif22.rx_fifo_ptr22 {
                             bins EMPTY22 = {0};
                             bins HALF_FULL22 = {[7:10]};
                             bins FULL22 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg22 = new();
    dut_rx_fifo_cg22.set_inst_name ("dut_rx_fifo_cg22");

    dut_tx_fifo_cg22 = new();
    dut_tx_fifo_cg22.set_inst_name ("dut_tx_fifo_cg22");

  endfunction
  
endclass : uart_ctrl_cover22
