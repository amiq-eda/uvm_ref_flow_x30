/*-------------------------------------------------------------------------
File4 name   : uart_rx_driver4.sv
Title4       : RX4 Driver4
Project4     :
Created4     :
Description4 : Describes4 UART4 Receiver4 Driver4 for UART4 UVC4
Notes4       :  
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

`ifndef UART_RX_DRIVER4
`define UART_RX_DRIVER4

class uart_rx_driver4 extends uvm_driver #(uart_frame4) ;

  // The virtual interface used to drive4 and view4 HDL signals4.
  virtual interface uart_if4 vif4;

  // handle to  a cfg class
  uart_config4 cfg;

  bit sample_clk4;
  bit [15:0] ua_brgr4;
  bit [7:0] ua_bdiv4;
  int num_of_bits_sent4;
  int num_frames_sent4;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver4)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr4, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv4, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor4 - required4 UVM syntax4
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive4();
  extern virtual task gen_sample_rate4(ref bit [15:0] ua_brgr4, ref bit sample_clk4);
  extern virtual task send_rx_frame4(input uart_frame4 frame4);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver4

// UVM build_phase
function void uart_rx_driver4::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config4)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG4", "uart_config4 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if4)::get(this, "", "vif4", vif4))
   `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver4::run_phase(uvm_phase phase);
  fork
    get_and_drive4();
    gen_sample_rate4(ua_brgr4, sample_clk4);
  join
endtask : run_phase

// reset
task uart_rx_driver4::reset();
  @(negedge vif4.reset);
  `uvm_info(get_type_name(), "Reset4 Asserted4", UVM_MEDIUM)
   vif4.rxd4 = 1;        //Receive4 Data
   vif4.cts_n4 = 0;      //Clear to Send4
   vif4.dsr_n4 = 0;      //Data Set Ready4
   vif4.ri_n4 = 0;       //Ring4 Indicator4
   vif4.baud_clk4 = 0;   //Baud4 Clk4 - NOT4 USED4
endtask : reset

//  get_and4 drive4
task uart_rx_driver4::get_and_drive4();
  while (1) begin
    reset();
    fork
      @(negedge vif4.reset)
        `uvm_info(get_type_name(), "Reset4 asserted4", UVM_LOW)
    begin
      forever begin
        @(posedge vif4.clock4 iff (vif4.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame4(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If4 we4 are in the middle4 of a transfer4, need to end the rx4. Also4,
    //do any reset cleanup4 here4. The only way4 we4 got4 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive4

task uart_rx_driver4::gen_sample_rate4(ref bit [15:0] ua_brgr4, ref bit sample_clk4);
  forever begin
    @(posedge vif4.clock4);
    if (!vif4.reset) begin
      ua_brgr4 = 0;
      sample_clk4 = 0;
    end else begin
      if (ua_brgr4 == ({cfg.baud_rate_div4, cfg.baud_rate_gen4})) begin
        ua_brgr4 = 0;
        sample_clk4 = 1;
      end else begin
        sample_clk4 = 0;
        ua_brgr4++;
      end
    end
  end
endtask : gen_sample_rate4

// -------------------
// send_rx_frame4
// -------------------
task uart_rx_driver4::send_rx_frame4(input uart_frame4 frame4);
  bit [7:0] payload_byte4;
  num_of_bits_sent4 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver4 Sending4 RX4 Frame4...\n%s", frame4.sprint()),
            UVM_HIGH)
 
  repeat (frame4.transmit_delay4)
    @(posedge vif4.clock4);
  void'(this.begin_tr(frame4));
   
  wait((!cfg.rts_en4)||(!vif4.cts_n4));
  `uvm_info(get_type_name(), "Driver4 - Modem4 RTS4 or CTS4 asserted4", UVM_HIGH)

  while (num_of_bits_sent4 <= (1 + cfg.char_len_val4 + cfg.parity_en4 + cfg.nbstop4)) begin
    @(posedge vif4.clock4);
    #1;
    if (sample_clk4) begin
      if (num_of_bits_sent4 == 0) begin
        // Start4 sending4 rx_frame4 with "start bit"
        vif4.rxd4 = frame4.start_bit4;
        `uvm_info(get_type_name(),
                  $psprintf("Driver4 Sending4 Frame4 SOP4: %b", frame4.start_bit4),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent4 > 0) && (num_of_bits_sent4 < (1 + cfg.char_len_val4))) begin
        // sending4 "data bits" 
        payload_byte4 = frame4.payload4[num_of_bits_sent4-1] ;
        vif4.rxd4 = frame4.payload4[num_of_bits_sent4-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver4 Sending4 Frame4 data bit number4:%0d value:'b%b",
             (num_of_bits_sent4-1), payload_byte4), UVM_HIGH)
      end
      if ((num_of_bits_sent4 == (1 + cfg.char_len_val4)) && (cfg.parity_en4)) begin
        // sending4 "parity4 bit" if parity4 is enabled
        vif4.rxd4 = frame4.calc_parity4(cfg.char_len_val4, cfg.parity_mode4);
        `uvm_info(get_type_name(),
             $psprintf("Driver4 Sending4 Frame4 Parity4 bit:'b%b",
             frame4.calc_parity4(cfg.char_len_val4, cfg.parity_mode4)), UVM_HIGH)
      end
      if (num_of_bits_sent4 == (1 + cfg.char_len_val4 + cfg.parity_en4)) begin
        // sending4 "stop/error bits"
        for (int i = 0; i < cfg.nbstop4; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver4 Sending4 Frame4 Stop bit:'b%b",
               frame4.stop_bits4[i]), UVM_HIGH)
          wait (sample_clk4);
          if (frame4.error_bits4[i]) begin
            vif4.rxd4 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver4 intensionally4 corrupting4 Stop bit since4 error_bits4['b%b] is 'b%b", i, frame4.error_bits4[i]),
                 UVM_HIGH)
          end else
          vif4.rxd4 = frame4.stop_bits4[i];
          num_of_bits_sent4++;
          wait (!sample_clk4);
        end
      end
    num_of_bits_sent4++;
    wait (!sample_clk4);
    end
  end
  
  num_frames_sent4++;
  `uvm_info(get_type_name(),
       $psprintf("Frame4 **%0d** Sent4...", num_frames_sent4), UVM_MEDIUM)
  wait (sample_clk4);
  vif4.rxd4 = 1;

  `uvm_info(get_type_name(), "Frame4 complete...", UVM_MEDIUM)
  this.end_tr(frame4);
   
endtask : send_rx_frame4

//UVM report_phase
function void uart_rx_driver4::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART4 Frames4 Sent4:%0d", num_frames_sent4),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER4
