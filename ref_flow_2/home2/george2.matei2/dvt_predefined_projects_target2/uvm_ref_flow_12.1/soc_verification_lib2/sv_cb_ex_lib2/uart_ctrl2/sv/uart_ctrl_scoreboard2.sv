/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_scoreboard2.sv
Title2       : APB2 - UART2 Scoreboard2
Project2     :
Created2     :
Description2 : Scoreboard2 for data integrity2 check between APB2 UVC2 and UART2 UVC2
Notes2       : Two2 similar2 scoreboards2 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb2)
`uvm_analysis_imp_decl(_uart2)

class uart_ctrl_tx_scbd2 extends uvm_scoreboard;
  bit [7:0] data_to_apb2[$];
  bit [7:0] temp12;
  bit div_en2;

  // Hooks2 to cause in scoroboard2 check errors2
  // This2 resulting2 failure2 is used in MDV2 workshop2 for failure2 analysis2
  `ifdef UVM_WKSHP2
    bit apb_error2;
  `endif

  // Config2 Information2 
  uart_pkg2::uart_config2 uart_cfg2;
  apb_pkg2::apb_slave_config2 slave_cfg2;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd2)
     `uvm_field_object(uart_cfg2, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg2, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb2 #(apb_pkg2::apb_transfer2, uart_ctrl_tx_scbd2) apb_match2;
  uvm_analysis_imp_uart2 #(uart_pkg2::uart_frame2, uart_ctrl_tx_scbd2) uart_add2;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add2  = new("uart_add2", this);
    apb_match2 = new("apb_match2", this);
  endfunction : new

  // implement UART2 Tx2 analysis2 port from reference model
  virtual function void write_uart2(uart_pkg2::uart_frame2 frame2);
    data_to_apb2.push_back(frame2.payload2);	
  endfunction : write_uart2
     
  // implement APB2 READ analysis2 port from reference model
  virtual function void write_apb2(input apb_pkg2::apb_transfer2 transfer2);

    if (transfer2.addr == (slave_cfg2.start_address2 + `LINE_CTRL2)) begin
      div_en2 = transfer2.data[7];
      `uvm_info("SCRBD2",
              $psprintf("LINE_CTRL2 Write with addr = 'h%0h and data = 'h%0h div_en2 = %0b",
              transfer2.addr, transfer2.data, div_en2 ), UVM_HIGH)
    end

    if (!div_en2) begin
    if ((transfer2.addr ==   (slave_cfg2.start_address2 + `RX_FIFO_REG2)) && (transfer2.direction2 == apb_pkg2::APB_READ2))
      begin
       `ifdef UVM_WKSHP2
          corrupt_data2(transfer2);
       `endif
          temp12 = data_to_apb2.pop_front();
       
        if (temp12 == transfer2.data ) 
          `uvm_info("SCRBD2", $psprintf("####### PASS2 : APB2 RECEIVED2 CORRECT2 DATA2 from %s  expected = 'h%0h, received2 = 'h%0h", slave_cfg2.name, temp12, transfer2.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD2", $psprintf("####### FAIL2 : APB2 RECEIVED2 WRONG2 DATA2 from %s", slave_cfg2.name))
          `uvm_info("SCRBD2", $psprintf("expected = 'h%0h, received2 = 'h%0h", temp12, transfer2.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb2
   
  function void assign_cfg2(uart_pkg2::uart_config2 u_cfg2);
    uart_cfg2 = u_cfg2;
  endfunction : assign_cfg2

  function void update_config2(uart_pkg2::uart_config2 u_cfg2);
    `uvm_info(get_type_name(), {"Updating Config2\n", u_cfg2.sprint}, UVM_HIGH)
    uart_cfg2 = u_cfg2;
  endfunction : update_config2

 `ifdef UVM_WKSHP2
    function void corrupt_data2 (apb_pkg2::apb_transfer2 transfer2);
      if (!randomize(apb_error2) with {apb_error2 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL2", $psprintf("Randomization failed for apb_error2"))
      `uvm_info("SCRBD2",(""), UVM_HIGH)
      transfer2.data+=apb_error2;    	
    endfunction : corrupt_data2
  `endif

  // Add task run to debug2 TLM connectivity2 -- dbg_lab62
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG2", "SB: Verify connections2 TX2 of scorebboard2 - using debug_provided_to", UVM_NONE)
      // Implement2 here2 the checks2 
    apb_match2.debug_provided_to();
    uart_add2.debug_provided_to();
      `uvm_info("TX_SCRB_DBG2", "SB: Verify connections2 of TX2 scorebboard2 - using debug_connected_to", UVM_NONE)
      // Implement2 here2 the checks2 
    apb_match2.debug_connected_to();
    uart_add2.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd2

class uart_ctrl_rx_scbd2 extends uvm_scoreboard;
  bit [7:0] data_from_apb2[$];
  bit [7:0] data_to_apb2[$]; // Relevant2 for Remoteloopback2 case only
  bit div_en2;

  bit [7:0] temp12;
  bit [7:0] mask;

  // Hooks2 to cause in scoroboard2 check errors2
  // This2 resulting2 failure2 is used in MDV2 workshop2 for failure2 analysis2
  `ifdef UVM_WKSHP2
    bit uart_error2;
  `endif

  uart_pkg2::uart_config2 uart_cfg2;
  apb_pkg2::apb_slave_config2 slave_cfg2;

  `uvm_component_utils(uart_ctrl_rx_scbd2)
  uvm_analysis_imp_apb2 #(apb_pkg2::apb_transfer2, uart_ctrl_rx_scbd2) apb_add2;
  uvm_analysis_imp_uart2 #(uart_pkg2::uart_frame2, uart_ctrl_rx_scbd2) uart_match2;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match2 = new("uart_match2", this);
    apb_add2    = new("apb_add2", this);
  endfunction : new
   
  // implement APB2 WRITE analysis2 port from reference model
  virtual function void write_apb2(input apb_pkg2::apb_transfer2 transfer2);
    `uvm_info("SCRBD2",
              $psprintf("write_apb2 called with addr = 'h%0h and data = 'h%0h",
              transfer2.addr, transfer2.data), UVM_HIGH)
    if ((transfer2.addr == (slave_cfg2.start_address2 + `LINE_CTRL2)) &&
        (transfer2.direction2 == apb_pkg2::APB_WRITE2)) begin
      div_en2 = transfer2.data[7];
      `uvm_info("SCRBD2",
              $psprintf("LINE_CTRL2 Write with addr = 'h%0h and data = 'h%0h div_en2 = %0b",
              transfer2.addr, transfer2.data, div_en2 ), UVM_HIGH)
    end

    if (!div_en2) begin
      if ((transfer2.addr == (slave_cfg2.start_address2 + `TX_FIFO_REG2)) &&
          (transfer2.direction2 == apb_pkg2::APB_WRITE2)) begin 
        `uvm_info("SCRBD2",
               $psprintf("write_apb2 called pushing2 into queue with data = 'h%0h",
               transfer2.data ), UVM_HIGH)
        data_from_apb2.push_back(transfer2.data);
      end
    end
  endfunction : write_apb2
   
  // implement UART2 Rx2 analysis2 port from reference model
  virtual function void write_uart2( uart_pkg2::uart_frame2 frame2);
    mask = calc_mask2();

    //In case of remote2 loopback2, the data does not get into the rx2/fifo and it gets2 
    // loopbacked2 to ua_txd2. 
    data_to_apb2.push_back(frame2.payload2);	

      temp12 = data_from_apb2.pop_front();

    `ifdef UVM_WKSHP2
        corrupt_payload2 (frame2);
    `endif 
    if ((temp12 & mask) == frame2.payload2) 
      `uvm_info("SCRBD2", $psprintf("####### PASS2 : %s RECEIVED2 CORRECT2 DATA2 expected = 'h%0h, received2 = 'h%0h", slave_cfg2.name, (temp12 & mask), frame2.payload2), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD2", $psprintf("####### FAIL2 : %s RECEIVED2 WRONG2 DATA2", slave_cfg2.name))
      `uvm_info("SCRBD2", $psprintf("expected = 'h%0h, received2 = 'h%0h", temp12, frame2.payload2), UVM_LOW)
    end
  endfunction : write_uart2
   
  function void assign_cfg2(uart_pkg2::uart_config2 u_cfg2);
     uart_cfg2 = u_cfg2;
  endfunction : assign_cfg2
   
  function void update_config2(uart_pkg2::uart_config2 u_cfg2);
   `uvm_info(get_type_name(), {"Updating Config2\n", u_cfg2.sprint}, UVM_HIGH)
    uart_cfg2 = u_cfg2;
  endfunction : update_config2

  function bit[7:0] calc_mask2();
    case (uart_cfg2.char_len_val2)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask2

  `ifdef UVM_WKSHP2
   function void corrupt_payload2 (uart_pkg2::uart_frame2 frame2);
      if(!randomize(uart_error2) with {uart_error2 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL2", $psprintf("Randomization failed for apb_error2"))
      `uvm_info("SCRBD2",(""), UVM_HIGH)
      frame2.payload2+=uart_error2;    	
   endfunction : corrupt_payload2

  `endif

  // Add task run to debug2 TLM connectivity2
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist2;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG2", "SB: Verify connections2 RX2 of scorebboard2 - using debug_provided_to", UVM_NONE)
      // Implement2 here2 the checks2 
    apb_add2.debug_provided_to();
    uart_match2.debug_provided_to();
      `uvm_info("RX_SCRB_DBG2", "SB: Verify connections2 of RX2 scorebboard2 - using debug_connected_to", UVM_NONE)
      // Implement2 here2 the checks2 
    apb_add2.debug_connected_to();
    uart_match2.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd2
