// IVB30 checksum30: 2173772784
/*-----------------------------------------------------------------
File30 name     : ahb_transfer30.sv
Created30       : Wed30 May30 19 15:42:20 2010
Description30   :  This30 file declares30 the OVC30 transfer30. It is
              :  used by both master30 and slave30.
Notes30         :
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
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


`ifndef AHB_TRANSFER_SV30
`define AHB_TRANSFER_SV30

//------------------------------------------------------------------------------
//
// ahb30 transfer30 enums30, parameters30, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE30 = 0,
		HALFWORD30 = 1,
		WORD30 = 2,
		TWO_WORDS30 = 3,
		FOUR_WORDS30 = 4,
		EIGHT_WORDS30 = 5,
		SIXTEEN_WORDS30 = 6,
		K_BITS30 = 7
} ahb_transfer_size30;
typedef enum logic[1:0]  {
		IDLE30 = 0,
		BUSY30 = 1,
		NONSEQ30 = 2,
		SEQ = 3
} ahb_transfer_kind30;
typedef enum logic[1:0]  {
		OKAY30 = 0,
		ERROR30 = 1,
		RETRY30 = 2,
		SPLIT30 = 3
} ahb_response_kind30;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction30;
typedef enum logic[2:0]  {
		SINGLE30 = 0,
		INCR = 1,
		WRAP430 = 2,
		INCR430 = 3,
		WRAP830 = 4,
		INCR830 = 5,
		WRAP1630 = 6,
		INCR1630 = 7
} ahb_burst_kind30;
 
//------------------------------------------------------------------------------
//
// CLASS30: ahb_transfer30
//
//------------------------------------------------------------------------------

class ahb_transfer30 extends uvm_sequence_item;

  /***************************************************************************
   IVB30-NOTE30 : REQUIRED30 : transfer30 definitions30 : Item30 definitions30
   ---------------------------------------------------------------------------
   Adjust30 the transfer30 attribute30 names as required30 and add any 
   necessary30 attributes30.
   Note30 that if you change an attribute30 name, you must change it in all of your30
   OVC30 files.
   Make30 sure30 to edit30 the uvm_object_utils_begin to get various30 utilities30 (like30
   print and copy) for each attribute30 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH30-1:0] data;
  rand logic [`AHB_ADDR_WIDTH30-1:0] address;
  rand ahb_direction30 direction30 ;
  rand ahb_transfer_size30  hsize30;
  rand ahb_burst_kind30  burst;
  rand logic [3:0] prot30 ;
 
  `uvm_object_utils_begin(ahb_transfer30)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction30,direction30, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size30,hsize30, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind30,burst, UVM_ALL_ON)
    `uvm_field_int(prot30, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new (string name = "unnamed30-ahb_transfer30");
    super.new(name);
  endfunction : new

endclass : ahb_transfer30

`endif // AHB_TRANSFER_SV30

