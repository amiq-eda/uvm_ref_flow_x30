/*-------------------------------------------------------------------------
File5 name   : uart_cover5.sv
Title5       : APB5<>UART5 coverage5 collection5
Project5     :
Created5     :
Description5 : Collects5 coverage5 around5 the UART5 DUT
            : 
----------------------------------------------------------------------
Copyright5 2007 (c) Cadence5 Design5 Systems5, Inc5. All Rights5 Reserved5.
----------------------------------------------------------------------*/

class uart_ctrl_cover5 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if5 vif5;
  uart_pkg5::uart_config5 uart_cfg5;

  event tx_fifo_ptr_change5;
  event rx_fifo_ptr_change5;


  // Required5 macro5 for UVM automation5 and utilities5
  `uvm_component_utils(uart_ctrl_cover5)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage5();
      collect_rx_coverage5();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if5)::get(this, get_full_name(),"vif5", vif5))
      `uvm_fatal("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
  endfunction : connect_phase

  virtual task collect_tx_coverage5();
    // --------------------------------
    // Extract5 & re-arrange5 to give5 a more useful5 input to covergroups5
    // --------------------------------
    // Calculate5 percentage5 fill5 level of TX5 FIFO
    forever begin
      @(vif5.tx_fifo_ptr5)
    //do any processing here5
      -> tx_fifo_ptr_change5;
    end  
  endtask : collect_tx_coverage5

  virtual task collect_rx_coverage5();
    // --------------------------------
    // Extract5 & re-arrange5 to give5 a more useful5 input to covergroups5
    // --------------------------------
    // Calculate5 percentage5 fill5 level of RX5 FIFO
    forever begin
      @(vif5.rx_fifo_ptr5)
    //do any processing here5
      -> rx_fifo_ptr_change5;
    end  
  endtask : collect_rx_coverage5

  // --------------------------------
  // Covergroup5 definitions5
  // --------------------------------

  // DUT TX5 FIFO covergroup
  covergroup dut_tx_fifo_cg5 @(tx_fifo_ptr_change5);
    tx_level5              : coverpoint vif5.tx_fifo_ptr5 {
                             bins EMPTY5 = {0};
                             bins HALF_FULL5 = {[7:10]};
                             bins FULL5 = {[13:15]};
                            }
  endgroup


  // DUT RX5 FIFO covergroup
  covergroup dut_rx_fifo_cg5 @(rx_fifo_ptr_change5);
    rx_level5              : coverpoint vif5.rx_fifo_ptr5 {
                             bins EMPTY5 = {0};
                             bins HALF_FULL5 = {[7:10]};
                             bins FULL5 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg5 = new();
    dut_rx_fifo_cg5.set_inst_name ("dut_rx_fifo_cg5");

    dut_tx_fifo_cg5 = new();
    dut_tx_fifo_cg5.set_inst_name ("dut_tx_fifo_cg5");

  endfunction
  
endclass : uart_ctrl_cover5
