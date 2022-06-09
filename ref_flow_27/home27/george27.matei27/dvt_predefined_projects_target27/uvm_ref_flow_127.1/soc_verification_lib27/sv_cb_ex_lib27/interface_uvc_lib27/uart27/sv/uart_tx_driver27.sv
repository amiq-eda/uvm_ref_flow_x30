/*-------------------------------------------------------------------------
File27 name   : uart_tx_driver27.sv
Title27       : TX27 Driver27
Project27     :
Created27     :
Description27 : Describes27 UART27 Trasmit27 Driver27 for UART27 UVC27
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER27
`define UART_TX_DRIVER27

class uart_tx_driver27 extends uvm_driver #(uart_frame27) ;

  // The virtual interface used to drive27 and view27 HDL signals27.
  virtual interface uart_if27 vif27;

  // handle to  a cfg class
  uart_config27 cfg;

  bit sample_clk27;
  bit baud_clk27;
  bit [15:0] ua_brgr27;
  bit [7:0] ua_bdiv27;
  int num_of_bits_sent27;
  int num_frames_sent27;

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver27)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk27, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk27, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr27, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv27, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor27 - required27 UVM syntax27
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive27();
  extern virtual task gen_sample_rate27(ref bit [15:0] ua_brgr27, ref bit sample_clk27);
  extern virtual task send_tx_frame27(input uart_frame27 frame27);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver27

// UVM build_phase
function void uart_tx_driver27::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config27)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG27", "uart_config27 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if27)::get(this, "", "vif27", vif27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver27::run_phase(uvm_phase phase);
  fork
    get_and_drive27();
    gen_sample_rate27(ua_brgr27, sample_clk27);
  join
endtask : run_phase

// reset
task uart_tx_driver27::reset();
  @(negedge vif27.reset);
  `uvm_info(get_type_name(), "Reset27 Asserted27", UVM_MEDIUM)
   vif27.txd27 = 1;        //Transmit27 Data
   vif27.rts_n27 = 0;      //Request27 to Send27
   vif27.dtr_n27 = 0;      //Data Terminal27 Ready27
   vif27.dcd_n27 = 0;      //Data Carrier27 Detect27
   vif27.baud_clk27 = 0;       //Baud27 Data
endtask : reset

//  get_and27 drive27
task uart_tx_driver27::get_and_drive27();
  while (1) begin
    reset();
    fork
      @(negedge vif27.reset)
        `uvm_info(get_type_name(), "Reset27 asserted27", UVM_LOW)
    begin
      forever begin
        @(posedge vif27.clock27 iff (vif27.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame27(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If27 we27 are in the middle27 of a transfer27, need to end the tx27. Also27,
    //do any reset cleanup27 here27. The only way27 we27 got27 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive27

task uart_tx_driver27::gen_sample_rate27(ref bit [15:0] ua_brgr27, ref bit sample_clk27);
  forever begin
    @(posedge vif27.clock27);
    if (!vif27.reset) begin
      ua_brgr27 = 0;
      sample_clk27 = 0;
    end else begin
      if (ua_brgr27 == ({cfg.baud_rate_div27, cfg.baud_rate_gen27})) begin
        ua_brgr27 = 0;
        sample_clk27 = 1;
      end else begin
        sample_clk27 = 0;
        ua_brgr27++;
      end
    end
  end
endtask : gen_sample_rate27

// -------------------
// send_tx_frame27
// -------------------
task uart_tx_driver27::send_tx_frame27(input uart_frame27 frame27);
  bit [7:0] payload_byte27;
  num_of_bits_sent27 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver27 Sending27 TX27 Frame27...\n%s", frame27.sprint()),
            UVM_HIGH)
 
  repeat (frame27.transmit_delay27)
    @(posedge vif27.clock27);
  void'(this.begin_tr(frame27));
   
  wait((!cfg.rts_en27)||(!vif27.cts_n27));
  `uvm_info(get_type_name(), "Driver27 - Modem27 RTS27 or CTS27 asserted27", UVM_HIGH)

  while (num_of_bits_sent27 <= (1 + cfg.char_len_val27 + cfg.parity_en27 + cfg.nbstop27)) begin
    @(posedge vif27.clock27);
    #1;
    if (sample_clk27) begin
      if (num_of_bits_sent27 == 0) begin
        // Start27 sending27 tx_frame27 with "start bit"
        vif27.txd27 = frame27.start_bit27;
        `uvm_info(get_type_name(),
                  $psprintf("Driver27 Sending27 Frame27 SOP27: %b", frame27.start_bit27),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent27 > 0) && (num_of_bits_sent27 < (1 + cfg.char_len_val27))) begin
        // sending27 "data bits" 
        payload_byte27 = frame27.payload27[num_of_bits_sent27-1] ;
        vif27.txd27 = frame27.payload27[num_of_bits_sent27-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver27 Sending27 Frame27 data bit number27:%0d value:'b%b",
             (num_of_bits_sent27-1), payload_byte27), UVM_HIGH)
      end
      if ((num_of_bits_sent27 == (1 + cfg.char_len_val27)) && (cfg.parity_en27)) begin
        // sending27 "parity27 bit" if parity27 is enabled
        vif27.txd27 = frame27.calc_parity27(cfg.char_len_val27, cfg.parity_mode27);
        `uvm_info(get_type_name(),
             $psprintf("Driver27 Sending27 Frame27 Parity27 bit:'b%b",
             frame27.calc_parity27(cfg.char_len_val27, cfg.parity_mode27)), UVM_HIGH)
      end
      if (num_of_bits_sent27 == (1 + cfg.char_len_val27 + cfg.parity_en27)) begin
        // sending27 "stop/error bits"
        for (int i = 0; i < cfg.nbstop27; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver27 Sending27 Frame27 Stop bit:'b%b",
               frame27.stop_bits27[i]), UVM_HIGH)
          wait (sample_clk27);
          if (frame27.error_bits27[i]) begin
            vif27.txd27 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver27 intensionally27 corrupting27 Stop bit since27 error_bits27['b%b] is 'b%b", i, frame27.error_bits27[i]),
                 UVM_HIGH)
          end else
          vif27.txd27 = frame27.stop_bits27[i];
          num_of_bits_sent27++;
          wait (!sample_clk27);
        end
      end
    num_of_bits_sent27++;
    wait (!sample_clk27);
    end
  end
  
  num_frames_sent27++;
  `uvm_info(get_type_name(),
       $psprintf("Frame27 **%0d** Sent27...", num_frames_sent27), UVM_MEDIUM)
  wait (sample_clk27);
  vif27.txd27 = 1;

  `uvm_info(get_type_name(), "Frame27 complete...", UVM_MEDIUM)
  this.end_tr(frame27);
   
endtask : send_tx_frame27

//UVM report_phase
function void uart_tx_driver27::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART27 Frames27 Sent27:%0d", num_frames_sent27),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER27
