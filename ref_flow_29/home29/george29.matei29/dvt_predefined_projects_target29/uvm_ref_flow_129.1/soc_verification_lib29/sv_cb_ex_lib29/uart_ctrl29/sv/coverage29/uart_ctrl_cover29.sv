/*-------------------------------------------------------------------------
File29 name   : uart_cover29.sv
Title29       : APB29<>UART29 coverage29 collection29
Project29     :
Created29     :
Description29 : Collects29 coverage29 around29 the UART29 DUT
            : 
----------------------------------------------------------------------
Copyright29 2007 (c) Cadence29 Design29 Systems29, Inc29. All Rights29 Reserved29.
----------------------------------------------------------------------*/

class uart_ctrl_cover29 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if29 vif29;
  uart_pkg29::uart_config29 uart_cfg29;

  event tx_fifo_ptr_change29;
  event rx_fifo_ptr_change29;


  // Required29 macro29 for UVM automation29 and utilities29
  `uvm_component_utils(uart_ctrl_cover29)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage29();
      collect_rx_coverage29();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if29)::get(this, get_full_name(),"vif29", vif29))
      `uvm_fatal("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
  endfunction : connect_phase

  virtual task collect_tx_coverage29();
    // --------------------------------
    // Extract29 & re-arrange29 to give29 a more useful29 input to covergroups29
    // --------------------------------
    // Calculate29 percentage29 fill29 level of TX29 FIFO
    forever begin
      @(vif29.tx_fifo_ptr29)
    //do any processing here29
      -> tx_fifo_ptr_change29;
    end  
  endtask : collect_tx_coverage29

  virtual task collect_rx_coverage29();
    // --------------------------------
    // Extract29 & re-arrange29 to give29 a more useful29 input to covergroups29
    // --------------------------------
    // Calculate29 percentage29 fill29 level of RX29 FIFO
    forever begin
      @(vif29.rx_fifo_ptr29)
    //do any processing here29
      -> rx_fifo_ptr_change29;
    end  
  endtask : collect_rx_coverage29

  // --------------------------------
  // Covergroup29 definitions29
  // --------------------------------

  // DUT TX29 FIFO covergroup
  covergroup dut_tx_fifo_cg29 @(tx_fifo_ptr_change29);
    tx_level29              : coverpoint vif29.tx_fifo_ptr29 {
                             bins EMPTY29 = {0};
                             bins HALF_FULL29 = {[7:10]};
                             bins FULL29 = {[13:15]};
                            }
  endgroup


  // DUT RX29 FIFO covergroup
  covergroup dut_rx_fifo_cg29 @(rx_fifo_ptr_change29);
    rx_level29              : coverpoint vif29.rx_fifo_ptr29 {
                             bins EMPTY29 = {0};
                             bins HALF_FULL29 = {[7:10]};
                             bins FULL29 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg29 = new();
    dut_rx_fifo_cg29.set_inst_name ("dut_rx_fifo_cg29");

    dut_tx_fifo_cg29 = new();
    dut_tx_fifo_cg29.set_inst_name ("dut_tx_fifo_cg29");

  endfunction
  
endclass : uart_ctrl_cover29
