/*-------------------------------------------------------------------------
File1 name   : uart_ctrl_scoreboard1.sv
Title1       : APB1 - UART1 Scoreboard1
Project1     :
Created1     :
Description1 : Scoreboard1 for data integrity1 check between APB1 UVC1 and UART1 UVC1
Notes1       : Two1 similar1 scoreboards1 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb1)
`uvm_analysis_imp_decl(_uart1)

class uart_ctrl_tx_scbd1 extends uvm_scoreboard;
  bit [7:0] data_to_apb1[$];
  bit [7:0] temp11;
  bit div_en1;

  // Hooks1 to cause in scoroboard1 check errors1
  // This1 resulting1 failure1 is used in MDV1 workshop1 for failure1 analysis1
  `ifdef UVM_WKSHP1
    bit apb_error1;
  `endif

  // Config1 Information1 
  uart_pkg1::uart_config1 uart_cfg1;
  apb_pkg1::apb_slave_config1 slave_cfg1;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd1)
     `uvm_field_object(uart_cfg1, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg1, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb1 #(apb_pkg1::apb_transfer1, uart_ctrl_tx_scbd1) apb_match1;
  uvm_analysis_imp_uart1 #(uart_pkg1::uart_frame1, uart_ctrl_tx_scbd1) uart_add1;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add1  = new("uart_add1", this);
    apb_match1 = new("apb_match1", this);
  endfunction : new

  // implement UART1 Tx1 analysis1 port from reference model
  virtual function void write_uart1(uart_pkg1::uart_frame1 frame1);
    data_to_apb1.push_back(frame1.payload1);	
  endfunction : write_uart1
     
  // implement APB1 READ analysis1 port from reference model
  virtual function void write_apb1(input apb_pkg1::apb_transfer1 transfer1);

    if (transfer1.addr == (slave_cfg1.start_address1 + `LINE_CTRL1)) begin
      div_en1 = transfer1.data[7];
      `uvm_info("SCRBD1",
              $psprintf("LINE_CTRL1 Write with addr = 'h%0h and data = 'h%0h div_en1 = %0b",
              transfer1.addr, transfer1.data, div_en1 ), UVM_HIGH)
    end

    if (!div_en1) begin
    if ((transfer1.addr ==   (slave_cfg1.start_address1 + `RX_FIFO_REG1)) && (transfer1.direction1 == apb_pkg1::APB_READ1))
      begin
       `ifdef UVM_WKSHP1
          corrupt_data1(transfer1);
       `endif
          temp11 = data_to_apb1.pop_front();
       
        if (temp11 == transfer1.data ) 
          `uvm_info("SCRBD1", $psprintf("####### PASS1 : APB1 RECEIVED1 CORRECT1 DATA1 from %s  expected = 'h%0h, received1 = 'h%0h", slave_cfg1.name, temp11, transfer1.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD1", $psprintf("####### FAIL1 : APB1 RECEIVED1 WRONG1 DATA1 from %s", slave_cfg1.name))
          `uvm_info("SCRBD1", $psprintf("expected = 'h%0h, received1 = 'h%0h", temp11, transfer1.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb1
   
  function void assign_cfg1(uart_pkg1::uart_config1 u_cfg1);
    uart_cfg1 = u_cfg1;
  endfunction : assign_cfg1

  function void update_config1(uart_pkg1::uart_config1 u_cfg1);
    `uvm_info(get_type_name(), {"Updating Config1\n", u_cfg1.sprint}, UVM_HIGH)
    uart_cfg1 = u_cfg1;
  endfunction : update_config1

 `ifdef UVM_WKSHP1
    function void corrupt_data1 (apb_pkg1::apb_transfer1 transfer1);
      if (!randomize(apb_error1) with {apb_error1 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL1", $psprintf("Randomization failed for apb_error1"))
      `uvm_info("SCRBD1",(""), UVM_HIGH)
      transfer1.data+=apb_error1;    	
    endfunction : corrupt_data1
  `endif

  // Add task run to debug1 TLM connectivity1 -- dbg_lab61
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG1", "SB: Verify connections1 TX1 of scorebboard1 - using debug_provided_to", UVM_NONE)
      // Implement1 here1 the checks1 
    apb_match1.debug_provided_to();
    uart_add1.debug_provided_to();
      `uvm_info("TX_SCRB_DBG1", "SB: Verify connections1 of TX1 scorebboard1 - using debug_connected_to", UVM_NONE)
      // Implement1 here1 the checks1 
    apb_match1.debug_connected_to();
    uart_add1.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd1

class uart_ctrl_rx_scbd1 extends uvm_scoreboard;
  bit [7:0] data_from_apb1[$];
  bit [7:0] data_to_apb1[$]; // Relevant1 for Remoteloopback1 case only
  bit div_en1;

  bit [7:0] temp11;
  bit [7:0] mask;

  // Hooks1 to cause in scoroboard1 check errors1
  // This1 resulting1 failure1 is used in MDV1 workshop1 for failure1 analysis1
  `ifdef UVM_WKSHP1
    bit uart_error1;
  `endif

  uart_pkg1::uart_config1 uart_cfg1;
  apb_pkg1::apb_slave_config1 slave_cfg1;

  `uvm_component_utils(uart_ctrl_rx_scbd1)
  uvm_analysis_imp_apb1 #(apb_pkg1::apb_transfer1, uart_ctrl_rx_scbd1) apb_add1;
  uvm_analysis_imp_uart1 #(uart_pkg1::uart_frame1, uart_ctrl_rx_scbd1) uart_match1;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match1 = new("uart_match1", this);
    apb_add1    = new("apb_add1", this);
  endfunction : new
   
  // implement APB1 WRITE analysis1 port from reference model
  virtual function void write_apb1(input apb_pkg1::apb_transfer1 transfer1);
    `uvm_info("SCRBD1",
              $psprintf("write_apb1 called with addr = 'h%0h and data = 'h%0h",
              transfer1.addr, transfer1.data), UVM_HIGH)
    if ((transfer1.addr == (slave_cfg1.start_address1 + `LINE_CTRL1)) &&
        (transfer1.direction1 == apb_pkg1::APB_WRITE1)) begin
      div_en1 = transfer1.data[7];
      `uvm_info("SCRBD1",
              $psprintf("LINE_CTRL1 Write with addr = 'h%0h and data = 'h%0h div_en1 = %0b",
              transfer1.addr, transfer1.data, div_en1 ), UVM_HIGH)
    end

    if (!div_en1) begin
      if ((transfer1.addr == (slave_cfg1.start_address1 + `TX_FIFO_REG1)) &&
          (transfer1.direction1 == apb_pkg1::APB_WRITE1)) begin 
        `uvm_info("SCRBD1",
               $psprintf("write_apb1 called pushing1 into queue with data = 'h%0h",
               transfer1.data ), UVM_HIGH)
        data_from_apb1.push_back(transfer1.data);
      end
    end
  endfunction : write_apb1
   
  // implement UART1 Rx1 analysis1 port from reference model
  virtual function void write_uart1( uart_pkg1::uart_frame1 frame1);
    mask = calc_mask1();

    //In case of remote1 loopback1, the data does not get into the rx1/fifo and it gets1 
    // loopbacked1 to ua_txd1. 
    data_to_apb1.push_back(frame1.payload1);	

      temp11 = data_from_apb1.pop_front();

    `ifdef UVM_WKSHP1
        corrupt_payload1 (frame1);
    `endif 
    if ((temp11 & mask) == frame1.payload1) 
      `uvm_info("SCRBD1", $psprintf("####### PASS1 : %s RECEIVED1 CORRECT1 DATA1 expected = 'h%0h, received1 = 'h%0h", slave_cfg1.name, (temp11 & mask), frame1.payload1), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD1", $psprintf("####### FAIL1 : %s RECEIVED1 WRONG1 DATA1", slave_cfg1.name))
      `uvm_info("SCRBD1", $psprintf("expected = 'h%0h, received1 = 'h%0h", temp11, frame1.payload1), UVM_LOW)
    end
  endfunction : write_uart1
   
  function void assign_cfg1(uart_pkg1::uart_config1 u_cfg1);
     uart_cfg1 = u_cfg1;
  endfunction : assign_cfg1
   
  function void update_config1(uart_pkg1::uart_config1 u_cfg1);
   `uvm_info(get_type_name(), {"Updating Config1\n", u_cfg1.sprint}, UVM_HIGH)
    uart_cfg1 = u_cfg1;
  endfunction : update_config1

  function bit[7:0] calc_mask1();
    case (uart_cfg1.char_len_val1)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask1

  `ifdef UVM_WKSHP1
   function void corrupt_payload1 (uart_pkg1::uart_frame1 frame1);
      if(!randomize(uart_error1) with {uart_error1 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL1", $psprintf("Randomization failed for apb_error1"))
      `uvm_info("SCRBD1",(""), UVM_HIGH)
      frame1.payload1+=uart_error1;    	
   endfunction : corrupt_payload1

  `endif

  // Add task run to debug1 TLM connectivity1
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist1;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG1", "SB: Verify connections1 RX1 of scorebboard1 - using debug_provided_to", UVM_NONE)
      // Implement1 here1 the checks1 
    apb_add1.debug_provided_to();
    uart_match1.debug_provided_to();
      `uvm_info("RX_SCRB_DBG1", "SB: Verify connections1 of RX1 scorebboard1 - using debug_connected_to", UVM_NONE)
      // Implement1 here1 the checks1 
    apb_add1.debug_connected_to();
    uart_match1.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd1
