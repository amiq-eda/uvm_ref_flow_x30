/*-------------------------------------------------------------------------
File20 name   : reg_to_apb_adapter20.sv
Title20       : Register Operations20 to APB20 Transactions20 Adapter Sequence
Project20     :
Created20     :
Description20 : UVM_REG - Adapter Sequence converts20 UVM register operations20
            : to APB20 bus transactions
Notes20       : This20 example20 does not provide20 any random transfer20 delay
            : for the transaction.  This20 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright20 1999-2011 Cadence20 Design20 Systems20, Inc20.
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

class reg_to_apb_adapter20 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter20)

  function new(string name="reg_to_apb_adapter20");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer20 transfer20;
    transfer20 = apb_transfer20::type_id::create("transfer20");
    transfer20.addr = rw.addr;
    transfer20.data = rw.data;
    transfer20.direction20 = (rw.kind == UVM_READ) ? APB_READ20 : APB_WRITE20;
    return (transfer20);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer20 transfer20;
    if (!$cast(transfer20, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE20",
       "Provided bus_item is not of the correct20 type. Expecting20 apb_transfer20")
       return;
    end
    rw.kind =  (transfer20.direction20 == APB_READ20) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer20.addr;
    rw.data = transfer20.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO20 NOT20 SET IT20 AT20 ALL20 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter20
