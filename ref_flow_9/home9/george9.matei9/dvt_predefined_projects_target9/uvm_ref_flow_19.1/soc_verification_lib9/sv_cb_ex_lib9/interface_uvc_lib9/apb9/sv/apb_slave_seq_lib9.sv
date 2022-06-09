/*******************************************************************************
  FILE : apb_slave_seq_lib9.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_SEQ_LIB_SV9
`define APB_SLAVE_SEQ_LIB_SV9

//------------------------------------------------------------------------------
// SEQUENCE9: simple_response_seq9
//------------------------------------------------------------------------------

class simple_response_seq9 extends uvm_sequence #(apb_transfer9);

  function new(string name="simple_response_seq9");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq9)
  `uvm_declare_p_sequencer(apb_slave_sequencer9)

  apb_transfer9 req;
  apb_transfer9 util_transfer9;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port9.peek(util_transfer9);
      if((util_transfer9.direction9 == APB_READ9) && 
        (p_sequencer.cfg.check_address_range9(util_transfer9.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range9 Matching9 read.  Responding9...", util_transfer9.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction9 == APB_READ9; } )
      end
    end
  endtask : body

endclass : simple_response_seq9

//------------------------------------------------------------------------------
// SEQUENCE9: mem_response_seq9
//------------------------------------------------------------------------------
class mem_response_seq9 extends uvm_sequence #(apb_transfer9);

  function new(string name="mem_response_seq9");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data9;

  `uvm_object_utils(mem_response_seq9)
  `uvm_declare_p_sequencer(apb_slave_sequencer9)

  //simple9 assoc9 array to hold9 values
  logic [31:0] slave_mem9[int];

  apb_transfer9 req;
  apb_transfer9 util_transfer9;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port9.peek(util_transfer9);
      if((util_transfer9.direction9 == APB_READ9) && 
        (p_sequencer.cfg.check_address_range9(util_transfer9.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range9 Matching9 APB_READ9.  Responding9...", util_transfer9.addr), UVM_MEDIUM);
        if (slave_mem9.exists(util_transfer9.addr))
        `uvm_do_with(req, { req.direction9 == APB_READ9;
                            req.addr == util_transfer9.addr;
                            req.data == slave_mem9[util_transfer9.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction9 == APB_READ9;
                            req.addr == util_transfer9.addr;
                            req.data == mem_data9; } )
         mem_data9++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range9(util_transfer9.addr) == 1) begin
        slave_mem9[util_transfer9.addr] = util_transfer9.data;
        // DUMMY9 response with same information
        `uvm_do_with(req, { req.direction9 == APB_WRITE9;
                            req.addr == util_transfer9.addr;
                            req.data == util_transfer9.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq9

`endif // APB_SLAVE_SEQ_LIB_SV9
