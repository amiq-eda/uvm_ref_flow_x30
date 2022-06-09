/*******************************************************************************
  FILE : apb_slave_seq_lib11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV11
`define APB_SLAVE_SEQ_LIB_SV11

//------------------------------------------------------------------------------
// SEQUENCE11: simple_response_seq11
//------------------------------------------------------------------------------

class simple_response_seq11 extends uvm_sequence #(apb_transfer11);

  function new(string name="simple_response_seq11");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq11)
  `uvm_declare_p_sequencer(apb_slave_sequencer11)

  apb_transfer11 req;
  apb_transfer11 util_transfer11;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port11.peek(util_transfer11);
      if((util_transfer11.direction11 == APB_READ11) && 
        (p_sequencer.cfg.check_address_range11(util_transfer11.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range11 Matching11 read.  Responding11...", util_transfer11.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction11 == APB_READ11; } )
      end
    end
  endtask : body

endclass : simple_response_seq11

//------------------------------------------------------------------------------
// SEQUENCE11: mem_response_seq11
//------------------------------------------------------------------------------
class mem_response_seq11 extends uvm_sequence #(apb_transfer11);

  function new(string name="mem_response_seq11");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data11;

  `uvm_object_utils(mem_response_seq11)
  `uvm_declare_p_sequencer(apb_slave_sequencer11)

  //simple11 assoc11 array to hold11 values
  logic [31:0] slave_mem11[int];

  apb_transfer11 req;
  apb_transfer11 util_transfer11;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port11.peek(util_transfer11);
      if((util_transfer11.direction11 == APB_READ11) && 
        (p_sequencer.cfg.check_address_range11(util_transfer11.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range11 Matching11 APB_READ11.  Responding11...", util_transfer11.addr), UVM_MEDIUM);
        if (slave_mem11.exists(util_transfer11.addr))
        `uvm_do_with(req, { req.direction11 == APB_READ11;
                            req.addr == util_transfer11.addr;
                            req.data == slave_mem11[util_transfer11.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction11 == APB_READ11;
                            req.addr == util_transfer11.addr;
                            req.data == mem_data11; } )
         mem_data11++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range11(util_transfer11.addr) == 1) begin
        slave_mem11[util_transfer11.addr] = util_transfer11.data;
        // DUMMY11 response with same information
        `uvm_do_with(req, { req.direction11 == APB_WRITE11;
                            req.addr == util_transfer11.addr;
                            req.data == util_transfer11.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq11

`endif // APB_SLAVE_SEQ_LIB_SV11
