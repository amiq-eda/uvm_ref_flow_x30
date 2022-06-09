/*-------------------------------------------------------------------------
File5 name   : uart_seq_lib5.sv
Title5       : sequence library file for uart5 uvc5
Project5     :
Created5     :
Description5 : describes5 all UART5 UVC5 sequences
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE5: uart_base_seq5
//-------------------------------------------------
class uart_base_seq5 extends uvm_sequence #(uart_frame5);
  function new(string name="uart_base_seq5");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq5)
  `uvm_declare_p_sequencer(uart_sequencer5)

  // Use a base sequence to raise/drop5 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running5 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq5

//-------------------------------------------------
// SEQUENCE5: uart_incr_payload_seq5
//-------------------------------------------------
class uart_incr_payload_seq5 extends uart_base_seq5;
    rand int unsigned cnt;
    rand bit [7:0] start_payload5;

    function new(string name="uart_incr_payload_seq5");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq5)
   `uvm_declare_p_sequencer(uart_sequencer5)

    constraint count_ct5 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART5 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload5 == (start_payload5 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq5

//-------------------------------------------------
// SEQUENCE5: uart_bad_parity_seq5
//-------------------------------------------------
class uart_bad_parity_seq5 extends uart_base_seq5;
    rand int unsigned cnt;
    rand bit [7:0] start_payload5;

    function new(string name="uart_bad_parity_seq5");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq5)
   `uvm_declare_p_sequencer(uart_sequencer5)

    constraint count_ct5 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART5 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create5 the frame5
        `uvm_create(req)
         // Nullify5 the constrain5 on the parity5
         req.default_parity_type5.constraint_mode(0);
   
         // Now5 send the packed with parity5 constrained5 to BAD_PARITY5
        `uvm_rand_send_with(req, { req.parity_type5 == BAD_PARITY5;})
      end
    endtask
endclass: uart_bad_parity_seq5

//-------------------------------------------------
// SEQUENCE5: uart_transmit_seq5
//-------------------------------------------------
class uart_transmit_seq5 extends uart_base_seq5;

   rand int unsigned num_of_tx5;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq5)
   `uvm_declare_p_sequencer(uart_sequencer5)
   
   function new(string name="uart_transmit_seq5");
      super.new(name);
   endfunction

   constraint num_of_tx_ct5 { num_of_tx5 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART5 sequencer: Executing %0d Frames5", num_of_tx5), UVM_LOW)
     for (int i = 0; i < num_of_tx5; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq5

//-------------------------------------------------
// SEQUENCE5: uart_no_activity_seq5
//-------------------------------------------------
class no_activity_seq5 extends uart_base_seq5;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq5)
  `uvm_declare_p_sequencer(uart_sequencer5)

  function new(string name="no_activity_seq5");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART5 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq5

//-------------------------------------------------
// SEQUENCE5: uart_short_transmit_seq5
//-------------------------------------------------
class uart_short_transmit_seq5 extends uart_base_seq5;

   rand int unsigned num_of_tx5;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq5)
   `uvm_declare_p_sequencer(uart_sequencer5)
   
   function new(string name="uart_short_transmit_seq5");
      super.new(name);
   endfunction

   constraint num_of_tx_ct5 { num_of_tx5 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART5 sequencer: Executing %0d Frames5", num_of_tx5), UVM_LOW)
     for (int i = 0; i < num_of_tx5; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq5
