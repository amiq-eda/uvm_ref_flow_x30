/*-------------------------------------------------------------------------
File21 name   : uart_rx_driver21.sv
Title21       : RX21 Driver21
Project21     :
Created21     :
Description21 : Describes21 UART21 Receiver21 Driver21 for UART21 UVC21
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER21
`define UART_RX_DRIVER21

class uart_rx_driver21 extends uvm_driver #(uart_frame21) ;

  // The virtual interface used to drive21 and view21 HDL signals21.
  virtual interface uart_if21 vif21;

  // handle to  a cfg class
  uart_config21 cfg;

  bit sample_clk21;
  bit [15:0] ua_brgr21;
  bit [7:0] ua_bdiv21;
  int num_of_bits_sent21;
  int num_frames_sent21;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver21)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr21, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv21, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor21 - required21 UVM syntax21
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive21();
  extern virtual task gen_sample_rate21(ref bit [15:0] ua_brgr21, ref bit sample_clk21);
  extern virtual task send_rx_frame21(input uart_frame21 frame21);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver21

// UVM build_phase
function void uart_rx_driver21::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config21)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG21", "uart_config21 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if21)::get(this, "", "vif21", vif21))
   `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver21::run_phase(uvm_phase phase);
  fork
    get_and_drive21();
    gen_sample_rate21(ua_brgr21, sample_clk21);
  join
endtask : run_phase

// reset
task uart_rx_driver21::reset();
  @(negedge vif21.reset);
  `uvm_info(get_type_name(), "Reset21 Asserted21", UVM_MEDIUM)
   vif21.rxd21 = 1;        //Receive21 Data
   vif21.cts_n21 = 0;      //Clear to Send21
   vif21.dsr_n21 = 0;      //Data Set Ready21
   vif21.ri_n21 = 0;       //Ring21 Indicator21
   vif21.baud_clk21 = 0;   //Baud21 Clk21 - NOT21 USED21
endtask : reset

//  get_and21 drive21
task uart_rx_driver21::get_and_drive21();
  while (1) begin
    reset();
    fork
      @(negedge vif21.reset)
        `uvm_info(get_type_name(), "Reset21 asserted21", UVM_LOW)
    begin
      forever begin
        @(posedge vif21.clock21 iff (vif21.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame21(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If21 we21 are in the middle21 of a transfer21, need to end the rx21. Also21,
    //do any reset cleanup21 here21. The only way21 we21 got21 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive21

task uart_rx_driver21::gen_sample_rate21(ref bit [15:0] ua_brgr21, ref bit sample_clk21);
  forever begin
    @(posedge vif21.clock21);
    if (!vif21.reset) begin
      ua_brgr21 = 0;
      sample_clk21 = 0;
    end else begin
      if (ua_brgr21 == ({cfg.baud_rate_div21, cfg.baud_rate_gen21})) begin
        ua_brgr21 = 0;
        sample_clk21 = 1;
      end else begin
        sample_clk21 = 0;
        ua_brgr21++;
      end
    end
  end
endtask : gen_sample_rate21

// -------------------
// send_rx_frame21
// -------------------
task uart_rx_driver21::send_rx_frame21(input uart_frame21 frame21);
  bit [7:0] payload_byte21;
  num_of_bits_sent21 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver21 Sending21 RX21 Frame21...\n%s", frame21.sprint()),
            UVM_HIGH)
 
  repeat (frame21.transmit_delay21)
    @(posedge vif21.clock21);
  void'(this.begin_tr(frame21));
   
  wait((!cfg.rts_en21)||(!vif21.cts_n21));
  `uvm_info(get_type_name(), "Driver21 - Modem21 RTS21 or CTS21 asserted21", UVM_HIGH)

  while (num_of_bits_sent21 <= (1 + cfg.char_len_val21 + cfg.parity_en21 + cfg.nbstop21)) begin
    @(posedge vif21.clock21);
    #1;
    if (sample_clk21) begin
      if (num_of_bits_sent21 == 0) begin
        // Start21 sending21 rx_frame21 with "start bit"
        vif21.rxd21 = frame21.start_bit21;
        `uvm_info(get_type_name(),
                  $psprintf("Driver21 Sending21 Frame21 SOP21: %b", frame21.start_bit21),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent21 > 0) && (num_of_bits_sent21 < (1 + cfg.char_len_val21))) begin
        // sending21 "data bits" 
        payload_byte21 = frame21.payload21[num_of_bits_sent21-1] ;
        vif21.rxd21 = frame21.payload21[num_of_bits_sent21-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver21 Sending21 Frame21 data bit number21:%0d value:'b%b",
             (num_of_bits_sent21-1), payload_byte21), UVM_HIGH)
      end
      if ((num_of_bits_sent21 == (1 + cfg.char_len_val21)) && (cfg.parity_en21)) begin
        // sending21 "parity21 bit" if parity21 is enabled
        vif21.rxd21 = frame21.calc_parity21(cfg.char_len_val21, cfg.parity_mode21);
        `uvm_info(get_type_name(),
             $psprintf("Driver21 Sending21 Frame21 Parity21 bit:'b%b",
             frame21.calc_parity21(cfg.char_len_val21, cfg.parity_mode21)), UVM_HIGH)
      end
      if (num_of_bits_sent21 == (1 + cfg.char_len_val21 + cfg.parity_en21)) begin
        // sending21 "stop/error bits"
        for (int i = 0; i < cfg.nbstop21; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver21 Sending21 Frame21 Stop bit:'b%b",
               frame21.stop_bits21[i]), UVM_HIGH)
          wait (sample_clk21);
          if (frame21.error_bits21[i]) begin
            vif21.rxd21 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver21 intensionally21 corrupting21 Stop bit since21 error_bits21['b%b] is 'b%b", i, frame21.error_bits21[i]),
                 UVM_HIGH)
          end else
          vif21.rxd21 = frame21.stop_bits21[i];
          num_of_bits_sent21++;
          wait (!sample_clk21);
        end
      end
    num_of_bits_sent21++;
    wait (!sample_clk21);
    end
  end
  
  num_frames_sent21++;
  `uvm_info(get_type_name(),
       $psprintf("Frame21 **%0d** Sent21...", num_frames_sent21), UVM_MEDIUM)
  wait (sample_clk21);
  vif21.rxd21 = 1;

  `uvm_info(get_type_name(), "Frame21 complete...", UVM_MEDIUM)
  this.end_tr(frame21);
   
endtask : send_rx_frame21

//UVM report_phase
function void uart_rx_driver21::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART21 Frames21 Sent21:%0d", num_frames_sent21),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER21
