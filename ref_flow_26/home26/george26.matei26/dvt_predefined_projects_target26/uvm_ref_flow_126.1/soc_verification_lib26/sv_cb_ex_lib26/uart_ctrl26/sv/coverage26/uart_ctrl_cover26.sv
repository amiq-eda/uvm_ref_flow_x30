/*-------------------------------------------------------------------------
File26 name   : uart_cover26.sv
Title26       : APB26<>UART26 coverage26 collection26
Project26     :
Created26     :
Description26 : Collects26 coverage26 around26 the UART26 DUT
            : 
----------------------------------------------------------------------
Copyright26 2007 (c) Cadence26 Design26 Systems26, Inc26. All Rights26 Reserved26.
----------------------------------------------------------------------*/

class uart_ctrl_cover26 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if26 vif26;
  uart_pkg26::uart_config26 uart_cfg26;

  event tx_fifo_ptr_change26;
  event rx_fifo_ptr_change26;


  // Required26 macro26 for UVM automation26 and utilities26
  `uvm_component_utils(uart_ctrl_cover26)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage26();
      collect_rx_coverage26();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if26)::get(this, get_full_name(),"vif26", vif26))
      `uvm_fatal("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
  endfunction : connect_phase

  virtual task collect_tx_coverage26();
    // --------------------------------
    // Extract26 & re-arrange26 to give26 a more useful26 input to covergroups26
    // --------------------------------
    // Calculate26 percentage26 fill26 level of TX26 FIFO
    forever begin
      @(vif26.tx_fifo_ptr26)
    //do any processing here26
      -> tx_fifo_ptr_change26;
    end  
  endtask : collect_tx_coverage26

  virtual task collect_rx_coverage26();
    // --------------------------------
    // Extract26 & re-arrange26 to give26 a more useful26 input to covergroups26
    // --------------------------------
    // Calculate26 percentage26 fill26 level of RX26 FIFO
    forever begin
      @(vif26.rx_fifo_ptr26)
    //do any processing here26
      -> rx_fifo_ptr_change26;
    end  
  endtask : collect_rx_coverage26

  // --------------------------------
  // Covergroup26 definitions26
  // --------------------------------

  // DUT TX26 FIFO covergroup
  covergroup dut_tx_fifo_cg26 @(tx_fifo_ptr_change26);
    tx_level26              : coverpoint vif26.tx_fifo_ptr26 {
                             bins EMPTY26 = {0};
                             bins HALF_FULL26 = {[7:10]};
                             bins FULL26 = {[13:15]};
                            }
  endgroup


  // DUT RX26 FIFO covergroup
  covergroup dut_rx_fifo_cg26 @(rx_fifo_ptr_change26);
    rx_level26              : coverpoint vif26.rx_fifo_ptr26 {
                             bins EMPTY26 = {0};
                             bins HALF_FULL26 = {[7:10]};
                             bins FULL26 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg26 = new();
    dut_rx_fifo_cg26.set_inst_name ("dut_rx_fifo_cg26");

    dut_tx_fifo_cg26 = new();
    dut_tx_fifo_cg26.set_inst_name ("dut_tx_fifo_cg26");

  endfunction
  
endclass : uart_ctrl_cover26
