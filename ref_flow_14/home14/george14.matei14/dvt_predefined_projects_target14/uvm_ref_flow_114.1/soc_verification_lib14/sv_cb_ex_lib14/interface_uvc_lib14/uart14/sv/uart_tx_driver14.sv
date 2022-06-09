/*-------------------------------------------------------------------------
File14 name   : uart_tx_driver14.sv
Title14       : TX14 Driver14
Project14     :
Created14     :
Description14 : Describes14 UART14 Trasmit14 Driver14 for UART14 UVC14
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER14
`define UART_TX_DRIVER14

class uart_tx_driver14 extends uvm_driver #(uart_frame14) ;

  // The virtual interface used to drive14 and view14 HDL signals14.
  virtual interface uart_if14 vif14;

  // handle to  a cfg class
  uart_config14 cfg;

  bit sample_clk14;
  bit baud_clk14;
  bit [15:0] ua_brgr14;
  bit [7:0] ua_bdiv14;
  int num_of_bits_sent14;
  int num_frames_sent14;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver14)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk14, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk14, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr14, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv14, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor14 - required14 UVM syntax14
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive14();
  extern virtual task gen_sample_rate14(ref bit [15:0] ua_brgr14, ref bit sample_clk14);
  extern virtual task send_tx_frame14(input uart_frame14 frame14);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver14

// UVM build_phase
function void uart_tx_driver14::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config14)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG14", "uart_config14 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if14)::get(this, "", "vif14", vif14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver14::run_phase(uvm_phase phase);
  fork
    get_and_drive14();
    gen_sample_rate14(ua_brgr14, sample_clk14);
  join
endtask : run_phase

// reset
task uart_tx_driver14::reset();
  @(negedge vif14.reset);
  `uvm_info(get_type_name(), "Reset14 Asserted14", UVM_MEDIUM)
   vif14.txd14 = 1;        //Transmit14 Data
   vif14.rts_n14 = 0;      //Request14 to Send14
   vif14.dtr_n14 = 0;      //Data Terminal14 Ready14
   vif14.dcd_n14 = 0;      //Data Carrier14 Detect14
   vif14.baud_clk14 = 0;       //Baud14 Data
endtask : reset

//  get_and14 drive14
task uart_tx_driver14::get_and_drive14();
  while (1) begin
    reset();
    fork
      @(negedge vif14.reset)
        `uvm_info(get_type_name(), "Reset14 asserted14", UVM_LOW)
    begin
      forever begin
        @(posedge vif14.clock14 iff (vif14.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame14(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If14 we14 are in the middle14 of a transfer14, need to end the tx14. Also14,
    //do any reset cleanup14 here14. The only way14 we14 got14 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive14

task uart_tx_driver14::gen_sample_rate14(ref bit [15:0] ua_brgr14, ref bit sample_clk14);
  forever begin
    @(posedge vif14.clock14);
    if (!vif14.reset) begin
      ua_brgr14 = 0;
      sample_clk14 = 0;
    end else begin
      if (ua_brgr14 == ({cfg.baud_rate_div14, cfg.baud_rate_gen14})) begin
        ua_brgr14 = 0;
        sample_clk14 = 1;
      end else begin
        sample_clk14 = 0;
        ua_brgr14++;
      end
    end
  end
endtask : gen_sample_rate14

// -------------------
// send_tx_frame14
// -------------------
task uart_tx_driver14::send_tx_frame14(input uart_frame14 frame14);
  bit [7:0] payload_byte14;
  num_of_bits_sent14 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver14 Sending14 TX14 Frame14...\n%s", frame14.sprint()),
            UVM_HIGH)
 
  repeat (frame14.transmit_delay14)
    @(posedge vif14.clock14);
  void'(this.begin_tr(frame14));
   
  wait((!cfg.rts_en14)||(!vif14.cts_n14));
  `uvm_info(get_type_name(), "Driver14 - Modem14 RTS14 or CTS14 asserted14", UVM_HIGH)

  while (num_of_bits_sent14 <= (1 + cfg.char_len_val14 + cfg.parity_en14 + cfg.nbstop14)) begin
    @(posedge vif14.clock14);
    #1;
    if (sample_clk14) begin
      if (num_of_bits_sent14 == 0) begin
        // Start14 sending14 tx_frame14 with "start bit"
        vif14.txd14 = frame14.start_bit14;
        `uvm_info(get_type_name(),
                  $psprintf("Driver14 Sending14 Frame14 SOP14: %b", frame14.start_bit14),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent14 > 0) && (num_of_bits_sent14 < (1 + cfg.char_len_val14))) begin
        // sending14 "data bits" 
        payload_byte14 = frame14.payload14[num_of_bits_sent14-1] ;
        vif14.txd14 = frame14.payload14[num_of_bits_sent14-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver14 Sending14 Frame14 data bit number14:%0d value:'b%b",
             (num_of_bits_sent14-1), payload_byte14), UVM_HIGH)
      end
      if ((num_of_bits_sent14 == (1 + cfg.char_len_val14)) && (cfg.parity_en14)) begin
        // sending14 "parity14 bit" if parity14 is enabled
        vif14.txd14 = frame14.calc_parity14(cfg.char_len_val14, cfg.parity_mode14);
        `uvm_info(get_type_name(),
             $psprintf("Driver14 Sending14 Frame14 Parity14 bit:'b%b",
             frame14.calc_parity14(cfg.char_len_val14, cfg.parity_mode14)), UVM_HIGH)
      end
      if (num_of_bits_sent14 == (1 + cfg.char_len_val14 + cfg.parity_en14)) begin
        // sending14 "stop/error bits"
        for (int i = 0; i < cfg.nbstop14; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver14 Sending14 Frame14 Stop bit:'b%b",
               frame14.stop_bits14[i]), UVM_HIGH)
          wait (sample_clk14);
          if (frame14.error_bits14[i]) begin
            vif14.txd14 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver14 intensionally14 corrupting14 Stop bit since14 error_bits14['b%b] is 'b%b", i, frame14.error_bits14[i]),
                 UVM_HIGH)
          end else
          vif14.txd14 = frame14.stop_bits14[i];
          num_of_bits_sent14++;
          wait (!sample_clk14);
        end
      end
    num_of_bits_sent14++;
    wait (!sample_clk14);
    end
  end
  
  num_frames_sent14++;
  `uvm_info(get_type_name(),
       $psprintf("Frame14 **%0d** Sent14...", num_frames_sent14), UVM_MEDIUM)
  wait (sample_clk14);
  vif14.txd14 = 1;

  `uvm_info(get_type_name(), "Frame14 complete...", UVM_MEDIUM)
  this.end_tr(frame14);
   
endtask : send_tx_frame14

//UVM report_phase
function void uart_tx_driver14::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART14 Frames14 Sent14:%0d", num_frames_sent14),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER14
