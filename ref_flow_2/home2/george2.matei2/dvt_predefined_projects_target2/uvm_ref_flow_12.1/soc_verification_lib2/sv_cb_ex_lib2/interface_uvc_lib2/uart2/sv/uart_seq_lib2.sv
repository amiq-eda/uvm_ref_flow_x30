/*-------------------------------------------------------------------------
File2 name   : uart_seq_lib2.sv
Title2       : sequence library file for uart2 uvc2
Project2     :
Created2     :
Description2 : describes2 all UART2 UVC2 sequences
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE2: uart_base_seq2
//-------------------------------------------------
class uart_base_seq2 extends uvm_sequence #(uart_frame2);
  function new(string name="uart_base_seq2");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq2)
  `uvm_declare_p_sequencer(uart_sequencer2)

  // Use a base sequence to raise/drop2 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running2 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq2

//-------------------------------------------------
// SEQUENCE2: uart_incr_payload_seq2
//-------------------------------------------------
class uart_incr_payload_seq2 extends uart_base_seq2;
    rand int unsigned cnt;
    rand bit [7:0] start_payload2;

    function new(string name="uart_incr_payload_seq2");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq2)
   `uvm_declare_p_sequencer(uart_sequencer2)

    constraint count_ct2 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART2 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload2 == (start_payload2 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq2

//-------------------------------------------------
// SEQUENCE2: uart_bad_parity_seq2
//-------------------------------------------------
class uart_bad_parity_seq2 extends uart_base_seq2;
    rand int unsigned cnt;
    rand bit [7:0] start_payload2;

    function new(string name="uart_bad_parity_seq2");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq2)
   `uvm_declare_p_sequencer(uart_sequencer2)

    constraint count_ct2 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART2 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create2 the frame2
        `uvm_create(req)
         // Nullify2 the constrain2 on the parity2
         req.default_parity_type2.constraint_mode(0);
   
         // Now2 send the packed with parity2 constrained2 to BAD_PARITY2
        `uvm_rand_send_with(req, { req.parity_type2 == BAD_PARITY2;})
      end
    endtask
endclass: uart_bad_parity_seq2

//-------------------------------------------------
// SEQUENCE2: uart_transmit_seq2
//-------------------------------------------------
class uart_transmit_seq2 extends uart_base_seq2;

   rand int unsigned num_of_tx2;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq2)
   `uvm_declare_p_sequencer(uart_sequencer2)
   
   function new(string name="uart_transmit_seq2");
      super.new(name);
   endfunction

   constraint num_of_tx_ct2 { num_of_tx2 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART2 sequencer: Executing %0d Frames2", num_of_tx2), UVM_LOW)
     for (int i = 0; i < num_of_tx2; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq2

//-------------------------------------------------
// SEQUENCE2: uart_no_activity_seq2
//-------------------------------------------------
class no_activity_seq2 extends uart_base_seq2;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq2)
  `uvm_declare_p_sequencer(uart_sequencer2)

  function new(string name="no_activity_seq2");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART2 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq2

//-------------------------------------------------
// SEQUENCE2: uart_short_transmit_seq2
//-------------------------------------------------
class uart_short_transmit_seq2 extends uart_base_seq2;

   rand int unsigned num_of_tx2;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq2)
   `uvm_declare_p_sequencer(uart_sequencer2)
   
   function new(string name="uart_short_transmit_seq2");
      super.new(name);
   endfunction

   constraint num_of_tx_ct2 { num_of_tx2 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART2 sequencer: Executing %0d Frames2", num_of_tx2), UVM_LOW)
     for (int i = 0; i < num_of_tx2; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq2
