/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_scoreboard5.sv
Title5       : APB5 - UART5 Scoreboard5
Project5     :
Created5     :
Description5 : Scoreboard5 for data integrity5 check between APB5 UVC5 and UART5 UVC5
Notes5       : Two5 similar5 scoreboards5 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb5)
`uvm_analysis_imp_decl(_uart5)

class uart_ctrl_tx_scbd5 extends uvm_scoreboard;
  bit [7:0] data_to_apb5[$];
  bit [7:0] temp15;
  bit div_en5;

  // Hooks5 to cause in scoroboard5 check errors5
  // This5 resulting5 failure5 is used in MDV5 workshop5 for failure5 analysis5
  `ifdef UVM_WKSHP5
    bit apb_error5;
  `endif

  // Config5 Information5 
  uart_pkg5::uart_config5 uart_cfg5;
  apb_pkg5::apb_slave_config5 slave_cfg5;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd5)
     `uvm_field_object(uart_cfg5, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg5, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb5 #(apb_pkg5::apb_transfer5, uart_ctrl_tx_scbd5) apb_match5;
  uvm_analysis_imp_uart5 #(uart_pkg5::uart_frame5, uart_ctrl_tx_scbd5) uart_add5;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add5  = new("uart_add5", this);
    apb_match5 = new("apb_match5", this);
  endfunction : new

  // implement UART5 Tx5 analysis5 port from reference model
  virtual function void write_uart5(uart_pkg5::uart_frame5 frame5);
    data_to_apb5.push_back(frame5.payload5);	
  endfunction : write_uart5
     
  // implement APB5 READ analysis5 port from reference model
  virtual function void write_apb5(input apb_pkg5::apb_transfer5 transfer5);

    if (transfer5.addr == (slave_cfg5.start_address5 + `LINE_CTRL5)) begin
      div_en5 = transfer5.data[7];
      `uvm_info("SCRBD5",
              $psprintf("LINE_CTRL5 Write with addr = 'h%0h and data = 'h%0h div_en5 = %0b",
              transfer5.addr, transfer5.data, div_en5 ), UVM_HIGH)
    end

    if (!div_en5) begin
    if ((transfer5.addr ==   (slave_cfg5.start_address5 + `RX_FIFO_REG5)) && (transfer5.direction5 == apb_pkg5::APB_READ5))
      begin
       `ifdef UVM_WKSHP5
          corrupt_data5(transfer5);
       `endif
          temp15 = data_to_apb5.pop_front();
       
        if (temp15 == transfer5.data ) 
          `uvm_info("SCRBD5", $psprintf("####### PASS5 : APB5 RECEIVED5 CORRECT5 DATA5 from %s  expected = 'h%0h, received5 = 'h%0h", slave_cfg5.name, temp15, transfer5.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD5", $psprintf("####### FAIL5 : APB5 RECEIVED5 WRONG5 DATA5 from %s", slave_cfg5.name))
          `uvm_info("SCRBD5", $psprintf("expected = 'h%0h, received5 = 'h%0h", temp15, transfer5.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb5
   
  function void assign_cfg5(uart_pkg5::uart_config5 u_cfg5);
    uart_cfg5 = u_cfg5;
  endfunction : assign_cfg5

  function void update_config5(uart_pkg5::uart_config5 u_cfg5);
    `uvm_info(get_type_name(), {"Updating Config5\n", u_cfg5.sprint}, UVM_HIGH)
    uart_cfg5 = u_cfg5;
  endfunction : update_config5

 `ifdef UVM_WKSHP5
    function void corrupt_data5 (apb_pkg5::apb_transfer5 transfer5);
      if (!randomize(apb_error5) with {apb_error5 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL5", $psprintf("Randomization failed for apb_error5"))
      `uvm_info("SCRBD5",(""), UVM_HIGH)
      transfer5.data+=apb_error5;    	
    endfunction : corrupt_data5
  `endif

  // Add task run to debug5 TLM connectivity5 -- dbg_lab65
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG5", "SB: Verify connections5 TX5 of scorebboard5 - using debug_provided_to", UVM_NONE)
      // Implement5 here5 the checks5 
    apb_match5.debug_provided_to();
    uart_add5.debug_provided_to();
      `uvm_info("TX_SCRB_DBG5", "SB: Verify connections5 of TX5 scorebboard5 - using debug_connected_to", UVM_NONE)
      // Implement5 here5 the checks5 
    apb_match5.debug_connected_to();
    uart_add5.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd5

class uart_ctrl_rx_scbd5 extends uvm_scoreboard;
  bit [7:0] data_from_apb5[$];
  bit [7:0] data_to_apb5[$]; // Relevant5 for Remoteloopback5 case only
  bit div_en5;

  bit [7:0] temp15;
  bit [7:0] mask;

  // Hooks5 to cause in scoroboard5 check errors5
  // This5 resulting5 failure5 is used in MDV5 workshop5 for failure5 analysis5
  `ifdef UVM_WKSHP5
    bit uart_error5;
  `endif

  uart_pkg5::uart_config5 uart_cfg5;
  apb_pkg5::apb_slave_config5 slave_cfg5;

  `uvm_component_utils(uart_ctrl_rx_scbd5)
  uvm_analysis_imp_apb5 #(apb_pkg5::apb_transfer5, uart_ctrl_rx_scbd5) apb_add5;
  uvm_analysis_imp_uart5 #(uart_pkg5::uart_frame5, uart_ctrl_rx_scbd5) uart_match5;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match5 = new("uart_match5", this);
    apb_add5    = new("apb_add5", this);
  endfunction : new
   
  // implement APB5 WRITE analysis5 port from reference model
  virtual function void write_apb5(input apb_pkg5::apb_transfer5 transfer5);
    `uvm_info("SCRBD5",
              $psprintf("write_apb5 called with addr = 'h%0h and data = 'h%0h",
              transfer5.addr, transfer5.data), UVM_HIGH)
    if ((transfer5.addr == (slave_cfg5.start_address5 + `LINE_CTRL5)) &&
        (transfer5.direction5 == apb_pkg5::APB_WRITE5)) begin
      div_en5 = transfer5.data[7];
      `uvm_info("SCRBD5",
              $psprintf("LINE_CTRL5 Write with addr = 'h%0h and data = 'h%0h div_en5 = %0b",
              transfer5.addr, transfer5.data, div_en5 ), UVM_HIGH)
    end

    if (!div_en5) begin
      if ((transfer5.addr == (slave_cfg5.start_address5 + `TX_FIFO_REG5)) &&
          (transfer5.direction5 == apb_pkg5::APB_WRITE5)) begin 
        `uvm_info("SCRBD5",
               $psprintf("write_apb5 called pushing5 into queue with data = 'h%0h",
               transfer5.data ), UVM_HIGH)
        data_from_apb5.push_back(transfer5.data);
      end
    end
  endfunction : write_apb5
   
  // implement UART5 Rx5 analysis5 port from reference model
  virtual function void write_uart5( uart_pkg5::uart_frame5 frame5);
    mask = calc_mask5();

    //In case of remote5 loopback5, the data does not get into the rx5/fifo and it gets5 
    // loopbacked5 to ua_txd5. 
    data_to_apb5.push_back(frame5.payload5);	

      temp15 = data_from_apb5.pop_front();

    `ifdef UVM_WKSHP5
        corrupt_payload5 (frame5);
    `endif 
    if ((temp15 & mask) == frame5.payload5) 
      `uvm_info("SCRBD5", $psprintf("####### PASS5 : %s RECEIVED5 CORRECT5 DATA5 expected = 'h%0h, received5 = 'h%0h", slave_cfg5.name, (temp15 & mask), frame5.payload5), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD5", $psprintf("####### FAIL5 : %s RECEIVED5 WRONG5 DATA5", slave_cfg5.name))
      `uvm_info("SCRBD5", $psprintf("expected = 'h%0h, received5 = 'h%0h", temp15, frame5.payload5), UVM_LOW)
    end
  endfunction : write_uart5
   
  function void assign_cfg5(uart_pkg5::uart_config5 u_cfg5);
     uart_cfg5 = u_cfg5;
  endfunction : assign_cfg5
   
  function void update_config5(uart_pkg5::uart_config5 u_cfg5);
   `uvm_info(get_type_name(), {"Updating Config5\n", u_cfg5.sprint}, UVM_HIGH)
    uart_cfg5 = u_cfg5;
  endfunction : update_config5

  function bit[7:0] calc_mask5();
    case (uart_cfg5.char_len_val5)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask5

  `ifdef UVM_WKSHP5
   function void corrupt_payload5 (uart_pkg5::uart_frame5 frame5);
      if(!randomize(uart_error5) with {uart_error5 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL5", $psprintf("Randomization failed for apb_error5"))
      `uvm_info("SCRBD5",(""), UVM_HIGH)
      frame5.payload5+=uart_error5;    	
   endfunction : corrupt_payload5

  `endif

  // Add task run to debug5 TLM connectivity5
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist5;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG5", "SB: Verify connections5 RX5 of scorebboard5 - using debug_provided_to", UVM_NONE)
      // Implement5 here5 the checks5 
    apb_add5.debug_provided_to();
    uart_match5.debug_provided_to();
      `uvm_info("RX_SCRB_DBG5", "SB: Verify connections5 of RX5 scorebboard5 - using debug_connected_to", UVM_NONE)
      // Implement5 here5 the checks5 
    apb_add5.debug_connected_to();
    uart_match5.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd5
