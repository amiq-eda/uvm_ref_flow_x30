/*-------------------------------------------------------------------------
File7 name   : reg_to_apb_adapter7.sv
Title7       : Register Operations7 to APB7 Transactions7 Adapter Sequence
Project7     :
Created7     :
Description7 : UVM_REG - Adapter Sequence converts7 UVM register operations7
            : to APB7 bus transactions
Notes7       : This7 example7 does not provide7 any random transfer7 delay
            : for the transaction.  This7 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright7 1999-2011 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

class reg_to_apb_adapter7 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter7)

  function new(string name="reg_to_apb_adapter7");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer7 transfer7;
    transfer7 = apb_transfer7::type_id::create("transfer7");
    transfer7.addr = rw.addr;
    transfer7.data = rw.data;
    transfer7.direction7 = (rw.kind == UVM_READ) ? APB_READ7 : APB_WRITE7;
    return (transfer7);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer7 transfer7;
    if (!$cast(transfer7, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE7",
       "Provided bus_item is not of the correct7 type. Expecting7 apb_transfer7")
       return;
    end
    rw.kind =  (transfer7.direction7 == APB_READ7) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer7.addr;
    rw.data = transfer7.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO7 NOT7 SET IT7 AT7 ALL7 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter7
