/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_scoreboard4.sv
Title4       : APB4 - UART4 Scoreboard4
Project4     :
Created4     :
Description4 : Scoreboard4 for data integrity4 check between APB4 UVC4 and UART4 UVC4
Notes4       : Two4 similar4 scoreboards4 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb4)
`uvm_analysis_imp_decl(_uart4)

class uart_ctrl_tx_scbd4 extends uvm_scoreboard;
  bit [7:0] data_to_apb4[$];
  bit [7:0] temp14;
  bit div_en4;

  // Hooks4 to cause in scoroboard4 check errors4
  // This4 resulting4 failure4 is used in MDV4 workshop4 for failure4 analysis4
  `ifdef UVM_WKSHP4
    bit apb_error4;
  `endif

  // Config4 Information4 
  uart_pkg4::uart_config4 uart_cfg4;
  apb_pkg4::apb_slave_config4 slave_cfg4;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd4)
     `uvm_field_object(uart_cfg4, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg4, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb4 #(apb_pkg4::apb_transfer4, uart_ctrl_tx_scbd4) apb_match4;
  uvm_analysis_imp_uart4 #(uart_pkg4::uart_frame4, uart_ctrl_tx_scbd4) uart_add4;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add4  = new("uart_add4", this);
    apb_match4 = new("apb_match4", this);
  endfunction : new

  // implement UART4 Tx4 analysis4 port from reference model
  virtual function void write_uart4(uart_pkg4::uart_frame4 frame4);
    data_to_apb4.push_back(frame4.payload4);	
  endfunction : write_uart4
     
  // implement APB4 READ analysis4 port from reference model
  virtual function void write_apb4(input apb_pkg4::apb_transfer4 transfer4);

    if (transfer4.addr == (slave_cfg4.start_address4 + `LINE_CTRL4)) begin
      div_en4 = transfer4.data[7];
      `uvm_info("SCRBD4",
              $psprintf("LINE_CTRL4 Write with addr = 'h%0h and data = 'h%0h div_en4 = %0b",
              transfer4.addr, transfer4.data, div_en4 ), UVM_HIGH)
    end

    if (!div_en4) begin
    if ((transfer4.addr ==   (slave_cfg4.start_address4 + `RX_FIFO_REG4)) && (transfer4.direction4 == apb_pkg4::APB_READ4))
      begin
       `ifdef UVM_WKSHP4
          corrupt_data4(transfer4);
       `endif
          temp14 = data_to_apb4.pop_front();
       
        if (temp14 == transfer4.data ) 
          `uvm_info("SCRBD4", $psprintf("####### PASS4 : APB4 RECEIVED4 CORRECT4 DATA4 from %s  expected = 'h%0h, received4 = 'h%0h", slave_cfg4.name, temp14, transfer4.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD4", $psprintf("####### FAIL4 : APB4 RECEIVED4 WRONG4 DATA4 from %s", slave_cfg4.name))
          `uvm_info("SCRBD4", $psprintf("expected = 'h%0h, received4 = 'h%0h", temp14, transfer4.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb4
   
  function void assign_cfg4(uart_pkg4::uart_config4 u_cfg4);
    uart_cfg4 = u_cfg4;
  endfunction : assign_cfg4

  function void update_config4(uart_pkg4::uart_config4 u_cfg4);
    `uvm_info(get_type_name(), {"Updating Config4\n", u_cfg4.sprint}, UVM_HIGH)
    uart_cfg4 = u_cfg4;
  endfunction : update_config4

 `ifdef UVM_WKSHP4
    function void corrupt_data4 (apb_pkg4::apb_transfer4 transfer4);
      if (!randomize(apb_error4) with {apb_error4 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL4", $psprintf("Randomization failed for apb_error4"))
      `uvm_info("SCRBD4",(""), UVM_HIGH)
      transfer4.data+=apb_error4;    	
    endfunction : corrupt_data4
  `endif

  // Add task run to debug4 TLM connectivity4 -- dbg_lab64
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG4", "SB: Verify connections4 TX4 of scorebboard4 - using debug_provided_to", UVM_NONE)
      // Implement4 here4 the checks4 
    apb_match4.debug_provided_to();
    uart_add4.debug_provided_to();
      `uvm_info("TX_SCRB_DBG4", "SB: Verify connections4 of TX4 scorebboard4 - using debug_connected_to", UVM_NONE)
      // Implement4 here4 the checks4 
    apb_match4.debug_connected_to();
    uart_add4.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd4

class uart_ctrl_rx_scbd4 extends uvm_scoreboard;
  bit [7:0] data_from_apb4[$];
  bit [7:0] data_to_apb4[$]; // Relevant4 for Remoteloopback4 case only
  bit div_en4;

  bit [7:0] temp14;
  bit [7:0] mask;

  // Hooks4 to cause in scoroboard4 check errors4
  // This4 resulting4 failure4 is used in MDV4 workshop4 for failure4 analysis4
  `ifdef UVM_WKSHP4
    bit uart_error4;
  `endif

  uart_pkg4::uart_config4 uart_cfg4;
  apb_pkg4::apb_slave_config4 slave_cfg4;

  `uvm_component_utils(uart_ctrl_rx_scbd4)
  uvm_analysis_imp_apb4 #(apb_pkg4::apb_transfer4, uart_ctrl_rx_scbd4) apb_add4;
  uvm_analysis_imp_uart4 #(uart_pkg4::uart_frame4, uart_ctrl_rx_scbd4) uart_match4;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match4 = new("uart_match4", this);
    apb_add4    = new("apb_add4", this);
  endfunction : new
   
  // implement APB4 WRITE analysis4 port from reference model
  virtual function void write_apb4(input apb_pkg4::apb_transfer4 transfer4);
    `uvm_info("SCRBD4",
              $psprintf("write_apb4 called with addr = 'h%0h and data = 'h%0h",
              transfer4.addr, transfer4.data), UVM_HIGH)
    if ((transfer4.addr == (slave_cfg4.start_address4 + `LINE_CTRL4)) &&
        (transfer4.direction4 == apb_pkg4::APB_WRITE4)) begin
      div_en4 = transfer4.data[7];
      `uvm_info("SCRBD4",
              $psprintf("LINE_CTRL4 Write with addr = 'h%0h and data = 'h%0h div_en4 = %0b",
              transfer4.addr, transfer4.data, div_en4 ), UVM_HIGH)
    end

    if (!div_en4) begin
      if ((transfer4.addr == (slave_cfg4.start_address4 + `TX_FIFO_REG4)) &&
          (transfer4.direction4 == apb_pkg4::APB_WRITE4)) begin 
        `uvm_info("SCRBD4",
               $psprintf("write_apb4 called pushing4 into queue with data = 'h%0h",
               transfer4.data ), UVM_HIGH)
        data_from_apb4.push_back(transfer4.data);
      end
    end
  endfunction : write_apb4
   
  // implement UART4 Rx4 analysis4 port from reference model
  virtual function void write_uart4( uart_pkg4::uart_frame4 frame4);
    mask = calc_mask4();

    //In case of remote4 loopback4, the data does not get into the rx4/fifo and it gets4 
    // loopbacked4 to ua_txd4. 
    data_to_apb4.push_back(frame4.payload4);	

      temp14 = data_from_apb4.pop_front();

    `ifdef UVM_WKSHP4
        corrupt_payload4 (frame4);
    `endif 
    if ((temp14 & mask) == frame4.payload4) 
      `uvm_info("SCRBD4", $psprintf("####### PASS4 : %s RECEIVED4 CORRECT4 DATA4 expected = 'h%0h, received4 = 'h%0h", slave_cfg4.name, (temp14 & mask), frame4.payload4), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD4", $psprintf("####### FAIL4 : %s RECEIVED4 WRONG4 DATA4", slave_cfg4.name))
      `uvm_info("SCRBD4", $psprintf("expected = 'h%0h, received4 = 'h%0h", temp14, frame4.payload4), UVM_LOW)
    end
  endfunction : write_uart4
   
  function void assign_cfg4(uart_pkg4::uart_config4 u_cfg4);
     uart_cfg4 = u_cfg4;
  endfunction : assign_cfg4
   
  function void update_config4(uart_pkg4::uart_config4 u_cfg4);
   `uvm_info(get_type_name(), {"Updating Config4\n", u_cfg4.sprint}, UVM_HIGH)
    uart_cfg4 = u_cfg4;
  endfunction : update_config4

  function bit[7:0] calc_mask4();
    case (uart_cfg4.char_len_val4)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask4

  `ifdef UVM_WKSHP4
   function void corrupt_payload4 (uart_pkg4::uart_frame4 frame4);
      if(!randomize(uart_error4) with {uart_error4 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL4", $psprintf("Randomization failed for apb_error4"))
      `uvm_info("SCRBD4",(""), UVM_HIGH)
      frame4.payload4+=uart_error4;    	
   endfunction : corrupt_payload4

  `endif

  // Add task run to debug4 TLM connectivity4
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist4;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG4", "SB: Verify connections4 RX4 of scorebboard4 - using debug_provided_to", UVM_NONE)
      // Implement4 here4 the checks4 
    apb_add4.debug_provided_to();
    uart_match4.debug_provided_to();
      `uvm_info("RX_SCRB_DBG4", "SB: Verify connections4 of RX4 scorebboard4 - using debug_connected_to", UVM_NONE)
      // Implement4 here4 the checks4 
    apb_add4.debug_connected_to();
    uart_match4.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd4
