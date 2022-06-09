/*-------------------------------------------------------------------------
File19 name   : uart_seq_lib19.sv
Title19       : sequence library file for uart19 uvc19
Project19     :
Created19     :
Description19 : describes19 all UART19 UVC19 sequences
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE19: uart_base_seq19
//-------------------------------------------------
class uart_base_seq19 extends uvm_sequence #(uart_frame19);
  function new(string name="uart_base_seq19");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq19)
  `uvm_declare_p_sequencer(uart_sequencer19)

  // Use a base sequence to raise/drop19 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running19 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq19

//-------------------------------------------------
// SEQUENCE19: uart_incr_payload_seq19
//-------------------------------------------------
class uart_incr_payload_seq19 extends uart_base_seq19;
    rand int unsigned cnt;
    rand bit [7:0] start_payload19;

    function new(string name="uart_incr_payload_seq19");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq19)
   `uvm_declare_p_sequencer(uart_sequencer19)

    constraint count_ct19 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART19 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload19 == (start_payload19 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq19

//-------------------------------------------------
// SEQUENCE19: uart_bad_parity_seq19
//-------------------------------------------------
class uart_bad_parity_seq19 extends uart_base_seq19;
    rand int unsigned cnt;
    rand bit [7:0] start_payload19;

    function new(string name="uart_bad_parity_seq19");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq19)
   `uvm_declare_p_sequencer(uart_sequencer19)

    constraint count_ct19 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART19 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create19 the frame19
        `uvm_create(req)
         // Nullify19 the constrain19 on the parity19
         req.default_parity_type19.constraint_mode(0);
   
         // Now19 send the packed with parity19 constrained19 to BAD_PARITY19
        `uvm_rand_send_with(req, { req.parity_type19 == BAD_PARITY19;})
      end
    endtask
endclass: uart_bad_parity_seq19

//-------------------------------------------------
// SEQUENCE19: uart_transmit_seq19
//-------------------------------------------------
class uart_transmit_seq19 extends uart_base_seq19;

   rand int unsigned num_of_tx19;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq19)
   `uvm_declare_p_sequencer(uart_sequencer19)
   
   function new(string name="uart_transmit_seq19");
      super.new(name);
   endfunction

   constraint num_of_tx_ct19 { num_of_tx19 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART19 sequencer: Executing %0d Frames19", num_of_tx19), UVM_LOW)
     for (int i = 0; i < num_of_tx19; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq19

//-------------------------------------------------
// SEQUENCE19: uart_no_activity_seq19
//-------------------------------------------------
class no_activity_seq19 extends uart_base_seq19;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq19)
  `uvm_declare_p_sequencer(uart_sequencer19)

  function new(string name="no_activity_seq19");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART19 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq19

//-------------------------------------------------
// SEQUENCE19: uart_short_transmit_seq19
//-------------------------------------------------
class uart_short_transmit_seq19 extends uart_base_seq19;

   rand int unsigned num_of_tx19;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq19)
   `uvm_declare_p_sequencer(uart_sequencer19)
   
   function new(string name="uart_short_transmit_seq19");
      super.new(name);
   endfunction

   constraint num_of_tx_ct19 { num_of_tx19 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART19 sequencer: Executing %0d Frames19", num_of_tx19), UVM_LOW)
     for (int i = 0; i < num_of_tx19; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq19
