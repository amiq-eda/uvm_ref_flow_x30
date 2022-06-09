/*-------------------------------------------------------------------------
File11 name   : uart_tx_driver11.sv
Title11       : TX11 Driver11
Project11     :
Created11     :
Description11 : Describes11 UART11 Trasmit11 Driver11 for UART11 UVC11
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER11
`define UART_TX_DRIVER11

class uart_tx_driver11 extends uvm_driver #(uart_frame11) ;

  // The virtual interface used to drive11 and view11 HDL signals11.
  virtual interface uart_if11 vif11;

  // handle to  a cfg class
  uart_config11 cfg;

  bit sample_clk11;
  bit baud_clk11;
  bit [15:0] ua_brgr11;
  bit [7:0] ua_bdiv11;
  int num_of_bits_sent11;
  int num_frames_sent11;

  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver11)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk11, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk11, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr11, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv11, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor11 - required11 UVM syntax11
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive11();
  extern virtual task gen_sample_rate11(ref bit [15:0] ua_brgr11, ref bit sample_clk11);
  extern virtual task send_tx_frame11(input uart_frame11 frame11);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver11

// UVM build_phase
function void uart_tx_driver11::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config11)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG11", "uart_config11 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if11)::get(this, "", "vif11", vif11))
   `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver11::run_phase(uvm_phase phase);
  fork
    get_and_drive11();
    gen_sample_rate11(ua_brgr11, sample_clk11);
  join
endtask : run_phase

// reset
task uart_tx_driver11::reset();
  @(negedge vif11.reset);
  `uvm_info(get_type_name(), "Reset11 Asserted11", UVM_MEDIUM)
   vif11.txd11 = 1;        //Transmit11 Data
   vif11.rts_n11 = 0;      //Request11 to Send11
   vif11.dtr_n11 = 0;      //Data Terminal11 Ready11
   vif11.dcd_n11 = 0;      //Data Carrier11 Detect11
   vif11.baud_clk11 = 0;       //Baud11 Data
endtask : reset

//  get_and11 drive11
task uart_tx_driver11::get_and_drive11();
  while (1) begin
    reset();
    fork
      @(negedge vif11.reset)
        `uvm_info(get_type_name(), "Reset11 asserted11", UVM_LOW)
    begin
      forever begin
        @(posedge vif11.clock11 iff (vif11.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame11(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If11 we11 are in the middle11 of a transfer11, need to end the tx11. Also11,
    //do any reset cleanup11 here11. The only way11 we11 got11 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive11

task uart_tx_driver11::gen_sample_rate11(ref bit [15:0] ua_brgr11, ref bit sample_clk11);
  forever begin
    @(posedge vif11.clock11);
    if (!vif11.reset) begin
      ua_brgr11 = 0;
      sample_clk11 = 0;
    end else begin
      if (ua_brgr11 == ({cfg.baud_rate_div11, cfg.baud_rate_gen11})) begin
        ua_brgr11 = 0;
        sample_clk11 = 1;
      end else begin
        sample_clk11 = 0;
        ua_brgr11++;
      end
    end
  end
endtask : gen_sample_rate11

// -------------------
// send_tx_frame11
// -------------------
task uart_tx_driver11::send_tx_frame11(input uart_frame11 frame11);
  bit [7:0] payload_byte11;
  num_of_bits_sent11 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver11 Sending11 TX11 Frame11...\n%s", frame11.sprint()),
            UVM_HIGH)
 
  repeat (frame11.transmit_delay11)
    @(posedge vif11.clock11);
  void'(this.begin_tr(frame11));
   
  wait((!cfg.rts_en11)||(!vif11.cts_n11));
  `uvm_info(get_type_name(), "Driver11 - Modem11 RTS11 or CTS11 asserted11", UVM_HIGH)

  while (num_of_bits_sent11 <= (1 + cfg.char_len_val11 + cfg.parity_en11 + cfg.nbstop11)) begin
    @(posedge vif11.clock11);
    #1;
    if (sample_clk11) begin
      if (num_of_bits_sent11 == 0) begin
        // Start11 sending11 tx_frame11 with "start bit"
        vif11.txd11 = frame11.start_bit11;
        `uvm_info(get_type_name(),
                  $psprintf("Driver11 Sending11 Frame11 SOP11: %b", frame11.start_bit11),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent11 > 0) && (num_of_bits_sent11 < (1 + cfg.char_len_val11))) begin
        // sending11 "data bits" 
        payload_byte11 = frame11.payload11[num_of_bits_sent11-1] ;
        vif11.txd11 = frame11.payload11[num_of_bits_sent11-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver11 Sending11 Frame11 data bit number11:%0d value:'b%b",
             (num_of_bits_sent11-1), payload_byte11), UVM_HIGH)
      end
      if ((num_of_bits_sent11 == (1 + cfg.char_len_val11)) && (cfg.parity_en11)) begin
        // sending11 "parity11 bit" if parity11 is enabled
        vif11.txd11 = frame11.calc_parity11(cfg.char_len_val11, cfg.parity_mode11);
        `uvm_info(get_type_name(),
             $psprintf("Driver11 Sending11 Frame11 Parity11 bit:'b%b",
             frame11.calc_parity11(cfg.char_len_val11, cfg.parity_mode11)), UVM_HIGH)
      end
      if (num_of_bits_sent11 == (1 + cfg.char_len_val11 + cfg.parity_en11)) begin
        // sending11 "stop/error bits"
        for (int i = 0; i < cfg.nbstop11; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver11 Sending11 Frame11 Stop bit:'b%b",
               frame11.stop_bits11[i]), UVM_HIGH)
          wait (sample_clk11);
          if (frame11.error_bits11[i]) begin
            vif11.txd11 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver11 intensionally11 corrupting11 Stop bit since11 error_bits11['b%b] is 'b%b", i, frame11.error_bits11[i]),
                 UVM_HIGH)
          end else
          vif11.txd11 = frame11.stop_bits11[i];
          num_of_bits_sent11++;
          wait (!sample_clk11);
        end
      end
    num_of_bits_sent11++;
    wait (!sample_clk11);
    end
  end
  
  num_frames_sent11++;
  `uvm_info(get_type_name(),
       $psprintf("Frame11 **%0d** Sent11...", num_frames_sent11), UVM_MEDIUM)
  wait (sample_clk11);
  vif11.txd11 = 1;

  `uvm_info(get_type_name(), "Frame11 complete...", UVM_MEDIUM)
  this.end_tr(frame11);
   
endtask : send_tx_frame11

//UVM report_phase
function void uart_tx_driver11::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART11 Frames11 Sent11:%0d", num_frames_sent11),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER11
