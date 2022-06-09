/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_scoreboard9.sv
Title9       : APB9 - UART9 Scoreboard9
Project9     :
Created9     :
Description9 : Scoreboard9 for data integrity9 check between APB9 UVC9 and UART9 UVC9
Notes9       : Two9 similar9 scoreboards9 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb9)
`uvm_analysis_imp_decl(_uart9)

class uart_ctrl_tx_scbd9 extends uvm_scoreboard;
  bit [7:0] data_to_apb9[$];
  bit [7:0] temp19;
  bit div_en9;

  // Hooks9 to cause in scoroboard9 check errors9
  // This9 resulting9 failure9 is used in MDV9 workshop9 for failure9 analysis9
  `ifdef UVM_WKSHP9
    bit apb_error9;
  `endif

  // Config9 Information9 
  uart_pkg9::uart_config9 uart_cfg9;
  apb_pkg9::apb_slave_config9 slave_cfg9;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd9)
     `uvm_field_object(uart_cfg9, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg9, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb9 #(apb_pkg9::apb_transfer9, uart_ctrl_tx_scbd9) apb_match9;
  uvm_analysis_imp_uart9 #(uart_pkg9::uart_frame9, uart_ctrl_tx_scbd9) uart_add9;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add9  = new("uart_add9", this);
    apb_match9 = new("apb_match9", this);
  endfunction : new

  // implement UART9 Tx9 analysis9 port from reference model
  virtual function void write_uart9(uart_pkg9::uart_frame9 frame9);
    data_to_apb9.push_back(frame9.payload9);	
  endfunction : write_uart9
     
  // implement APB9 READ analysis9 port from reference model
  virtual function void write_apb9(input apb_pkg9::apb_transfer9 transfer9);

    if (transfer9.addr == (slave_cfg9.start_address9 + `LINE_CTRL9)) begin
      div_en9 = transfer9.data[7];
      `uvm_info("SCRBD9",
              $psprintf("LINE_CTRL9 Write with addr = 'h%0h and data = 'h%0h div_en9 = %0b",
              transfer9.addr, transfer9.data, div_en9 ), UVM_HIGH)
    end

    if (!div_en9) begin
    if ((transfer9.addr ==   (slave_cfg9.start_address9 + `RX_FIFO_REG9)) && (transfer9.direction9 == apb_pkg9::APB_READ9))
      begin
       `ifdef UVM_WKSHP9
          corrupt_data9(transfer9);
       `endif
          temp19 = data_to_apb9.pop_front();
       
        if (temp19 == transfer9.data ) 
          `uvm_info("SCRBD9", $psprintf("####### PASS9 : APB9 RECEIVED9 CORRECT9 DATA9 from %s  expected = 'h%0h, received9 = 'h%0h", slave_cfg9.name, temp19, transfer9.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD9", $psprintf("####### FAIL9 : APB9 RECEIVED9 WRONG9 DATA9 from %s", slave_cfg9.name))
          `uvm_info("SCRBD9", $psprintf("expected = 'h%0h, received9 = 'h%0h", temp19, transfer9.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb9
   
  function void assign_cfg9(uart_pkg9::uart_config9 u_cfg9);
    uart_cfg9 = u_cfg9;
  endfunction : assign_cfg9

  function void update_config9(uart_pkg9::uart_config9 u_cfg9);
    `uvm_info(get_type_name(), {"Updating Config9\n", u_cfg9.sprint}, UVM_HIGH)
    uart_cfg9 = u_cfg9;
  endfunction : update_config9

 `ifdef UVM_WKSHP9
    function void corrupt_data9 (apb_pkg9::apb_transfer9 transfer9);
      if (!randomize(apb_error9) with {apb_error9 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL9", $psprintf("Randomization failed for apb_error9"))
      `uvm_info("SCRBD9",(""), UVM_HIGH)
      transfer9.data+=apb_error9;    	
    endfunction : corrupt_data9
  `endif

  // Add task run to debug9 TLM connectivity9 -- dbg_lab69
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG9", "SB: Verify connections9 TX9 of scorebboard9 - using debug_provided_to", UVM_NONE)
      // Implement9 here9 the checks9 
    apb_match9.debug_provided_to();
    uart_add9.debug_provided_to();
      `uvm_info("TX_SCRB_DBG9", "SB: Verify connections9 of TX9 scorebboard9 - using debug_connected_to", UVM_NONE)
      // Implement9 here9 the checks9 
    apb_match9.debug_connected_to();
    uart_add9.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd9

class uart_ctrl_rx_scbd9 extends uvm_scoreboard;
  bit [7:0] data_from_apb9[$];
  bit [7:0] data_to_apb9[$]; // Relevant9 for Remoteloopback9 case only
  bit div_en9;

  bit [7:0] temp19;
  bit [7:0] mask;

  // Hooks9 to cause in scoroboard9 check errors9
  // This9 resulting9 failure9 is used in MDV9 workshop9 for failure9 analysis9
  `ifdef UVM_WKSHP9
    bit uart_error9;
  `endif

  uart_pkg9::uart_config9 uart_cfg9;
  apb_pkg9::apb_slave_config9 slave_cfg9;

  `uvm_component_utils(uart_ctrl_rx_scbd9)
  uvm_analysis_imp_apb9 #(apb_pkg9::apb_transfer9, uart_ctrl_rx_scbd9) apb_add9;
  uvm_analysis_imp_uart9 #(uart_pkg9::uart_frame9, uart_ctrl_rx_scbd9) uart_match9;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match9 = new("uart_match9", this);
    apb_add9    = new("apb_add9", this);
  endfunction : new
   
  // implement APB9 WRITE analysis9 port from reference model
  virtual function void write_apb9(input apb_pkg9::apb_transfer9 transfer9);
    `uvm_info("SCRBD9",
              $psprintf("write_apb9 called with addr = 'h%0h and data = 'h%0h",
              transfer9.addr, transfer9.data), UVM_HIGH)
    if ((transfer9.addr == (slave_cfg9.start_address9 + `LINE_CTRL9)) &&
        (transfer9.direction9 == apb_pkg9::APB_WRITE9)) begin
      div_en9 = transfer9.data[7];
      `uvm_info("SCRBD9",
              $psprintf("LINE_CTRL9 Write with addr = 'h%0h and data = 'h%0h div_en9 = %0b",
              transfer9.addr, transfer9.data, div_en9 ), UVM_HIGH)
    end

    if (!div_en9) begin
      if ((transfer9.addr == (slave_cfg9.start_address9 + `TX_FIFO_REG9)) &&
          (transfer9.direction9 == apb_pkg9::APB_WRITE9)) begin 
        `uvm_info("SCRBD9",
               $psprintf("write_apb9 called pushing9 into queue with data = 'h%0h",
               transfer9.data ), UVM_HIGH)
        data_from_apb9.push_back(transfer9.data);
      end
    end
  endfunction : write_apb9
   
  // implement UART9 Rx9 analysis9 port from reference model
  virtual function void write_uart9( uart_pkg9::uart_frame9 frame9);
    mask = calc_mask9();

    //In case of remote9 loopback9, the data does not get into the rx9/fifo and it gets9 
    // loopbacked9 to ua_txd9. 
    data_to_apb9.push_back(frame9.payload9);	

      temp19 = data_from_apb9.pop_front();

    `ifdef UVM_WKSHP9
        corrupt_payload9 (frame9);
    `endif 
    if ((temp19 & mask) == frame9.payload9) 
      `uvm_info("SCRBD9", $psprintf("####### PASS9 : %s RECEIVED9 CORRECT9 DATA9 expected = 'h%0h, received9 = 'h%0h", slave_cfg9.name, (temp19 & mask), frame9.payload9), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD9", $psprintf("####### FAIL9 : %s RECEIVED9 WRONG9 DATA9", slave_cfg9.name))
      `uvm_info("SCRBD9", $psprintf("expected = 'h%0h, received9 = 'h%0h", temp19, frame9.payload9), UVM_LOW)
    end
  endfunction : write_uart9
   
  function void assign_cfg9(uart_pkg9::uart_config9 u_cfg9);
     uart_cfg9 = u_cfg9;
  endfunction : assign_cfg9
   
  function void update_config9(uart_pkg9::uart_config9 u_cfg9);
   `uvm_info(get_type_name(), {"Updating Config9\n", u_cfg9.sprint}, UVM_HIGH)
    uart_cfg9 = u_cfg9;
  endfunction : update_config9

  function bit[7:0] calc_mask9();
    case (uart_cfg9.char_len_val9)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask9

  `ifdef UVM_WKSHP9
   function void corrupt_payload9 (uart_pkg9::uart_frame9 frame9);
      if(!randomize(uart_error9) with {uart_error9 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL9", $psprintf("Randomization failed for apb_error9"))
      `uvm_info("SCRBD9",(""), UVM_HIGH)
      frame9.payload9+=uart_error9;    	
   endfunction : corrupt_payload9

  `endif

  // Add task run to debug9 TLM connectivity9
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist9;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG9", "SB: Verify connections9 RX9 of scorebboard9 - using debug_provided_to", UVM_NONE)
      // Implement9 here9 the checks9 
    apb_add9.debug_provided_to();
    uart_match9.debug_provided_to();
      `uvm_info("RX_SCRB_DBG9", "SB: Verify connections9 of RX9 scorebboard9 - using debug_connected_to", UVM_NONE)
      // Implement9 here9 the checks9 
    apb_add9.debug_connected_to();
    uart_match9.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd9
