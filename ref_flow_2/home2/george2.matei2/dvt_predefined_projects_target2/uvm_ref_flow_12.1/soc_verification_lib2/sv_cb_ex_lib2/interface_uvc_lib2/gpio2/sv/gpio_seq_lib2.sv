/*-------------------------------------------------------------------------
File2 name   : gpio_seq_lib2.sv
Title2       : GPIO2 SystemVerilog2 UVM UVC2
Project2     : SystemVerilog2 UVM Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
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


`ifndef GPIO_SEQ_LIB_SV2
`define GPIO_SEQ_LIB_SV2

class gpio_simple_trans_seq2 extends uvm_sequence #(gpio_transfer2);

  function new(string name="gpio_simple_trans_seq2");
    super.new(name);
  endfunction
  
  `uvm_object_utils(gpio_simple_trans_seq2)    
  `uvm_declare_p_sequencer(gpio_sequencer2)

  rand int unsigned transmit_del2 = 0;
  constraint transmit_del_ct2 { (transmit_del2 <= 10); }

  virtual task body();
    `uvm_info("GPIO_SEQ2", $psprintf("Doing gpio_simple_trans_seq2 Sequence"), UVM_HIGH)
    `uvm_do_with(req, {req.transmit_delay2 == transmit_del2;} )
  endtask
  
endclass : gpio_simple_trans_seq2

class gpio_multiple_simple_trans2 extends uvm_sequence #(gpio_transfer2);

    rand int unsigned cnt_i2;

    gpio_simple_trans_seq2 simple_trans2;

    function new(string name="gpio_multiple_simple_trans2");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(gpio_multiple_simple_trans2)    
   `uvm_declare_p_sequencer(gpio_sequencer2)

    constraint count_ct2 {cnt_i2 <= 10;}

    virtual task body();
      for (int i = 0; i < cnt_i2; i++)
      begin
        `uvm_do(simple_trans2)
      end
    endtask
endclass: gpio_multiple_simple_trans2

`endif // GPIO_SEQ_LIB_SV2

