/*-------------------------------------------------------------------------
File3 name   : uart_rx_driver3.sv
Title3       : RX3 Driver3
Project3     :
Created3     :
Description3 : Describes3 UART3 Receiver3 Driver3 for UART3 UVC3
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER3
`define UART_RX_DRIVER3

class uart_rx_driver3 extends uvm_driver #(uart_frame3) ;

  // The virtual interface used to drive3 and view3 HDL signals3.
  virtual interface uart_if3 vif3;

  // handle to  a cfg class
  uart_config3 cfg;

  bit sample_clk3;
  bit [15:0] ua_brgr3;
  bit [7:0] ua_bdiv3;
  int num_of_bits_sent3;
  int num_frames_sent3;

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver3)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr3, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv3, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor3 - required3 UVM syntax3
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive3();
  extern virtual task gen_sample_rate3(ref bit [15:0] ua_brgr3, ref bit sample_clk3);
  extern virtual task send_rx_frame3(input uart_frame3 frame3);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver3

// UVM build_phase
function void uart_rx_driver3::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config3)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG3", "uart_config3 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if3)::get(this, "", "vif3", vif3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver3::run_phase(uvm_phase phase);
  fork
    get_and_drive3();
    gen_sample_rate3(ua_brgr3, sample_clk3);
  join
endtask : run_phase

// reset
task uart_rx_driver3::reset();
  @(negedge vif3.reset);
  `uvm_info(get_type_name(), "Reset3 Asserted3", UVM_MEDIUM)
   vif3.rxd3 = 1;        //Receive3 Data
   vif3.cts_n3 = 0;      //Clear to Send3
   vif3.dsr_n3 = 0;      //Data Set Ready3
   vif3.ri_n3 = 0;       //Ring3 Indicator3
   vif3.baud_clk3 = 0;   //Baud3 Clk3 - NOT3 USED3
endtask : reset

//  get_and3 drive3
task uart_rx_driver3::get_and_drive3();
  while (1) begin
    reset();
    fork
      @(negedge vif3.reset)
        `uvm_info(get_type_name(), "Reset3 asserted3", UVM_LOW)
    begin
      forever begin
        @(posedge vif3.clock3 iff (vif3.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame3(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If3 we3 are in the middle3 of a transfer3, need to end the rx3. Also3,
    //do any reset cleanup3 here3. The only way3 we3 got3 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive3

task uart_rx_driver3::gen_sample_rate3(ref bit [15:0] ua_brgr3, ref bit sample_clk3);
  forever begin
    @(posedge vif3.clock3);
    if (!vif3.reset) begin
      ua_brgr3 = 0;
      sample_clk3 = 0;
    end else begin
      if (ua_brgr3 == ({cfg.baud_rate_div3, cfg.baud_rate_gen3})) begin
        ua_brgr3 = 0;
        sample_clk3 = 1;
      end else begin
        sample_clk3 = 0;
        ua_brgr3++;
      end
    end
  end
endtask : gen_sample_rate3

// -------------------
// send_rx_frame3
// -------------------
task uart_rx_driver3::send_rx_frame3(input uart_frame3 frame3);
  bit [7:0] payload_byte3;
  num_of_bits_sent3 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver3 Sending3 RX3 Frame3...\n%s", frame3.sprint()),
            UVM_HIGH)
 
  repeat (frame3.transmit_delay3)
    @(posedge vif3.clock3);
  void'(this.begin_tr(frame3));
   
  wait((!cfg.rts_en3)||(!vif3.cts_n3));
  `uvm_info(get_type_name(), "Driver3 - Modem3 RTS3 or CTS3 asserted3", UVM_HIGH)

  while (num_of_bits_sent3 <= (1 + cfg.char_len_val3 + cfg.parity_en3 + cfg.nbstop3)) begin
    @(posedge vif3.clock3);
    #1;
    if (sample_clk3) begin
      if (num_of_bits_sent3 == 0) begin
        // Start3 sending3 rx_frame3 with "start bit"
        vif3.rxd3 = frame3.start_bit3;
        `uvm_info(get_type_name(),
                  $psprintf("Driver3 Sending3 Frame3 SOP3: %b", frame3.start_bit3),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent3 > 0) && (num_of_bits_sent3 < (1 + cfg.char_len_val3))) begin
        // sending3 "data bits" 
        payload_byte3 = frame3.payload3[num_of_bits_sent3-1] ;
        vif3.rxd3 = frame3.payload3[num_of_bits_sent3-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver3 Sending3 Frame3 data bit number3:%0d value:'b%b",
             (num_of_bits_sent3-1), payload_byte3), UVM_HIGH)
      end
      if ((num_of_bits_sent3 == (1 + cfg.char_len_val3)) && (cfg.parity_en3)) begin
        // sending3 "parity3 bit" if parity3 is enabled
        vif3.rxd3 = frame3.calc_parity3(cfg.char_len_val3, cfg.parity_mode3);
        `uvm_info(get_type_name(),
             $psprintf("Driver3 Sending3 Frame3 Parity3 bit:'b%b",
             frame3.calc_parity3(cfg.char_len_val3, cfg.parity_mode3)), UVM_HIGH)
      end
      if (num_of_bits_sent3 == (1 + cfg.char_len_val3 + cfg.parity_en3)) begin
        // sending3 "stop/error bits"
        for (int i = 0; i < cfg.nbstop3; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver3 Sending3 Frame3 Stop bit:'b%b",
               frame3.stop_bits3[i]), UVM_HIGH)
          wait (sample_clk3);
          if (frame3.error_bits3[i]) begin
            vif3.rxd3 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver3 intensionally3 corrupting3 Stop bit since3 error_bits3['b%b] is 'b%b", i, frame3.error_bits3[i]),
                 UVM_HIGH)
          end else
          vif3.rxd3 = frame3.stop_bits3[i];
          num_of_bits_sent3++;
          wait (!sample_clk3);
        end
      end
    num_of_bits_sent3++;
    wait (!sample_clk3);
    end
  end
  
  num_frames_sent3++;
  `uvm_info(get_type_name(),
       $psprintf("Frame3 **%0d** Sent3...", num_frames_sent3), UVM_MEDIUM)
  wait (sample_clk3);
  vif3.rxd3 = 1;

  `uvm_info(get_type_name(), "Frame3 complete...", UVM_MEDIUM)
  this.end_tr(frame3);
   
endtask : send_rx_frame3

//UVM report_phase
function void uart_rx_driver3::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART3 Frames3 Sent3:%0d", num_frames_sent3),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER3
