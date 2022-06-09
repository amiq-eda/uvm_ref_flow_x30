/*-------------------------------------------------------------------------
File1 name   : uart_rx_driver1.sv
Title1       : RX1 Driver1
Project1     :
Created1     :
Description1 : Describes1 UART1 Receiver1 Driver1 for UART1 UVC1
Notes1       :  
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

`ifndef UART_RX_DRIVER1
`define UART_RX_DRIVER1

class uart_rx_driver1 extends uvm_driver #(uart_frame1) ;

  // The virtual interface used to drive1 and view1 HDL signals1.
  virtual interface uart_if1 vif1;

  // handle to  a cfg class
  uart_config1 cfg;

  bit sample_clk1;
  bit [15:0] ua_brgr1;
  bit [7:0] ua_bdiv1;
  int num_of_bits_sent1;
  int num_frames_sent1;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver1)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr1, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv1, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor1 - required1 UVM syntax1
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive1();
  extern virtual task gen_sample_rate1(ref bit [15:0] ua_brgr1, ref bit sample_clk1);
  extern virtual task send_rx_frame1(input uart_frame1 frame1);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver1

// UVM build_phase
function void uart_rx_driver1::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config1)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG1", "uart_config1 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if1)::get(this, "", "vif1", vif1))
   `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver1::run_phase(uvm_phase phase);
  fork
    get_and_drive1();
    gen_sample_rate1(ua_brgr1, sample_clk1);
  join
endtask : run_phase

// reset
task uart_rx_driver1::reset();
  @(negedge vif1.reset);
  `uvm_info(get_type_name(), "Reset1 Asserted1", UVM_MEDIUM)
   vif1.rxd1 = 1;        //Receive1 Data
   vif1.cts_n1 = 0;      //Clear to Send1
   vif1.dsr_n1 = 0;      //Data Set Ready1
   vif1.ri_n1 = 0;       //Ring1 Indicator1
   vif1.baud_clk1 = 0;   //Baud1 Clk1 - NOT1 USED1
endtask : reset

//  get_and1 drive1
task uart_rx_driver1::get_and_drive1();
  while (1) begin
    reset();
    fork
      @(negedge vif1.reset)
        `uvm_info(get_type_name(), "Reset1 asserted1", UVM_LOW)
    begin
      forever begin
        @(posedge vif1.clock1 iff (vif1.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame1(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If1 we1 are in the middle1 of a transfer1, need to end the rx1. Also1,
    //do any reset cleanup1 here1. The only way1 we1 got1 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive1

task uart_rx_driver1::gen_sample_rate1(ref bit [15:0] ua_brgr1, ref bit sample_clk1);
  forever begin
    @(posedge vif1.clock1);
    if (!vif1.reset) begin
      ua_brgr1 = 0;
      sample_clk1 = 0;
    end else begin
      if (ua_brgr1 == ({cfg.baud_rate_div1, cfg.baud_rate_gen1})) begin
        ua_brgr1 = 0;
        sample_clk1 = 1;
      end else begin
        sample_clk1 = 0;
        ua_brgr1++;
      end
    end
  end
endtask : gen_sample_rate1

// -------------------
// send_rx_frame1
// -------------------
task uart_rx_driver1::send_rx_frame1(input uart_frame1 frame1);
  bit [7:0] payload_byte1;
  num_of_bits_sent1 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver1 Sending1 RX1 Frame1...\n%s", frame1.sprint()),
            UVM_HIGH)
 
  repeat (frame1.transmit_delay1)
    @(posedge vif1.clock1);
  void'(this.begin_tr(frame1));
   
  wait((!cfg.rts_en1)||(!vif1.cts_n1));
  `uvm_info(get_type_name(), "Driver1 - Modem1 RTS1 or CTS1 asserted1", UVM_HIGH)

  while (num_of_bits_sent1 <= (1 + cfg.char_len_val1 + cfg.parity_en1 + cfg.nbstop1)) begin
    @(posedge vif1.clock1);
    #1;
    if (sample_clk1) begin
      if (num_of_bits_sent1 == 0) begin
        // Start1 sending1 rx_frame1 with "start bit"
        vif1.rxd1 = frame1.start_bit1;
        `uvm_info(get_type_name(),
                  $psprintf("Driver1 Sending1 Frame1 SOP1: %b", frame1.start_bit1),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent1 > 0) && (num_of_bits_sent1 < (1 + cfg.char_len_val1))) begin
        // sending1 "data bits" 
        payload_byte1 = frame1.payload1[num_of_bits_sent1-1] ;
        vif1.rxd1 = frame1.payload1[num_of_bits_sent1-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver1 Sending1 Frame1 data bit number1:%0d value:'b%b",
             (num_of_bits_sent1-1), payload_byte1), UVM_HIGH)
      end
      if ((num_of_bits_sent1 == (1 + cfg.char_len_val1)) && (cfg.parity_en1)) begin
        // sending1 "parity1 bit" if parity1 is enabled
        vif1.rxd1 = frame1.calc_parity1(cfg.char_len_val1, cfg.parity_mode1);
        `uvm_info(get_type_name(),
             $psprintf("Driver1 Sending1 Frame1 Parity1 bit:'b%b",
             frame1.calc_parity1(cfg.char_len_val1, cfg.parity_mode1)), UVM_HIGH)
      end
      if (num_of_bits_sent1 == (1 + cfg.char_len_val1 + cfg.parity_en1)) begin
        // sending1 "stop/error bits"
        for (int i = 0; i < cfg.nbstop1; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver1 Sending1 Frame1 Stop bit:'b%b",
               frame1.stop_bits1[i]), UVM_HIGH)
          wait (sample_clk1);
          if (frame1.error_bits1[i]) begin
            vif1.rxd1 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver1 intensionally1 corrupting1 Stop bit since1 error_bits1['b%b] is 'b%b", i, frame1.error_bits1[i]),
                 UVM_HIGH)
          end else
          vif1.rxd1 = frame1.stop_bits1[i];
          num_of_bits_sent1++;
          wait (!sample_clk1);
        end
      end
    num_of_bits_sent1++;
    wait (!sample_clk1);
    end
  end
  
  num_frames_sent1++;
  `uvm_info(get_type_name(),
       $psprintf("Frame1 **%0d** Sent1...", num_frames_sent1), UVM_MEDIUM)
  wait (sample_clk1);
  vif1.rxd1 = 1;

  `uvm_info(get_type_name(), "Frame1 complete...", UVM_MEDIUM)
  this.end_tr(frame1);
   
endtask : send_rx_frame1

//UVM report_phase
function void uart_rx_driver1::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART1 Frames1 Sent1:%0d", num_frames_sent1),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER1
