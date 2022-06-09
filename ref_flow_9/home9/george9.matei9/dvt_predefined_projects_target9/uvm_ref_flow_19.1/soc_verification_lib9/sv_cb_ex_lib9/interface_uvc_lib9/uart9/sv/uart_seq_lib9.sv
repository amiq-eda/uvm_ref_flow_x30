/*-------------------------------------------------------------------------
File9 name   : uart_seq_lib9.sv
Title9       : sequence library file for uart9 uvc9
Project9     :
Created9     :
Description9 : describes9 all UART9 UVC9 sequences
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE9: uart_base_seq9
//-------------------------------------------------
class uart_base_seq9 extends uvm_sequence #(uart_frame9);
  function new(string name="uart_base_seq9");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq9)
  `uvm_declare_p_sequencer(uart_sequencer9)

  // Use a base sequence to raise/drop9 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running9 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq9

//-------------------------------------------------
// SEQUENCE9: uart_incr_payload_seq9
//-------------------------------------------------
class uart_incr_payload_seq9 extends uart_base_seq9;
    rand int unsigned cnt;
    rand bit [7:0] start_payload9;

    function new(string name="uart_incr_payload_seq9");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq9)
   `uvm_declare_p_sequencer(uart_sequencer9)

    constraint count_ct9 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART9 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload9 == (start_payload9 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq9

//-------------------------------------------------
// SEQUENCE9: uart_bad_parity_seq9
//-------------------------------------------------
class uart_bad_parity_seq9 extends uart_base_seq9;
    rand int unsigned cnt;
    rand bit [7:0] start_payload9;

    function new(string name="uart_bad_parity_seq9");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq9)
   `uvm_declare_p_sequencer(uart_sequencer9)

    constraint count_ct9 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART9 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create9 the frame9
        `uvm_create(req)
         // Nullify9 the constrain9 on the parity9
         req.default_parity_type9.constraint_mode(0);
   
         // Now9 send the packed with parity9 constrained9 to BAD_PARITY9
        `uvm_rand_send_with(req, { req.parity_type9 == BAD_PARITY9;})
      end
    endtask
endclass: uart_bad_parity_seq9

//-------------------------------------------------
// SEQUENCE9: uart_transmit_seq9
//-------------------------------------------------
class uart_transmit_seq9 extends uart_base_seq9;

   rand int unsigned num_of_tx9;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq9)
   `uvm_declare_p_sequencer(uart_sequencer9)
   
   function new(string name="uart_transmit_seq9");
      super.new(name);
   endfunction

   constraint num_of_tx_ct9 { num_of_tx9 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART9 sequencer: Executing %0d Frames9", num_of_tx9), UVM_LOW)
     for (int i = 0; i < num_of_tx9; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq9

//-------------------------------------------------
// SEQUENCE9: uart_no_activity_seq9
//-------------------------------------------------
class no_activity_seq9 extends uart_base_seq9;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq9)
  `uvm_declare_p_sequencer(uart_sequencer9)

  function new(string name="no_activity_seq9");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART9 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq9

//-------------------------------------------------
// SEQUENCE9: uart_short_transmit_seq9
//-------------------------------------------------
class uart_short_transmit_seq9 extends uart_base_seq9;

   rand int unsigned num_of_tx9;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq9)
   `uvm_declare_p_sequencer(uart_sequencer9)
   
   function new(string name="uart_short_transmit_seq9");
      super.new(name);
   endfunction

   constraint num_of_tx_ct9 { num_of_tx9 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART9 sequencer: Executing %0d Frames9", num_of_tx9), UVM_LOW)
     for (int i = 0; i < num_of_tx9; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq9
