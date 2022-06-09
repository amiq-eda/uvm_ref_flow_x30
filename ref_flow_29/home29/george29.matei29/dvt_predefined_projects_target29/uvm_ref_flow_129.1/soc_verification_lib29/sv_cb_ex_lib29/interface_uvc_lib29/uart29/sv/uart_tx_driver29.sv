/*-------------------------------------------------------------------------
File29 name   : uart_tx_driver29.sv
Title29       : TX29 Driver29
Project29     :
Created29     :
Description29 : Describes29 UART29 Trasmit29 Driver29 for UART29 UVC29
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER29
`define UART_TX_DRIVER29

class uart_tx_driver29 extends uvm_driver #(uart_frame29) ;

  // The virtual interface used to drive29 and view29 HDL signals29.
  virtual interface uart_if29 vif29;

  // handle to  a cfg class
  uart_config29 cfg;

  bit sample_clk29;
  bit baud_clk29;
  bit [15:0] ua_brgr29;
  bit [7:0] ua_bdiv29;
  int num_of_bits_sent29;
  int num_frames_sent29;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver29)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk29, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk29, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr29, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv29, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor29 - required29 UVM syntax29
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive29();
  extern virtual task gen_sample_rate29(ref bit [15:0] ua_brgr29, ref bit sample_clk29);
  extern virtual task send_tx_frame29(input uart_frame29 frame29);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver29

// UVM build_phase
function void uart_tx_driver29::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config29)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG29", "uart_config29 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if29)::get(this, "", "vif29", vif29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver29::run_phase(uvm_phase phase);
  fork
    get_and_drive29();
    gen_sample_rate29(ua_brgr29, sample_clk29);
  join
endtask : run_phase

// reset
task uart_tx_driver29::reset();
  @(negedge vif29.reset);
  `uvm_info(get_type_name(), "Reset29 Asserted29", UVM_MEDIUM)
   vif29.txd29 = 1;        //Transmit29 Data
   vif29.rts_n29 = 0;      //Request29 to Send29
   vif29.dtr_n29 = 0;      //Data Terminal29 Ready29
   vif29.dcd_n29 = 0;      //Data Carrier29 Detect29
   vif29.baud_clk29 = 0;       //Baud29 Data
endtask : reset

//  get_and29 drive29
task uart_tx_driver29::get_and_drive29();
  while (1) begin
    reset();
    fork
      @(negedge vif29.reset)
        `uvm_info(get_type_name(), "Reset29 asserted29", UVM_LOW)
    begin
      forever begin
        @(posedge vif29.clock29 iff (vif29.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame29(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If29 we29 are in the middle29 of a transfer29, need to end the tx29. Also29,
    //do any reset cleanup29 here29. The only way29 we29 got29 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive29

task uart_tx_driver29::gen_sample_rate29(ref bit [15:0] ua_brgr29, ref bit sample_clk29);
  forever begin
    @(posedge vif29.clock29);
    if (!vif29.reset) begin
      ua_brgr29 = 0;
      sample_clk29 = 0;
    end else begin
      if (ua_brgr29 == ({cfg.baud_rate_div29, cfg.baud_rate_gen29})) begin
        ua_brgr29 = 0;
        sample_clk29 = 1;
      end else begin
        sample_clk29 = 0;
        ua_brgr29++;
      end
    end
  end
endtask : gen_sample_rate29

// -------------------
// send_tx_frame29
// -------------------
task uart_tx_driver29::send_tx_frame29(input uart_frame29 frame29);
  bit [7:0] payload_byte29;
  num_of_bits_sent29 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver29 Sending29 TX29 Frame29...\n%s", frame29.sprint()),
            UVM_HIGH)
 
  repeat (frame29.transmit_delay29)
    @(posedge vif29.clock29);
  void'(this.begin_tr(frame29));
   
  wait((!cfg.rts_en29)||(!vif29.cts_n29));
  `uvm_info(get_type_name(), "Driver29 - Modem29 RTS29 or CTS29 asserted29", UVM_HIGH)

  while (num_of_bits_sent29 <= (1 + cfg.char_len_val29 + cfg.parity_en29 + cfg.nbstop29)) begin
    @(posedge vif29.clock29);
    #1;
    if (sample_clk29) begin
      if (num_of_bits_sent29 == 0) begin
        // Start29 sending29 tx_frame29 with "start bit"
        vif29.txd29 = frame29.start_bit29;
        `uvm_info(get_type_name(),
                  $psprintf("Driver29 Sending29 Frame29 SOP29: %b", frame29.start_bit29),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent29 > 0) && (num_of_bits_sent29 < (1 + cfg.char_len_val29))) begin
        // sending29 "data bits" 
        payload_byte29 = frame29.payload29[num_of_bits_sent29-1] ;
        vif29.txd29 = frame29.payload29[num_of_bits_sent29-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver29 Sending29 Frame29 data bit number29:%0d value:'b%b",
             (num_of_bits_sent29-1), payload_byte29), UVM_HIGH)
      end
      if ((num_of_bits_sent29 == (1 + cfg.char_len_val29)) && (cfg.parity_en29)) begin
        // sending29 "parity29 bit" if parity29 is enabled
        vif29.txd29 = frame29.calc_parity29(cfg.char_len_val29, cfg.parity_mode29);
        `uvm_info(get_type_name(),
             $psprintf("Driver29 Sending29 Frame29 Parity29 bit:'b%b",
             frame29.calc_parity29(cfg.char_len_val29, cfg.parity_mode29)), UVM_HIGH)
      end
      if (num_of_bits_sent29 == (1 + cfg.char_len_val29 + cfg.parity_en29)) begin
        // sending29 "stop/error bits"
        for (int i = 0; i < cfg.nbstop29; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver29 Sending29 Frame29 Stop bit:'b%b",
               frame29.stop_bits29[i]), UVM_HIGH)
          wait (sample_clk29);
          if (frame29.error_bits29[i]) begin
            vif29.txd29 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver29 intensionally29 corrupting29 Stop bit since29 error_bits29['b%b] is 'b%b", i, frame29.error_bits29[i]),
                 UVM_HIGH)
          end else
          vif29.txd29 = frame29.stop_bits29[i];
          num_of_bits_sent29++;
          wait (!sample_clk29);
        end
      end
    num_of_bits_sent29++;
    wait (!sample_clk29);
    end
  end
  
  num_frames_sent29++;
  `uvm_info(get_type_name(),
       $psprintf("Frame29 **%0d** Sent29...", num_frames_sent29), UVM_MEDIUM)
  wait (sample_clk29);
  vif29.txd29 = 1;

  `uvm_info(get_type_name(), "Frame29 complete...", UVM_MEDIUM)
  this.end_tr(frame29);
   
endtask : send_tx_frame29

//UVM report_phase
function void uart_tx_driver29::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART29 Frames29 Sent29:%0d", num_frames_sent29),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER29
