/*-------------------------------------------------------------------------
File16 name   : uart_seq_lib16.sv
Title16       : sequence library file for uart16 uvc16
Project16     :
Created16     :
Description16 : describes16 all UART16 UVC16 sequences
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE16: uart_base_seq16
//-------------------------------------------------
class uart_base_seq16 extends uvm_sequence #(uart_frame16);
  function new(string name="uart_base_seq16");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq16)
  `uvm_declare_p_sequencer(uart_sequencer16)

  // Use a base sequence to raise/drop16 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running16 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq16

//-------------------------------------------------
// SEQUENCE16: uart_incr_payload_seq16
//-------------------------------------------------
class uart_incr_payload_seq16 extends uart_base_seq16;
    rand int unsigned cnt;
    rand bit [7:0] start_payload16;

    function new(string name="uart_incr_payload_seq16");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq16)
   `uvm_declare_p_sequencer(uart_sequencer16)

    constraint count_ct16 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART16 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload16 == (start_payload16 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq16

//-------------------------------------------------
// SEQUENCE16: uart_bad_parity_seq16
//-------------------------------------------------
class uart_bad_parity_seq16 extends uart_base_seq16;
    rand int unsigned cnt;
    rand bit [7:0] start_payload16;

    function new(string name="uart_bad_parity_seq16");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq16)
   `uvm_declare_p_sequencer(uart_sequencer16)

    constraint count_ct16 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART16 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create16 the frame16
        `uvm_create(req)
         // Nullify16 the constrain16 on the parity16
         req.default_parity_type16.constraint_mode(0);
   
         // Now16 send the packed with parity16 constrained16 to BAD_PARITY16
        `uvm_rand_send_with(req, { req.parity_type16 == BAD_PARITY16;})
      end
    endtask
endclass: uart_bad_parity_seq16

//-------------------------------------------------
// SEQUENCE16: uart_transmit_seq16
//-------------------------------------------------
class uart_transmit_seq16 extends uart_base_seq16;

   rand int unsigned num_of_tx16;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq16)
   `uvm_declare_p_sequencer(uart_sequencer16)
   
   function new(string name="uart_transmit_seq16");
      super.new(name);
   endfunction

   constraint num_of_tx_ct16 { num_of_tx16 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART16 sequencer: Executing %0d Frames16", num_of_tx16), UVM_LOW)
     for (int i = 0; i < num_of_tx16; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq16

//-------------------------------------------------
// SEQUENCE16: uart_no_activity_seq16
//-------------------------------------------------
class no_activity_seq16 extends uart_base_seq16;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq16)
  `uvm_declare_p_sequencer(uart_sequencer16)

  function new(string name="no_activity_seq16");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART16 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq16

//-------------------------------------------------
// SEQUENCE16: uart_short_transmit_seq16
//-------------------------------------------------
class uart_short_transmit_seq16 extends uart_base_seq16;

   rand int unsigned num_of_tx16;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq16)
   `uvm_declare_p_sequencer(uart_sequencer16)
   
   function new(string name="uart_short_transmit_seq16");
      super.new(name);
   endfunction

   constraint num_of_tx_ct16 { num_of_tx16 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART16 sequencer: Executing %0d Frames16", num_of_tx16), UVM_LOW)
     for (int i = 0; i < num_of_tx16; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq16
