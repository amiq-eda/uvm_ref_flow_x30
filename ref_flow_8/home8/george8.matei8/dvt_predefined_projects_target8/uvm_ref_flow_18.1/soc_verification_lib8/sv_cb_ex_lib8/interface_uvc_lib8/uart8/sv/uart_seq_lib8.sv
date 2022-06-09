/*-------------------------------------------------------------------------
File8 name   : uart_seq_lib8.sv
Title8       : sequence library file for uart8 uvc8
Project8     :
Created8     :
Description8 : describes8 all UART8 UVC8 sequences
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE8: uart_base_seq8
//-------------------------------------------------
class uart_base_seq8 extends uvm_sequence #(uart_frame8);
  function new(string name="uart_base_seq8");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq8)
  `uvm_declare_p_sequencer(uart_sequencer8)

  // Use a base sequence to raise/drop8 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running8 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq8

//-------------------------------------------------
// SEQUENCE8: uart_incr_payload_seq8
//-------------------------------------------------
class uart_incr_payload_seq8 extends uart_base_seq8;
    rand int unsigned cnt;
    rand bit [7:0] start_payload8;

    function new(string name="uart_incr_payload_seq8");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq8)
   `uvm_declare_p_sequencer(uart_sequencer8)

    constraint count_ct8 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART8 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload8 == (start_payload8 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq8

//-------------------------------------------------
// SEQUENCE8: uart_bad_parity_seq8
//-------------------------------------------------
class uart_bad_parity_seq8 extends uart_base_seq8;
    rand int unsigned cnt;
    rand bit [7:0] start_payload8;

    function new(string name="uart_bad_parity_seq8");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq8)
   `uvm_declare_p_sequencer(uart_sequencer8)

    constraint count_ct8 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART8 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create8 the frame8
        `uvm_create(req)
         // Nullify8 the constrain8 on the parity8
         req.default_parity_type8.constraint_mode(0);
   
         // Now8 send the packed with parity8 constrained8 to BAD_PARITY8
        `uvm_rand_send_with(req, { req.parity_type8 == BAD_PARITY8;})
      end
    endtask
endclass: uart_bad_parity_seq8

//-------------------------------------------------
// SEQUENCE8: uart_transmit_seq8
//-------------------------------------------------
class uart_transmit_seq8 extends uart_base_seq8;

   rand int unsigned num_of_tx8;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq8)
   `uvm_declare_p_sequencer(uart_sequencer8)
   
   function new(string name="uart_transmit_seq8");
      super.new(name);
   endfunction

   constraint num_of_tx_ct8 { num_of_tx8 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART8 sequencer: Executing %0d Frames8", num_of_tx8), UVM_LOW)
     for (int i = 0; i < num_of_tx8; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq8

//-------------------------------------------------
// SEQUENCE8: uart_no_activity_seq8
//-------------------------------------------------
class no_activity_seq8 extends uart_base_seq8;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq8)
  `uvm_declare_p_sequencer(uart_sequencer8)

  function new(string name="no_activity_seq8");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART8 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq8

//-------------------------------------------------
// SEQUENCE8: uart_short_transmit_seq8
//-------------------------------------------------
class uart_short_transmit_seq8 extends uart_base_seq8;

   rand int unsigned num_of_tx8;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq8)
   `uvm_declare_p_sequencer(uart_sequencer8)
   
   function new(string name="uart_short_transmit_seq8");
      super.new(name);
   endfunction

   constraint num_of_tx_ct8 { num_of_tx8 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART8 sequencer: Executing %0d Frames8", num_of_tx8), UVM_LOW)
     for (int i = 0; i < num_of_tx8; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq8
