// IVB18 checksum18: 2173772784
/*-----------------------------------------------------------------
File18 name     : ahb_transfer18.sv
Created18       : Wed18 May18 19 15:42:20 2010
Description18   :  This18 file declares18 the OVC18 transfer18. It is
              :  used by both master18 and slave18.
Notes18         :
-----------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV18
`define AHB_TRANSFER_SV18

//------------------------------------------------------------------------------
//
// ahb18 transfer18 enums18, parameters18, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE18 = 0,
		HALFWORD18 = 1,
		WORD18 = 2,
		TWO_WORDS18 = 3,
		FOUR_WORDS18 = 4,
		EIGHT_WORDS18 = 5,
		SIXTEEN_WORDS18 = 6,
		K_BITS18 = 7
} ahb_transfer_size18;
typedef enum logic[1:0]  {
		IDLE18 = 0,
		BUSY18 = 1,
		NONSEQ18 = 2,
		SEQ = 3
} ahb_transfer_kind18;
typedef enum logic[1:0]  {
		OKAY18 = 0,
		ERROR18 = 1,
		RETRY18 = 2,
		SPLIT18 = 3
} ahb_response_kind18;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction18;
typedef enum logic[2:0]  {
		SINGLE18 = 0,
		INCR = 1,
		WRAP418 = 2,
		INCR418 = 3,
		WRAP818 = 4,
		INCR818 = 5,
		WRAP1618 = 6,
		INCR1618 = 7
} ahb_burst_kind18;
 
//------------------------------------------------------------------------------
//
// CLASS18: ahb_transfer18
//
//------------------------------------------------------------------------------

class ahb_transfer18 extends uvm_sequence_item;

  /***************************************************************************
   IVB18-NOTE18 : REQUIRED18 : transfer18 definitions18 : Item18 definitions18
   ---------------------------------------------------------------------------
   Adjust18 the transfer18 attribute18 names as required18 and add any 
   necessary18 attributes18.
   Note18 that if you change an attribute18 name, you must change it in all of your18
   OVC18 files.
   Make18 sure18 to edit18 the uvm_object_utils_begin to get various18 utilities18 (like18
   print and copy) for each attribute18 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH18-1:0] data;
  rand logic [`AHB_ADDR_WIDTH18-1:0] address;
  rand ahb_direction18 direction18 ;
  rand ahb_transfer_size18  hsize18;
  rand ahb_burst_kind18  burst;
  rand logic [3:0] prot18 ;
 
  `uvm_object_utils_begin(ahb_transfer18)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction18,direction18, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size18,hsize18, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind18,burst, UVM_ALL_ON)
    `uvm_field_int(prot18, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor18 - required18 syntax18 for UVM automation18 and utilities18
  function new (string name = "unnamed18-ahb_transfer18");
    super.new(name);
  endfunction : new

endclass : ahb_transfer18

`endif // AHB_TRANSFER_SV18

