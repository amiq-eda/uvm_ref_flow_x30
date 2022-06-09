/*-------------------------------------------------------------------------
File6 name   : uart_cover6.sv
Title6       : APB6<>UART6 coverage6 collection6
Project6     :
Created6     :
Description6 : Collects6 coverage6 around6 the UART6 DUT
            : 
----------------------------------------------------------------------
Copyright6 2007 (c) Cadence6 Design6 Systems6, Inc6. All Rights6 Reserved6.
----------------------------------------------------------------------*/

class uart_ctrl_cover6 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if6 vif6;
  uart_pkg6::uart_config6 uart_cfg6;

  event tx_fifo_ptr_change6;
  event rx_fifo_ptr_change6;


  // Required6 macro6 for UVM automation6 and utilities6
  `uvm_component_utils(uart_ctrl_cover6)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage6();
      collect_rx_coverage6();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if6)::get(this, get_full_name(),"vif6", vif6))
      `uvm_fatal("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
  endfunction : connect_phase

  virtual task collect_tx_coverage6();
    // --------------------------------
    // Extract6 & re-arrange6 to give6 a more useful6 input to covergroups6
    // --------------------------------
    // Calculate6 percentage6 fill6 level of TX6 FIFO
    forever begin
      @(vif6.tx_fifo_ptr6)
    //do any processing here6
      -> tx_fifo_ptr_change6;
    end  
  endtask : collect_tx_coverage6

  virtual task collect_rx_coverage6();
    // --------------------------------
    // Extract6 & re-arrange6 to give6 a more useful6 input to covergroups6
    // --------------------------------
    // Calculate6 percentage6 fill6 level of RX6 FIFO
    forever begin
      @(vif6.rx_fifo_ptr6)
    //do any processing here6
      -> rx_fifo_ptr_change6;
    end  
  endtask : collect_rx_coverage6

  // --------------------------------
  // Covergroup6 definitions6
  // --------------------------------

  // DUT TX6 FIFO covergroup
  covergroup dut_tx_fifo_cg6 @(tx_fifo_ptr_change6);
    tx_level6              : coverpoint vif6.tx_fifo_ptr6 {
                             bins EMPTY6 = {0};
                             bins HALF_FULL6 = {[7:10]};
                             bins FULL6 = {[13:15]};
                            }
  endgroup


  // DUT RX6 FIFO covergroup
  covergroup dut_rx_fifo_cg6 @(rx_fifo_ptr_change6);
    rx_level6              : coverpoint vif6.rx_fifo_ptr6 {
                             bins EMPTY6 = {0};
                             bins HALF_FULL6 = {[7:10]};
                             bins FULL6 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg6 = new();
    dut_rx_fifo_cg6.set_inst_name ("dut_rx_fifo_cg6");

    dut_tx_fifo_cg6 = new();
    dut_tx_fifo_cg6.set_inst_name ("dut_tx_fifo_cg6");

  endfunction
  
endclass : uart_ctrl_cover6
