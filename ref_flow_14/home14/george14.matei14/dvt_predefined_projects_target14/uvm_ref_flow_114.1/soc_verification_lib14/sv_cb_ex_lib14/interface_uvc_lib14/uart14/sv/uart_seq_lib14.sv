/*-------------------------------------------------------------------------
File14 name   : uart_seq_lib14.sv
Title14       : sequence library file for uart14 uvc14
Project14     :
Created14     :
Description14 : describes14 all UART14 UVC14 sequences
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

//-------------------------------------------------
// SEQUENCE14: uart_base_seq14
//-------------------------------------------------
class uart_base_seq14 extends uvm_sequence #(uart_frame14);
  function new(string name="uart_base_seq14");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq14)
  `uvm_declare_p_sequencer(uart_sequencer14)

  // Use a base sequence to raise/drop14 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running14 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq14

//-------------------------------------------------
// SEQUENCE14: uart_incr_payload_seq14
//-------------------------------------------------
class uart_incr_payload_seq14 extends uart_base_seq14;
    rand int unsigned cnt;
    rand bit [7:0] start_payload14;

    function new(string name="uart_incr_payload_seq14");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq14)
   `uvm_declare_p_sequencer(uart_sequencer14)

    constraint count_ct14 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART14 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload14 == (start_payload14 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq14

//-------------------------------------------------
// SEQUENCE14: uart_bad_parity_seq14
//-------------------------------------------------
class uart_bad_parity_seq14 extends uart_base_seq14;
    rand int unsigned cnt;
    rand bit [7:0] start_payload14;

    function new(string name="uart_bad_parity_seq14");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq14)
   `uvm_declare_p_sequencer(uart_sequencer14)

    constraint count_ct14 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART14 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create14 the frame14
        `uvm_create(req)
         // Nullify14 the constrain14 on the parity14
         req.default_parity_type14.constraint_mode(0);
   
         // Now14 send the packed with parity14 constrained14 to BAD_PARITY14
        `uvm_rand_send_with(req, { req.parity_type14 == BAD_PARITY14;})
      end
    endtask
endclass: uart_bad_parity_seq14

//-------------------------------------------------
// SEQUENCE14: uart_transmit_seq14
//-------------------------------------------------
class uart_transmit_seq14 extends uart_base_seq14;

   rand int unsigned num_of_tx14;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq14)
   `uvm_declare_p_sequencer(uart_sequencer14)
   
   function new(string name="uart_transmit_seq14");
      super.new(name);
   endfunction

   constraint num_of_tx_ct14 { num_of_tx14 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART14 sequencer: Executing %0d Frames14", num_of_tx14), UVM_LOW)
     for (int i = 0; i < num_of_tx14; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq14

//-------------------------------------------------
// SEQUENCE14: uart_no_activity_seq14
//-------------------------------------------------
class no_activity_seq14 extends uart_base_seq14;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq14)
  `uvm_declare_p_sequencer(uart_sequencer14)

  function new(string name="no_activity_seq14");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART14 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq14

//-------------------------------------------------
// SEQUENCE14: uart_short_transmit_seq14
//-------------------------------------------------
class uart_short_transmit_seq14 extends uart_base_seq14;

   rand int unsigned num_of_tx14;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq14)
   `uvm_declare_p_sequencer(uart_sequencer14)
   
   function new(string name="uart_short_transmit_seq14");
      super.new(name);
   endfunction

   constraint num_of_tx_ct14 { num_of_tx14 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART14 sequencer: Executing %0d Frames14", num_of_tx14), UVM_LOW)
     for (int i = 0; i < num_of_tx14; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq14
