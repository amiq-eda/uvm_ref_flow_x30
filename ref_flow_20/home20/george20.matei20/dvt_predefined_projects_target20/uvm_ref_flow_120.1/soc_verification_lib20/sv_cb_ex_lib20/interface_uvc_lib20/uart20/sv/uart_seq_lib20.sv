/*-------------------------------------------------------------------------
File20 name   : uart_seq_lib20.sv
Title20       : sequence library file for uart20 uvc20
Project20     :
Created20     :
Description20 : describes20 all UART20 UVC20 sequences
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE20: uart_base_seq20
//-------------------------------------------------
class uart_base_seq20 extends uvm_sequence #(uart_frame20);
  function new(string name="uart_base_seq20");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq20)
  `uvm_declare_p_sequencer(uart_sequencer20)

  // Use a base sequence to raise/drop20 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running20 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq20

//-------------------------------------------------
// SEQUENCE20: uart_incr_payload_seq20
//-------------------------------------------------
class uart_incr_payload_seq20 extends uart_base_seq20;
    rand int unsigned cnt;
    rand bit [7:0] start_payload20;

    function new(string name="uart_incr_payload_seq20");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq20)
   `uvm_declare_p_sequencer(uart_sequencer20)

    constraint count_ct20 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART20 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload20 == (start_payload20 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq20

//-------------------------------------------------
// SEQUENCE20: uart_bad_parity_seq20
//-------------------------------------------------
class uart_bad_parity_seq20 extends uart_base_seq20;
    rand int unsigned cnt;
    rand bit [7:0] start_payload20;

    function new(string name="uart_bad_parity_seq20");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq20)
   `uvm_declare_p_sequencer(uart_sequencer20)

    constraint count_ct20 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART20 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create20 the frame20
        `uvm_create(req)
         // Nullify20 the constrain20 on the parity20
         req.default_parity_type20.constraint_mode(0);
   
         // Now20 send the packed with parity20 constrained20 to BAD_PARITY20
        `uvm_rand_send_with(req, { req.parity_type20 == BAD_PARITY20;})
      end
    endtask
endclass: uart_bad_parity_seq20

//-------------------------------------------------
// SEQUENCE20: uart_transmit_seq20
//-------------------------------------------------
class uart_transmit_seq20 extends uart_base_seq20;

   rand int unsigned num_of_tx20;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq20)
   `uvm_declare_p_sequencer(uart_sequencer20)
   
   function new(string name="uart_transmit_seq20");
      super.new(name);
   endfunction

   constraint num_of_tx_ct20 { num_of_tx20 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART20 sequencer: Executing %0d Frames20", num_of_tx20), UVM_LOW)
     for (int i = 0; i < num_of_tx20; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq20

//-------------------------------------------------
// SEQUENCE20: uart_no_activity_seq20
//-------------------------------------------------
class no_activity_seq20 extends uart_base_seq20;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq20)
  `uvm_declare_p_sequencer(uart_sequencer20)

  function new(string name="no_activity_seq20");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART20 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq20

//-------------------------------------------------
// SEQUENCE20: uart_short_transmit_seq20
//-------------------------------------------------
class uart_short_transmit_seq20 extends uart_base_seq20;

   rand int unsigned num_of_tx20;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq20)
   `uvm_declare_p_sequencer(uart_sequencer20)
   
   function new(string name="uart_short_transmit_seq20");
      super.new(name);
   endfunction

   constraint num_of_tx_ct20 { num_of_tx20 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART20 sequencer: Executing %0d Frames20", num_of_tx20), UVM_LOW)
     for (int i = 0; i < num_of_tx20; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq20
