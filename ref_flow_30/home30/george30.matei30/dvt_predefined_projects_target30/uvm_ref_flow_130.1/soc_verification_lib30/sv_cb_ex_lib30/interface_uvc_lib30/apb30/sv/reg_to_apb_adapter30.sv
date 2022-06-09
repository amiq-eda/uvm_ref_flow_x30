/*-------------------------------------------------------------------------
File30 name   : reg_to_apb_adapter30.sv
Title30       : Register Operations30 to APB30 Transactions30 Adapter Sequence
Project30     :
Created30     :
Description30 : UVM_REG - Adapter Sequence converts30 UVM register operations30
            : to APB30 bus transactions
Notes30       : This30 example30 does not provide30 any random transfer30 delay
            : for the transaction.  This30 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright30 1999-2011 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

class reg_to_apb_adapter30 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter30)

  function new(string name="reg_to_apb_adapter30");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer30 transfer30;
    transfer30 = apb_transfer30::type_id::create("transfer30");
    transfer30.addr = rw.addr;
    transfer30.data = rw.data;
    transfer30.direction30 = (rw.kind == UVM_READ) ? APB_READ30 : APB_WRITE30;
    return (transfer30);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer30 transfer30;
    if (!$cast(transfer30, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE30",
       "Provided bus_item is not of the correct30 type. Expecting30 apb_transfer30")
       return;
    end
    rw.kind =  (transfer30.direction30 == APB_READ30) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer30.addr;
    rw.data = transfer30.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO30 NOT30 SET IT30 AT30 ALL30 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter30
