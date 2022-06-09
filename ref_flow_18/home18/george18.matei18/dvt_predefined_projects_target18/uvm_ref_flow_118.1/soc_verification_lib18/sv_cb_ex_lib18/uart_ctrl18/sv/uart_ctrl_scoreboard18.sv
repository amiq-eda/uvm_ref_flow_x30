/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_scoreboard18.sv
Title18       : APB18 - UART18 Scoreboard18
Project18     :
Created18     :
Description18 : Scoreboard18 for data integrity18 check between APB18 UVC18 and UART18 UVC18
Notes18       : Two18 similar18 scoreboards18 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb18)
`uvm_analysis_imp_decl(_uart18)

class uart_ctrl_tx_scbd18 extends uvm_scoreboard;
  bit [7:0] data_to_apb18[$];
  bit [7:0] temp118;
  bit div_en18;

  // Hooks18 to cause in scoroboard18 check errors18
  // This18 resulting18 failure18 is used in MDV18 workshop18 for failure18 analysis18
  `ifdef UVM_WKSHP18
    bit apb_error18;
  `endif

  // Config18 Information18 
  uart_pkg18::uart_config18 uart_cfg18;
  apb_pkg18::apb_slave_config18 slave_cfg18;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd18)
     `uvm_field_object(uart_cfg18, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg18, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb18 #(apb_pkg18::apb_transfer18, uart_ctrl_tx_scbd18) apb_match18;
  uvm_analysis_imp_uart18 #(uart_pkg18::uart_frame18, uart_ctrl_tx_scbd18) uart_add18;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add18  = new("uart_add18", this);
    apb_match18 = new("apb_match18", this);
  endfunction : new

  // implement UART18 Tx18 analysis18 port from reference model
  virtual function void write_uart18(uart_pkg18::uart_frame18 frame18);
    data_to_apb18.push_back(frame18.payload18);	
  endfunction : write_uart18
     
  // implement APB18 READ analysis18 port from reference model
  virtual function void write_apb18(input apb_pkg18::apb_transfer18 transfer18);

    if (transfer18.addr == (slave_cfg18.start_address18 + `LINE_CTRL18)) begin
      div_en18 = transfer18.data[7];
      `uvm_info("SCRBD18",
              $psprintf("LINE_CTRL18 Write with addr = 'h%0h and data = 'h%0h div_en18 = %0b",
              transfer18.addr, transfer18.data, div_en18 ), UVM_HIGH)
    end

    if (!div_en18) begin
    if ((transfer18.addr ==   (slave_cfg18.start_address18 + `RX_FIFO_REG18)) && (transfer18.direction18 == apb_pkg18::APB_READ18))
      begin
       `ifdef UVM_WKSHP18
          corrupt_data18(transfer18);
       `endif
          temp118 = data_to_apb18.pop_front();
       
        if (temp118 == transfer18.data ) 
          `uvm_info("SCRBD18", $psprintf("####### PASS18 : APB18 RECEIVED18 CORRECT18 DATA18 from %s  expected = 'h%0h, received18 = 'h%0h", slave_cfg18.name, temp118, transfer18.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD18", $psprintf("####### FAIL18 : APB18 RECEIVED18 WRONG18 DATA18 from %s", slave_cfg18.name))
          `uvm_info("SCRBD18", $psprintf("expected = 'h%0h, received18 = 'h%0h", temp118, transfer18.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb18
   
  function void assign_cfg18(uart_pkg18::uart_config18 u_cfg18);
    uart_cfg18 = u_cfg18;
  endfunction : assign_cfg18

  function void update_config18(uart_pkg18::uart_config18 u_cfg18);
    `uvm_info(get_type_name(), {"Updating Config18\n", u_cfg18.sprint}, UVM_HIGH)
    uart_cfg18 = u_cfg18;
  endfunction : update_config18

 `ifdef UVM_WKSHP18
    function void corrupt_data18 (apb_pkg18::apb_transfer18 transfer18);
      if (!randomize(apb_error18) with {apb_error18 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL18", $psprintf("Randomization failed for apb_error18"))
      `uvm_info("SCRBD18",(""), UVM_HIGH)
      transfer18.data+=apb_error18;    	
    endfunction : corrupt_data18
  `endif

  // Add task run to debug18 TLM connectivity18 -- dbg_lab618
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG18", "SB: Verify connections18 TX18 of scorebboard18 - using debug_provided_to", UVM_NONE)
      // Implement18 here18 the checks18 
    apb_match18.debug_provided_to();
    uart_add18.debug_provided_to();
      `uvm_info("TX_SCRB_DBG18", "SB: Verify connections18 of TX18 scorebboard18 - using debug_connected_to", UVM_NONE)
      // Implement18 here18 the checks18 
    apb_match18.debug_connected_to();
    uart_add18.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd18

class uart_ctrl_rx_scbd18 extends uvm_scoreboard;
  bit [7:0] data_from_apb18[$];
  bit [7:0] data_to_apb18[$]; // Relevant18 for Remoteloopback18 case only
  bit div_en18;

  bit [7:0] temp118;
  bit [7:0] mask;

  // Hooks18 to cause in scoroboard18 check errors18
  // This18 resulting18 failure18 is used in MDV18 workshop18 for failure18 analysis18
  `ifdef UVM_WKSHP18
    bit uart_error18;
  `endif

  uart_pkg18::uart_config18 uart_cfg18;
  apb_pkg18::apb_slave_config18 slave_cfg18;

  `uvm_component_utils(uart_ctrl_rx_scbd18)
  uvm_analysis_imp_apb18 #(apb_pkg18::apb_transfer18, uart_ctrl_rx_scbd18) apb_add18;
  uvm_analysis_imp_uart18 #(uart_pkg18::uart_frame18, uart_ctrl_rx_scbd18) uart_match18;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match18 = new("uart_match18", this);
    apb_add18    = new("apb_add18", this);
  endfunction : new
   
  // implement APB18 WRITE analysis18 port from reference model
  virtual function void write_apb18(input apb_pkg18::apb_transfer18 transfer18);
    `uvm_info("SCRBD18",
              $psprintf("write_apb18 called with addr = 'h%0h and data = 'h%0h",
              transfer18.addr, transfer18.data), UVM_HIGH)
    if ((transfer18.addr == (slave_cfg18.start_address18 + `LINE_CTRL18)) &&
        (transfer18.direction18 == apb_pkg18::APB_WRITE18)) begin
      div_en18 = transfer18.data[7];
      `uvm_info("SCRBD18",
              $psprintf("LINE_CTRL18 Write with addr = 'h%0h and data = 'h%0h div_en18 = %0b",
              transfer18.addr, transfer18.data, div_en18 ), UVM_HIGH)
    end

    if (!div_en18) begin
      if ((transfer18.addr == (slave_cfg18.start_address18 + `TX_FIFO_REG18)) &&
          (transfer18.direction18 == apb_pkg18::APB_WRITE18)) begin 
        `uvm_info("SCRBD18",
               $psprintf("write_apb18 called pushing18 into queue with data = 'h%0h",
               transfer18.data ), UVM_HIGH)
        data_from_apb18.push_back(transfer18.data);
      end
    end
  endfunction : write_apb18
   
  // implement UART18 Rx18 analysis18 port from reference model
  virtual function void write_uart18( uart_pkg18::uart_frame18 frame18);
    mask = calc_mask18();

    //In case of remote18 loopback18, the data does not get into the rx18/fifo and it gets18 
    // loopbacked18 to ua_txd18. 
    data_to_apb18.push_back(frame18.payload18);	

      temp118 = data_from_apb18.pop_front();

    `ifdef UVM_WKSHP18
        corrupt_payload18 (frame18);
    `endif 
    if ((temp118 & mask) == frame18.payload18) 
      `uvm_info("SCRBD18", $psprintf("####### PASS18 : %s RECEIVED18 CORRECT18 DATA18 expected = 'h%0h, received18 = 'h%0h", slave_cfg18.name, (temp118 & mask), frame18.payload18), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD18", $psprintf("####### FAIL18 : %s RECEIVED18 WRONG18 DATA18", slave_cfg18.name))
      `uvm_info("SCRBD18", $psprintf("expected = 'h%0h, received18 = 'h%0h", temp118, frame18.payload18), UVM_LOW)
    end
  endfunction : write_uart18
   
  function void assign_cfg18(uart_pkg18::uart_config18 u_cfg18);
     uart_cfg18 = u_cfg18;
  endfunction : assign_cfg18
   
  function void update_config18(uart_pkg18::uart_config18 u_cfg18);
   `uvm_info(get_type_name(), {"Updating Config18\n", u_cfg18.sprint}, UVM_HIGH)
    uart_cfg18 = u_cfg18;
  endfunction : update_config18

  function bit[7:0] calc_mask18();
    case (uart_cfg18.char_len_val18)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask18

  `ifdef UVM_WKSHP18
   function void corrupt_payload18 (uart_pkg18::uart_frame18 frame18);
      if(!randomize(uart_error18) with {uart_error18 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL18", $psprintf("Randomization failed for apb_error18"))
      `uvm_info("SCRBD18",(""), UVM_HIGH)
      frame18.payload18+=uart_error18;    	
   endfunction : corrupt_payload18

  `endif

  // Add task run to debug18 TLM connectivity18
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist18;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG18", "SB: Verify connections18 RX18 of scorebboard18 - using debug_provided_to", UVM_NONE)
      // Implement18 here18 the checks18 
    apb_add18.debug_provided_to();
    uart_match18.debug_provided_to();
      `uvm_info("RX_SCRB_DBG18", "SB: Verify connections18 of RX18 scorebboard18 - using debug_connected_to", UVM_NONE)
      // Implement18 here18 the checks18 
    apb_add18.debug_connected_to();
    uart_match18.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd18
