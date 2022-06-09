/*******************************************************************************
  FILE : apb_slave_seq_lib20.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_SEQ_LIB_SV20
`define APB_SLAVE_SEQ_LIB_SV20

//------------------------------------------------------------------------------
// SEQUENCE20: simple_response_seq20
//------------------------------------------------------------------------------

class simple_response_seq20 extends uvm_sequence #(apb_transfer20);

  function new(string name="simple_response_seq20");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq20)
  `uvm_declare_p_sequencer(apb_slave_sequencer20)

  apb_transfer20 req;
  apb_transfer20 util_transfer20;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port20.peek(util_transfer20);
      if((util_transfer20.direction20 == APB_READ20) && 
        (p_sequencer.cfg.check_address_range20(util_transfer20.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range20 Matching20 read.  Responding20...", util_transfer20.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction20 == APB_READ20; } )
      end
    end
  endtask : body

endclass : simple_response_seq20

//------------------------------------------------------------------------------
// SEQUENCE20: mem_response_seq20
//------------------------------------------------------------------------------
class mem_response_seq20 extends uvm_sequence #(apb_transfer20);

  function new(string name="mem_response_seq20");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data20;

  `uvm_object_utils(mem_response_seq20)
  `uvm_declare_p_sequencer(apb_slave_sequencer20)

  //simple20 assoc20 array to hold20 values
  logic [31:0] slave_mem20[int];

  apb_transfer20 req;
  apb_transfer20 util_transfer20;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port20.peek(util_transfer20);
      if((util_transfer20.direction20 == APB_READ20) && 
        (p_sequencer.cfg.check_address_range20(util_transfer20.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range20 Matching20 APB_READ20.  Responding20...", util_transfer20.addr), UVM_MEDIUM);
        if (slave_mem20.exists(util_transfer20.addr))
        `uvm_do_with(req, { req.direction20 == APB_READ20;
                            req.addr == util_transfer20.addr;
                            req.data == slave_mem20[util_transfer20.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction20 == APB_READ20;
                            req.addr == util_transfer20.addr;
                            req.data == mem_data20; } )
         mem_data20++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range20(util_transfer20.addr) == 1) begin
        slave_mem20[util_transfer20.addr] = util_transfer20.data;
        // DUMMY20 response with same information
        `uvm_do_with(req, { req.direction20 == APB_WRITE20;
                            req.addr == util_transfer20.addr;
                            req.data == util_transfer20.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq20

`endif // APB_SLAVE_SEQ_LIB_SV20
