/*-------------------------------------------------------------------------
File10 name   : uart_ctrl_scoreboard10.sv
Title10       : APB10 - UART10 Scoreboard10
Project10     :
Created10     :
Description10 : Scoreboard10 for data integrity10 check between APB10 UVC10 and UART10 UVC10
Notes10       : Two10 similar10 scoreboards10 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb10)
`uvm_analysis_imp_decl(_uart10)

class uart_ctrl_tx_scbd10 extends uvm_scoreboard;
  bit [7:0] data_to_apb10[$];
  bit [7:0] temp110;
  bit div_en10;

  // Hooks10 to cause in scoroboard10 check errors10
  // This10 resulting10 failure10 is used in MDV10 workshop10 for failure10 analysis10
  `ifdef UVM_WKSHP10
    bit apb_error10;
  `endif

  // Config10 Information10 
  uart_pkg10::uart_config10 uart_cfg10;
  apb_pkg10::apb_slave_config10 slave_cfg10;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd10)
     `uvm_field_object(uart_cfg10, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg10, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb10 #(apb_pkg10::apb_transfer10, uart_ctrl_tx_scbd10) apb_match10;
  uvm_analysis_imp_uart10 #(uart_pkg10::uart_frame10, uart_ctrl_tx_scbd10) uart_add10;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add10  = new("uart_add10", this);
    apb_match10 = new("apb_match10", this);
  endfunction : new

  // implement UART10 Tx10 analysis10 port from reference model
  virtual function void write_uart10(uart_pkg10::uart_frame10 frame10);
    data_to_apb10.push_back(frame10.payload10);	
  endfunction : write_uart10
     
  // implement APB10 READ analysis10 port from reference model
  virtual function void write_apb10(input apb_pkg10::apb_transfer10 transfer10);

    if (transfer10.addr == (slave_cfg10.start_address10 + `LINE_CTRL10)) begin
      div_en10 = transfer10.data[7];
      `uvm_info("SCRBD10",
              $psprintf("LINE_CTRL10 Write with addr = 'h%0h and data = 'h%0h div_en10 = %0b",
              transfer10.addr, transfer10.data, div_en10 ), UVM_HIGH)
    end

    if (!div_en10) begin
    if ((transfer10.addr ==   (slave_cfg10.start_address10 + `RX_FIFO_REG10)) && (transfer10.direction10 == apb_pkg10::APB_READ10))
      begin
       `ifdef UVM_WKSHP10
          corrupt_data10(transfer10);
       `endif
          temp110 = data_to_apb10.pop_front();
       
        if (temp110 == transfer10.data ) 
          `uvm_info("SCRBD10", $psprintf("####### PASS10 : APB10 RECEIVED10 CORRECT10 DATA10 from %s  expected = 'h%0h, received10 = 'h%0h", slave_cfg10.name, temp110, transfer10.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD10", $psprintf("####### FAIL10 : APB10 RECEIVED10 WRONG10 DATA10 from %s", slave_cfg10.name))
          `uvm_info("SCRBD10", $psprintf("expected = 'h%0h, received10 = 'h%0h", temp110, transfer10.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb10
   
  function void assign_cfg10(uart_pkg10::uart_config10 u_cfg10);
    uart_cfg10 = u_cfg10;
  endfunction : assign_cfg10

  function void update_config10(uart_pkg10::uart_config10 u_cfg10);
    `uvm_info(get_type_name(), {"Updating Config10\n", u_cfg10.sprint}, UVM_HIGH)
    uart_cfg10 = u_cfg10;
  endfunction : update_config10

 `ifdef UVM_WKSHP10
    function void corrupt_data10 (apb_pkg10::apb_transfer10 transfer10);
      if (!randomize(apb_error10) with {apb_error10 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL10", $psprintf("Randomization failed for apb_error10"))
      `uvm_info("SCRBD10",(""), UVM_HIGH)
      transfer10.data+=apb_error10;    	
    endfunction : corrupt_data10
  `endif

  // Add task run to debug10 TLM connectivity10 -- dbg_lab610
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG10", "SB: Verify connections10 TX10 of scorebboard10 - using debug_provided_to", UVM_NONE)
      // Implement10 here10 the checks10 
    apb_match10.debug_provided_to();
    uart_add10.debug_provided_to();
      `uvm_info("TX_SCRB_DBG10", "SB: Verify connections10 of TX10 scorebboard10 - using debug_connected_to", UVM_NONE)
      // Implement10 here10 the checks10 
    apb_match10.debug_connected_to();
    uart_add10.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd10

class uart_ctrl_rx_scbd10 extends uvm_scoreboard;
  bit [7:0] data_from_apb10[$];
  bit [7:0] data_to_apb10[$]; // Relevant10 for Remoteloopback10 case only
  bit div_en10;

  bit [7:0] temp110;
  bit [7:0] mask;

  // Hooks10 to cause in scoroboard10 check errors10
  // This10 resulting10 failure10 is used in MDV10 workshop10 for failure10 analysis10
  `ifdef UVM_WKSHP10
    bit uart_error10;
  `endif

  uart_pkg10::uart_config10 uart_cfg10;
  apb_pkg10::apb_slave_config10 slave_cfg10;

  `uvm_component_utils(uart_ctrl_rx_scbd10)
  uvm_analysis_imp_apb10 #(apb_pkg10::apb_transfer10, uart_ctrl_rx_scbd10) apb_add10;
  uvm_analysis_imp_uart10 #(uart_pkg10::uart_frame10, uart_ctrl_rx_scbd10) uart_match10;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match10 = new("uart_match10", this);
    apb_add10    = new("apb_add10", this);
  endfunction : new
   
  // implement APB10 WRITE analysis10 port from reference model
  virtual function void write_apb10(input apb_pkg10::apb_transfer10 transfer10);
    `uvm_info("SCRBD10",
              $psprintf("write_apb10 called with addr = 'h%0h and data = 'h%0h",
              transfer10.addr, transfer10.data), UVM_HIGH)
    if ((transfer10.addr == (slave_cfg10.start_address10 + `LINE_CTRL10)) &&
        (transfer10.direction10 == apb_pkg10::APB_WRITE10)) begin
      div_en10 = transfer10.data[7];
      `uvm_info("SCRBD10",
              $psprintf("LINE_CTRL10 Write with addr = 'h%0h and data = 'h%0h div_en10 = %0b",
              transfer10.addr, transfer10.data, div_en10 ), UVM_HIGH)
    end

    if (!div_en10) begin
      if ((transfer10.addr == (slave_cfg10.start_address10 + `TX_FIFO_REG10)) &&
          (transfer10.direction10 == apb_pkg10::APB_WRITE10)) begin 
        `uvm_info("SCRBD10",
               $psprintf("write_apb10 called pushing10 into queue with data = 'h%0h",
               transfer10.data ), UVM_HIGH)
        data_from_apb10.push_back(transfer10.data);
      end
    end
  endfunction : write_apb10
   
  // implement UART10 Rx10 analysis10 port from reference model
  virtual function void write_uart10( uart_pkg10::uart_frame10 frame10);
    mask = calc_mask10();

    //In case of remote10 loopback10, the data does not get into the rx10/fifo and it gets10 
    // loopbacked10 to ua_txd10. 
    data_to_apb10.push_back(frame10.payload10);	

      temp110 = data_from_apb10.pop_front();

    `ifdef UVM_WKSHP10
        corrupt_payload10 (frame10);
    `endif 
    if ((temp110 & mask) == frame10.payload10) 
      `uvm_info("SCRBD10", $psprintf("####### PASS10 : %s RECEIVED10 CORRECT10 DATA10 expected = 'h%0h, received10 = 'h%0h", slave_cfg10.name, (temp110 & mask), frame10.payload10), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD10", $psprintf("####### FAIL10 : %s RECEIVED10 WRONG10 DATA10", slave_cfg10.name))
      `uvm_info("SCRBD10", $psprintf("expected = 'h%0h, received10 = 'h%0h", temp110, frame10.payload10), UVM_LOW)
    end
  endfunction : write_uart10
   
  function void assign_cfg10(uart_pkg10::uart_config10 u_cfg10);
     uart_cfg10 = u_cfg10;
  endfunction : assign_cfg10
   
  function void update_config10(uart_pkg10::uart_config10 u_cfg10);
   `uvm_info(get_type_name(), {"Updating Config10\n", u_cfg10.sprint}, UVM_HIGH)
    uart_cfg10 = u_cfg10;
  endfunction : update_config10

  function bit[7:0] calc_mask10();
    case (uart_cfg10.char_len_val10)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask10

  `ifdef UVM_WKSHP10
   function void corrupt_payload10 (uart_pkg10::uart_frame10 frame10);
      if(!randomize(uart_error10) with {uart_error10 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL10", $psprintf("Randomization failed for apb_error10"))
      `uvm_info("SCRBD10",(""), UVM_HIGH)
      frame10.payload10+=uart_error10;    	
   endfunction : corrupt_payload10

  `endif

  // Add task run to debug10 TLM connectivity10
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist10;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG10", "SB: Verify connections10 RX10 of scorebboard10 - using debug_provided_to", UVM_NONE)
      // Implement10 here10 the checks10 
    apb_add10.debug_provided_to();
    uart_match10.debug_provided_to();
      `uvm_info("RX_SCRB_DBG10", "SB: Verify connections10 of RX10 scorebboard10 - using debug_connected_to", UVM_NONE)
      // Implement10 here10 the checks10 
    apb_add10.debug_connected_to();
    uart_match10.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd10
