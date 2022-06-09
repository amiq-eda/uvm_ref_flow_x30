// IVB7 checksum7: 2173772784
/*-----------------------------------------------------------------
File7 name     : ahb_transfer7.sv
Created7       : Wed7 May7 19 15:42:20 2010
Description7   :  This7 file declares7 the OVC7 transfer7. It is
              :  used by both master7 and slave7.
Notes7         :
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
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


`ifndef AHB_TRANSFER_SV7
`define AHB_TRANSFER_SV7

//------------------------------------------------------------------------------
//
// ahb7 transfer7 enums7, parameters7, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE7 = 0,
		HALFWORD7 = 1,
		WORD7 = 2,
		TWO_WORDS7 = 3,
		FOUR_WORDS7 = 4,
		EIGHT_WORDS7 = 5,
		SIXTEEN_WORDS7 = 6,
		K_BITS7 = 7
} ahb_transfer_size7;
typedef enum logic[1:0]  {
		IDLE7 = 0,
		BUSY7 = 1,
		NONSEQ7 = 2,
		SEQ = 3
} ahb_transfer_kind7;
typedef enum logic[1:0]  {
		OKAY7 = 0,
		ERROR7 = 1,
		RETRY7 = 2,
		SPLIT7 = 3
} ahb_response_kind7;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction7;
typedef enum logic[2:0]  {
		SINGLE7 = 0,
		INCR = 1,
		WRAP47 = 2,
		INCR47 = 3,
		WRAP87 = 4,
		INCR87 = 5,
		WRAP167 = 6,
		INCR167 = 7
} ahb_burst_kind7;
 
//------------------------------------------------------------------------------
//
// CLASS7: ahb_transfer7
//
//------------------------------------------------------------------------------

class ahb_transfer7 extends uvm_sequence_item;

  /***************************************************************************
   IVB7-NOTE7 : REQUIRED7 : transfer7 definitions7 : Item7 definitions7
   ---------------------------------------------------------------------------
   Adjust7 the transfer7 attribute7 names as required7 and add any 
   necessary7 attributes7.
   Note7 that if you change an attribute7 name, you must change it in all of your7
   OVC7 files.
   Make7 sure7 to edit7 the uvm_object_utils_begin to get various7 utilities7 (like7
   print and copy) for each attribute7 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH7-1:0] data;
  rand logic [`AHB_ADDR_WIDTH7-1:0] address;
  rand ahb_direction7 direction7 ;
  rand ahb_transfer_size7  hsize7;
  rand ahb_burst_kind7  burst;
  rand logic [3:0] prot7 ;
 
  `uvm_object_utils_begin(ahb_transfer7)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction7,direction7, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size7,hsize7, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind7,burst, UVM_ALL_ON)
    `uvm_field_int(prot7, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor7 - required7 syntax7 for UVM automation7 and utilities7
  function new (string name = "unnamed7-ahb_transfer7");
    super.new(name);
  endfunction : new

endclass : ahb_transfer7

`endif // AHB_TRANSFER_SV7

