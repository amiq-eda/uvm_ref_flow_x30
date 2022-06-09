// IVB5 checksum5: 2173772784
/*-----------------------------------------------------------------
File5 name     : ahb_transfer5.sv
Created5       : Wed5 May5 19 15:42:20 2010
Description5   :  This5 file declares5 the OVC5 transfer5. It is
              :  used by both master5 and slave5.
Notes5         :
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV5
`define AHB_TRANSFER_SV5

//------------------------------------------------------------------------------
//
// ahb5 transfer5 enums5, parameters5, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE5 = 0,
		HALFWORD5 = 1,
		WORD5 = 2,
		TWO_WORDS5 = 3,
		FOUR_WORDS5 = 4,
		EIGHT_WORDS5 = 5,
		SIXTEEN_WORDS5 = 6,
		K_BITS5 = 7
} ahb_transfer_size5;
typedef enum logic[1:0]  {
		IDLE5 = 0,
		BUSY5 = 1,
		NONSEQ5 = 2,
		SEQ = 3
} ahb_transfer_kind5;
typedef enum logic[1:0]  {
		OKAY5 = 0,
		ERROR5 = 1,
		RETRY5 = 2,
		SPLIT5 = 3
} ahb_response_kind5;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction5;
typedef enum logic[2:0]  {
		SINGLE5 = 0,
		INCR = 1,
		WRAP45 = 2,
		INCR45 = 3,
		WRAP85 = 4,
		INCR85 = 5,
		WRAP165 = 6,
		INCR165 = 7
} ahb_burst_kind5;
 
//------------------------------------------------------------------------------
//
// CLASS5: ahb_transfer5
//
//------------------------------------------------------------------------------

class ahb_transfer5 extends uvm_sequence_item;

  /***************************************************************************
   IVB5-NOTE5 : REQUIRED5 : transfer5 definitions5 : Item5 definitions5
   ---------------------------------------------------------------------------
   Adjust5 the transfer5 attribute5 names as required5 and add any 
   necessary5 attributes5.
   Note5 that if you change an attribute5 name, you must change it in all of your5
   OVC5 files.
   Make5 sure5 to edit5 the uvm_object_utils_begin to get various5 utilities5 (like5
   print and copy) for each attribute5 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH5-1:0] data;
  rand logic [`AHB_ADDR_WIDTH5-1:0] address;
  rand ahb_direction5 direction5 ;
  rand ahb_transfer_size5  hsize5;
  rand ahb_burst_kind5  burst;
  rand logic [3:0] prot5 ;
 
  `uvm_object_utils_begin(ahb_transfer5)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction5,direction5, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size5,hsize5, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind5,burst, UVM_ALL_ON)
    `uvm_field_int(prot5, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new (string name = "unnamed5-ahb_transfer5");
    super.new(name);
  endfunction : new

endclass : ahb_transfer5

`endif // AHB_TRANSFER_SV5

