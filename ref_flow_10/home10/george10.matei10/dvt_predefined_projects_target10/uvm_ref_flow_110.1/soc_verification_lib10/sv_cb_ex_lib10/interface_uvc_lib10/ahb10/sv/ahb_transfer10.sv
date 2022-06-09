// IVB10 checksum10: 2173772784
/*-----------------------------------------------------------------
File10 name     : ahb_transfer10.sv
Created10       : Wed10 May10 19 15:42:20 2010
Description10   :  This10 file declares10 the OVC10 transfer10. It is
              :  used by both master10 and slave10.
Notes10         :
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV10
`define AHB_TRANSFER_SV10

//------------------------------------------------------------------------------
//
// ahb10 transfer10 enums10, parameters10, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE10 = 0,
		HALFWORD10 = 1,
		WORD10 = 2,
		TWO_WORDS10 = 3,
		FOUR_WORDS10 = 4,
		EIGHT_WORDS10 = 5,
		SIXTEEN_WORDS10 = 6,
		K_BITS10 = 7
} ahb_transfer_size10;
typedef enum logic[1:0]  {
		IDLE10 = 0,
		BUSY10 = 1,
		NONSEQ10 = 2,
		SEQ = 3
} ahb_transfer_kind10;
typedef enum logic[1:0]  {
		OKAY10 = 0,
		ERROR10 = 1,
		RETRY10 = 2,
		SPLIT10 = 3
} ahb_response_kind10;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction10;
typedef enum logic[2:0]  {
		SINGLE10 = 0,
		INCR = 1,
		WRAP410 = 2,
		INCR410 = 3,
		WRAP810 = 4,
		INCR810 = 5,
		WRAP1610 = 6,
		INCR1610 = 7
} ahb_burst_kind10;
 
//------------------------------------------------------------------------------
//
// CLASS10: ahb_transfer10
//
//------------------------------------------------------------------------------

class ahb_transfer10 extends uvm_sequence_item;

  /***************************************************************************
   IVB10-NOTE10 : REQUIRED10 : transfer10 definitions10 : Item10 definitions10
   ---------------------------------------------------------------------------
   Adjust10 the transfer10 attribute10 names as required10 and add any 
   necessary10 attributes10.
   Note10 that if you change an attribute10 name, you must change it in all of your10
   OVC10 files.
   Make10 sure10 to edit10 the uvm_object_utils_begin to get various10 utilities10 (like10
   print and copy) for each attribute10 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH10-1:0] data;
  rand logic [`AHB_ADDR_WIDTH10-1:0] address;
  rand ahb_direction10 direction10 ;
  rand ahb_transfer_size10  hsize10;
  rand ahb_burst_kind10  burst;
  rand logic [3:0] prot10 ;
 
  `uvm_object_utils_begin(ahb_transfer10)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction10,direction10, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size10,hsize10, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind10,burst, UVM_ALL_ON)
    `uvm_field_int(prot10, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor10 - required10 syntax10 for UVM automation10 and utilities10
  function new (string name = "unnamed10-ahb_transfer10");
    super.new(name);
  endfunction : new

endclass : ahb_transfer10

`endif // AHB_TRANSFER_SV10

