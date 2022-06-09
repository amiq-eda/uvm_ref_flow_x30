/*-------------------------------------------------------------------------
File26 name   : reg_to_apb_adapter26.sv
Title26       : Register Operations26 to APB26 Transactions26 Adapter Sequence
Project26     :
Created26     :
Description26 : UVM_REG - Adapter Sequence converts26 UVM register operations26
            : to APB26 bus transactions
Notes26       : This26 example26 does not provide26 any random transfer26 delay
            : for the transaction.  This26 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright26 1999-2011 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

class reg_to_apb_adapter26 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter26)

  function new(string name="reg_to_apb_adapter26");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer26 transfer26;
    transfer26 = apb_transfer26::type_id::create("transfer26");
    transfer26.addr = rw.addr;
    transfer26.data = rw.data;
    transfer26.direction26 = (rw.kind == UVM_READ) ? APB_READ26 : APB_WRITE26;
    return (transfer26);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer26 transfer26;
    if (!$cast(transfer26, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE26",
       "Provided bus_item is not of the correct26 type. Expecting26 apb_transfer26")
       return;
    end
    rw.kind =  (transfer26.direction26 == APB_READ26) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer26.addr;
    rw.data = transfer26.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO26 NOT26 SET IT26 AT26 ALL26 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter26
