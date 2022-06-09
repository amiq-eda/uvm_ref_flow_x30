/*-------------------------------------------------------------------------
File4 name   : uart_cover4.sv
Title4       : APB4<>UART4 coverage4 collection4
Project4     :
Created4     :
Description4 : Collects4 coverage4 around4 the UART4 DUT
            : 
----------------------------------------------------------------------
Copyright4 2007 (c) Cadence4 Design4 Systems4, Inc4. All Rights4 Reserved4.
----------------------------------------------------------------------*/

class uart_ctrl_cover4 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if4 vif4;
  uart_pkg4::uart_config4 uart_cfg4;

  event tx_fifo_ptr_change4;
  event rx_fifo_ptr_change4;


  // Required4 macro4 for UVM automation4 and utilities4
  `uvm_component_utils(uart_ctrl_cover4)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage4();
      collect_rx_coverage4();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if4)::get(this, get_full_name(),"vif4", vif4))
      `uvm_fatal("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
  endfunction : connect_phase

  virtual task collect_tx_coverage4();
    // --------------------------------
    // Extract4 & re-arrange4 to give4 a more useful4 input to covergroups4
    // --------------------------------
    // Calculate4 percentage4 fill4 level of TX4 FIFO
    forever begin
      @(vif4.tx_fifo_ptr4)
    //do any processing here4
      -> tx_fifo_ptr_change4;
    end  
  endtask : collect_tx_coverage4

  virtual task collect_rx_coverage4();
    // --------------------------------
    // Extract4 & re-arrange4 to give4 a more useful4 input to covergroups4
    // --------------------------------
    // Calculate4 percentage4 fill4 level of RX4 FIFO
    forever begin
      @(vif4.rx_fifo_ptr4)
    //do any processing here4
      -> rx_fifo_ptr_change4;
    end  
  endtask : collect_rx_coverage4

  // --------------------------------
  // Covergroup4 definitions4
  // --------------------------------

  // DUT TX4 FIFO covergroup
  covergroup dut_tx_fifo_cg4 @(tx_fifo_ptr_change4);
    tx_level4              : coverpoint vif4.tx_fifo_ptr4 {
                             bins EMPTY4 = {0};
                             bins HALF_FULL4 = {[7:10]};
                             bins FULL4 = {[13:15]};
                            }
  endgroup


  // DUT RX4 FIFO covergroup
  covergroup dut_rx_fifo_cg4 @(rx_fifo_ptr_change4);
    rx_level4              : coverpoint vif4.rx_fifo_ptr4 {
                             bins EMPTY4 = {0};
                             bins HALF_FULL4 = {[7:10]};
                             bins FULL4 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg4 = new();
    dut_rx_fifo_cg4.set_inst_name ("dut_rx_fifo_cg4");

    dut_tx_fifo_cg4 = new();
    dut_tx_fifo_cg4.set_inst_name ("dut_tx_fifo_cg4");

  endfunction
  
endclass : uart_ctrl_cover4
