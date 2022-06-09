/*******************************************************************************
  FILE : apb_master_seq_lib5.sv
*******************************************************************************/
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


`ifndef APB_MASTER_SEQ_LIB_SV5
`define APB_MASTER_SEQ_LIB_SV5

//------------------------------------------------------------------------------
// SEQUENCE5: read_byte_seq5
//------------------------------------------------------------------------------
class apb_master_base_seq5 extends uvm_sequence #(apb_transfer5);
  // NOTE5: KATHLEEN5 - ALSO5 NEED5 TO HANDLE5 KILL5 HERE5??

  function new(string name="apb_master_base_seq5");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq5)
  `uvm_declare_p_sequencer(apb_master_sequencer5)

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
endclass : apb_master_base_seq5

//------------------------------------------------------------------------------
// SEQUENCE5: read_byte_seq5
//------------------------------------------------------------------------------
class read_byte_seq5 extends apb_master_base_seq5;
  rand bit [31:0] start_addr5;
  rand int unsigned transmit_del5;

  function new(string name="read_byte_seq5");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq5)

  constraint transmit_del_ct5 { (transmit_del5 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr5;
        req.direction5 == APB_READ5;
        req.transmit_delay5 == transmit_del5; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr5 = 'h%0h, req_data5 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr5 = 'h%0h, rsp_data5 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq5

// SEQUENCE5: write_byte_seq5
class write_byte_seq5 extends apb_master_base_seq5;
  rand bit [31:0] start_addr5;
  rand bit [7:0] write_data5;
  rand int unsigned transmit_del5;

  function new(string name="write_byte_seq5");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq5)

  constraint transmit_del_ct5 { (transmit_del5 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr5;
        req.direction5 == APB_WRITE5;
        req.data == write_data5;
        req.transmit_delay5 == transmit_del5; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq5

//------------------------------------------------------------------------------
// SEQUENCE5: read_word_seq5
//------------------------------------------------------------------------------
class read_word_seq5 extends apb_master_base_seq5;
  rand bit [31:0] start_addr5;
  rand int unsigned transmit_del5;

  function new(string name="read_word_seq5");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq5)

  constraint transmit_del_ct5 { (transmit_del5 <= 10); }
  constraint addr_ct5 {(start_addr5[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr5;
        req.direction5 == APB_READ5;
        req.transmit_delay5 == transmit_del5; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr5 = 'h%0h, req_data5 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr5 = 'h%0h, rsp_data5 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq5

// SEQUENCE5: write_word_seq5
class write_word_seq5 extends apb_master_base_seq5;
  rand bit [31:0] start_addr5;
  rand bit [31:0] write_data5;
  rand int unsigned transmit_del5;

  function new(string name="write_word_seq5");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq5)

  constraint transmit_del_ct5 { (transmit_del5 <= 10); }
  constraint addr_ct5 {(start_addr5[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr5;
        req.direction5 == APB_WRITE5;
        req.data == write_data5;
        req.transmit_delay5 == transmit_del5; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq5

// SEQUENCE5: read_after_write_seq5
class read_after_write_seq5 extends apb_master_base_seq5;

  rand bit [31:0] start_addr5;
  rand bit [31:0] write_data5;
  rand int unsigned transmit_del5;

  function new(string name="read_after_write_seq5");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq5)

  constraint transmit_del_ct5 { (transmit_del5 <= 10); }
  constraint addr_ct5 {(start_addr5[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr5;
        req.direction5 == APB_WRITE5;
        req.data == write_data5;
        req.transmit_delay5 == transmit_del5; } )
    `uvm_do_with(req, 
      { req.addr == start_addr5;
        req.direction5 == APB_READ5;
        req.transmit_delay5 == transmit_del5; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq5

// SEQUENCE5: multiple_read_after_write_seq5
class multiple_read_after_write_seq5 extends apb_master_base_seq5;

    read_after_write_seq5 raw_seq5;
    write_byte_seq5 w_seq5;
    read_byte_seq5 r_seq5;
    rand int unsigned num_of_seq5;

    function new(string name="multiple_read_after_write_seq5");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq5)

    constraint num_of_seq_c5 { num_of_seq5 <= 10; num_of_seq5 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq5; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq5)
      end
      repeat (3) `uvm_do_with(w_seq5, {transmit_del5 == 1;} )
      repeat (3) `uvm_do_with(r_seq5, {transmit_del5 == 1;} )
    endtask
endclass : multiple_read_after_write_seq5
`endif // APB_MASTER_SEQ_LIB_SV5
