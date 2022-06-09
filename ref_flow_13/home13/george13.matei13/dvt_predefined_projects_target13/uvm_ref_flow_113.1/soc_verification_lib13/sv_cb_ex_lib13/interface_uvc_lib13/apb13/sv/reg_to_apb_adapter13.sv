/*-------------------------------------------------------------------------
File13 name   : reg_to_apb_adapter13.sv
Title13       : Register Operations13 to APB13 Transactions13 Adapter Sequence
Project13     :
Created13     :
Description13 : UVM_REG - Adapter Sequence converts13 UVM register operations13
            : to APB13 bus transactions
Notes13       : This13 example13 does not provide13 any random transfer13 delay
            : for the transaction.  This13 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright13 1999-2011 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

class reg_to_apb_adapter13 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter13)

  function new(string name="reg_to_apb_adapter13");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer13 transfer13;
    transfer13 = apb_transfer13::type_id::create("transfer13");
    transfer13.addr = rw.addr;
    transfer13.data = rw.data;
    transfer13.direction13 = (rw.kind == UVM_READ) ? APB_READ13 : APB_WRITE13;
    return (transfer13);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer13 transfer13;
    if (!$cast(transfer13, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE13",
       "Provided bus_item is not of the correct13 type. Expecting13 apb_transfer13")
       return;
    end
    rw.kind =  (transfer13.direction13 == APB_READ13) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer13.addr;
    rw.data = transfer13.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO13 NOT13 SET IT13 AT13 ALL13 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter13
