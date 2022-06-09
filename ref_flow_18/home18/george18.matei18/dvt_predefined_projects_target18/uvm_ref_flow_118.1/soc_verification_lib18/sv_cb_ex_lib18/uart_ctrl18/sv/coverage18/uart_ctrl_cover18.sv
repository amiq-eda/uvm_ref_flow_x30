/*-------------------------------------------------------------------------
File18 name   : uart_cover18.sv
Title18       : APB18<>UART18 coverage18 collection18
Project18     :
Created18     :
Description18 : Collects18 coverage18 around18 the UART18 DUT
            : 
----------------------------------------------------------------------
Copyright18 2007 (c) Cadence18 Design18 Systems18, Inc18. All Rights18 Reserved18.
----------------------------------------------------------------------*/

class uart_ctrl_cover18 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if18 vif18;
  uart_pkg18::uart_config18 uart_cfg18;

  event tx_fifo_ptr_change18;
  event rx_fifo_ptr_change18;


  // Required18 macro18 for UVM automation18 and utilities18
  `uvm_component_utils(uart_ctrl_cover18)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage18();
      collect_rx_coverage18();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if18)::get(this, get_full_name(),"vif18", vif18))
      `uvm_fatal("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
  endfunction : connect_phase

  virtual task collect_tx_coverage18();
    // --------------------------------
    // Extract18 & re-arrange18 to give18 a more useful18 input to covergroups18
    // --------------------------------
    // Calculate18 percentage18 fill18 level of TX18 FIFO
    forever begin
      @(vif18.tx_fifo_ptr18)
    //do any processing here18
      -> tx_fifo_ptr_change18;
    end  
  endtask : collect_tx_coverage18

  virtual task collect_rx_coverage18();
    // --------------------------------
    // Extract18 & re-arrange18 to give18 a more useful18 input to covergroups18
    // --------------------------------
    // Calculate18 percentage18 fill18 level of RX18 FIFO
    forever begin
      @(vif18.rx_fifo_ptr18)
    //do any processing here18
      -> rx_fifo_ptr_change18;
    end  
  endtask : collect_rx_coverage18

  // --------------------------------
  // Covergroup18 definitions18
  // --------------------------------

  // DUT TX18 FIFO covergroup
  covergroup dut_tx_fifo_cg18 @(tx_fifo_ptr_change18);
    tx_level18              : coverpoint vif18.tx_fifo_ptr18 {
                             bins EMPTY18 = {0};
                             bins HALF_FULL18 = {[7:10]};
                             bins FULL18 = {[13:15]};
                            }
  endgroup


  // DUT RX18 FIFO covergroup
  covergroup dut_rx_fifo_cg18 @(rx_fifo_ptr_change18);
    rx_level18              : coverpoint vif18.rx_fifo_ptr18 {
                             bins EMPTY18 = {0};
                             bins HALF_FULL18 = {[7:10]};
                             bins FULL18 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg18 = new();
    dut_rx_fifo_cg18.set_inst_name ("dut_rx_fifo_cg18");

    dut_tx_fifo_cg18 = new();
    dut_tx_fifo_cg18.set_inst_name ("dut_tx_fifo_cg18");

  endfunction
  
endclass : uart_ctrl_cover18
