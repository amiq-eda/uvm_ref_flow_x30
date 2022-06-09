/*-------------------------------------------------------------------------
File13 name   : uart_cover13.sv
Title13       : APB13<>UART13 coverage13 collection13
Project13     :
Created13     :
Description13 : Collects13 coverage13 around13 the UART13 DUT
            : 
----------------------------------------------------------------------
Copyright13 2007 (c) Cadence13 Design13 Systems13, Inc13. All Rights13 Reserved13.
----------------------------------------------------------------------*/

class uart_ctrl_cover13 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if13 vif13;
  uart_pkg13::uart_config13 uart_cfg13;

  event tx_fifo_ptr_change13;
  event rx_fifo_ptr_change13;


  // Required13 macro13 for UVM automation13 and utilities13
  `uvm_component_utils(uart_ctrl_cover13)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage13();
      collect_rx_coverage13();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if13)::get(this, get_full_name(),"vif13", vif13))
      `uvm_fatal("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
  endfunction : connect_phase

  virtual task collect_tx_coverage13();
    // --------------------------------
    // Extract13 & re-arrange13 to give13 a more useful13 input to covergroups13
    // --------------------------------
    // Calculate13 percentage13 fill13 level of TX13 FIFO
    forever begin
      @(vif13.tx_fifo_ptr13)
    //do any processing here13
      -> tx_fifo_ptr_change13;
    end  
  endtask : collect_tx_coverage13

  virtual task collect_rx_coverage13();
    // --------------------------------
    // Extract13 & re-arrange13 to give13 a more useful13 input to covergroups13
    // --------------------------------
    // Calculate13 percentage13 fill13 level of RX13 FIFO
    forever begin
      @(vif13.rx_fifo_ptr13)
    //do any processing here13
      -> rx_fifo_ptr_change13;
    end  
  endtask : collect_rx_coverage13

  // --------------------------------
  // Covergroup13 definitions13
  // --------------------------------

  // DUT TX13 FIFO covergroup
  covergroup dut_tx_fifo_cg13 @(tx_fifo_ptr_change13);
    tx_level13              : coverpoint vif13.tx_fifo_ptr13 {
                             bins EMPTY13 = {0};
                             bins HALF_FULL13 = {[7:10]};
                             bins FULL13 = {[13:15]};
                            }
  endgroup


  // DUT RX13 FIFO covergroup
  covergroup dut_rx_fifo_cg13 @(rx_fifo_ptr_change13);
    rx_level13              : coverpoint vif13.rx_fifo_ptr13 {
                             bins EMPTY13 = {0};
                             bins HALF_FULL13 = {[7:10]};
                             bins FULL13 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg13 = new();
    dut_rx_fifo_cg13.set_inst_name ("dut_rx_fifo_cg13");

    dut_tx_fifo_cg13 = new();
    dut_tx_fifo_cg13.set_inst_name ("dut_tx_fifo_cg13");

  endfunction
  
endclass : uart_ctrl_cover13
