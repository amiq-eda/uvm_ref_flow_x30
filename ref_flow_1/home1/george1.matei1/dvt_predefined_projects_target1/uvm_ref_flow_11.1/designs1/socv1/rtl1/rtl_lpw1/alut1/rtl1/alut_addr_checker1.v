//File1 name   : alut_addr_checker1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

// compiler1 directives1
`include "alut_defines1.v"


module alut_addr_checker1
(   
   // Inputs1
   pclk1,
   n_p_reset1,
   command,
   mac_addr1,
   d_addr1,
   s_addr1,
   s_port1,
   curr_time1,
   mem_read_data_add1,
   age_confirmed1,
   age_ok1,
   clear_reused1,

   //outputs1
   d_port1,
   add_check_active1,
   mem_addr_add1,
   mem_write_add1,
   mem_write_data_add1,
   lst_inv_addr_nrm1,
   lst_inv_port_nrm1,
   check_age1,
   last_accessed1,
   reused1
);



   input               pclk1;               // APB1 clock1                           
   input               n_p_reset1;          // Reset1                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr1;           // address of the switch1              
   input [47:0]        d_addr1;             // address of frame1 to be checked1     
   input [47:0]        s_addr1;             // address of frame1 to be stored1      
   input [1:0]         s_port1;             // source1 port of current frame1       
   input [31:0]        curr_time1;          // current time,for storing1 in mem    
   input [82:0]        mem_read_data_add1;  // read data from mem                 
   input               age_confirmed1;      // valid flag1 from age1 checker        
   input               age_ok1;             // result from age1 checker 
   input               clear_reused1;       // read/clear flag1 for reused1 signal1           

   output [4:0]        d_port1;             // calculated1 destination1 port for tx1 
   output              add_check_active1;   // bit 0 of status register           
   output [7:0]        mem_addr_add1;       // hash1 address for R/W1 to memory     
   output              mem_write_add1;      // R/W1 flag1 (write = high1)            
   output [82:0]       mem_write_data_add1; // write data for memory             
   output [47:0]       lst_inv_addr_nrm1;   // last invalidated1 addr normal1 op    
   output [1:0]        lst_inv_port_nrm1;   // last invalidated1 port normal1 op    
   output              check_age1;          // request flag1 for age1 check
   output [31:0]       last_accessed1;      // time field sent1 for age1 check
   output              reused1;             // indicates1 ALUT1 location1 overwritten1

   reg   [2:0]         add_chk_state1;      // current address checker state
   reg   [2:0]         nxt_add_chk_state1;  // current address checker state
   reg   [4:0]         d_port1;             // calculated1 destination1 port for tx1 
   reg   [3:0]         port_mem1;           // bitwise1 conversion1 of 2bit port
   reg   [7:0]         mem_addr_add1;       // hash1 address for R/W1 to memory
   reg                 mem_write_add1;      // R/W1 flag1 (write = high1)            
   reg                 reused1;             // indicates1 ALUT1 location1 overwritten1
   reg   [47:0]        lst_inv_addr_nrm1;   // last invalidated1 addr normal1 op    
   reg   [1:0]         lst_inv_port_nrm1;   // last invalidated1 port normal1 op    
   reg                 check_age1;          // request flag1 for age1 checker
   reg   [31:0]        last_accessed1;      // time field sent1 for age1 check


   wire   [7:0]        s_addr_hash1;        // hash1 of address for storing1
   wire   [7:0]        d_addr_hash1;        // hash1 of address for checking
   wire   [82:0]       mem_write_data_add1; // write data for memory  
   wire                add_check_active1;   // bit 0 of status register           


// Parameters1 for Address Checking1 FSM1 states1
   parameter idle1           = 3'b000;
   parameter mac_addr_chk1   = 3'b001;
   parameter read_dest_add1  = 3'b010;
   parameter valid_chk1      = 3'b011;
   parameter age_chk1        = 3'b100;
   parameter addr_chk1       = 3'b101;
   parameter read_src_add1   = 3'b110;
   parameter write_src1      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash1 conversion1 of source1 and destination1 addresses1
// -----------------------------------------------------------------------------
   assign s_addr_hash1 = s_addr1[7:0] ^ s_addr1[15:8] ^ s_addr1[23:16] ^
                        s_addr1[31:24] ^ s_addr1[39:32] ^ s_addr1[47:40];

   assign d_addr_hash1 = d_addr1[7:0] ^ d_addr1[15:8] ^ d_addr1[23:16] ^
                        d_addr1[31:24] ^ d_addr1[39:32] ^ d_addr1[47:40];



// -----------------------------------------------------------------------------
//   State1 Machine1 For1 handling1 the destination1 address checking process and
//   and storing1 of new source1 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state1 or age_confirmed1 or age_ok1)
   begin
      case (add_chk_state1)
      
      idle1:
         if (command == 2'b01)
            nxt_add_chk_state1 = mac_addr_chk1;
         else
            nxt_add_chk_state1 = idle1;

      mac_addr_chk1:   // check if destination1 address match MAC1 switch1 address
         if (d_addr1 == mac_addr1)
            nxt_add_chk_state1 = idle1;  // return dest1 port as 5'b1_0000
         else
            nxt_add_chk_state1 = read_dest_add1;

      read_dest_add1:       // read data from memory using hash1 of destination1 address
            nxt_add_chk_state1 = valid_chk1;

      valid_chk1:      // check if read data had1 valid bit set
         nxt_add_chk_state1 = age_chk1;

      age_chk1:        // request age1 checker to check if still in date1
         if (age_confirmed1)
            nxt_add_chk_state1 = addr_chk1;
         else
            nxt_add_chk_state1 = age_chk1; 

      addr_chk1:       // perform1 compare between dest1 and read addresses1
            nxt_add_chk_state1 = read_src_add1; // return read port from ALUT1 mem

      read_src_add1:   // read from memory location1 about1 to be overwritten1
            nxt_add_chk_state1 = write_src1; 

      write_src1:      // write new source1 data (addr and port) to memory
            nxt_add_chk_state1 = idle1; 

      default:
            nxt_add_chk_state1 = idle1;
      endcase
   end


// destination1 check FSM1 current state
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      add_chk_state1 <= idle1;
   else
      add_chk_state1 <= nxt_add_chk_state1;
   end



// -----------------------------------------------------------------------------
//   Generate1 returned value of port for sending1 new frame1 to
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      d_port1 <= 5'b0_1111;
   else if ((add_chk_state1 == mac_addr_chk1) & (d_addr1 == mac_addr1))
      d_port1 <= 5'b1_0000;
   else if (((add_chk_state1 == valid_chk1) & ~mem_read_data_add1[82]) |
            ((add_chk_state1 == age_chk1) & ~(age_confirmed1 & age_ok1)) |
            ((add_chk_state1 == addr_chk1) & (d_addr1 != mem_read_data_add1[47:0])))
      d_port1 <= 5'b0_1111 & ~( 1 << s_port1 );
   else if ((add_chk_state1 == addr_chk1) & (d_addr1 == mem_read_data_add1[47:0]))
      d_port1 <= {1'b0, port_mem1} & ~( 1 << s_port1 );
   else
      d_port1 <= d_port1;
   end


// -----------------------------------------------------------------------------
//   convert read port source1 value from 2bits to bitwise1 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      port_mem1 <= 4'b1111;
   else begin
      case (mem_read_data_add1[49:48])
         2'b00: port_mem1 <= 4'b0001;
         2'b01: port_mem1 <= 4'b0010;
         2'b10: port_mem1 <= 4'b0100;
         2'b11: port_mem1 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded1 off1 add_chk_state1
// -----------------------------------------------------------------------------
assign add_check_active1 = (add_chk_state1 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate1 memory addressing1 signals1.
//   The check address command will be taken1 as the indication1 from SW1 that the 
//   source1 fields (address and port) can be written1 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1) 
   begin
       mem_write_add1 <= 1'b0;
       mem_addr_add1  <= 8'd0;
   end
   else if (add_chk_state1 == read_dest_add1)
   begin
       mem_write_add1 <= 1'b0;
       mem_addr_add1  <= d_addr_hash1;
   end
// Need1 to set address two1 cycles1 before check
   else if ( (add_chk_state1 == age_chk1) && age_confirmed1 )
   begin
       mem_write_add1 <= 1'b0;
       mem_addr_add1  <= s_addr_hash1;
   end
   else if (add_chk_state1 == write_src1)
   begin
       mem_write_add1 <= 1'b1;
       mem_addr_add1  <= s_addr_hash1;
   end
   else
   begin
       mem_write_add1 <= 1'b0;
       mem_addr_add1  <= d_addr_hash1;
   end
   end


// -----------------------------------------------------------------------------
//   Generate1 databus1 for writing to memory
//   Data written1 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add1 = {1'b1, curr_time1, s_port1, s_addr1};



// -----------------------------------------------------------------------------
//   Evaluate1 read back data that is about1 to be overwritten1 with new source1 
//   address and port values. Decide1 whether1 the reused1 flag1 must be set and
//   last_inval1 address and port values updated.
//   reused1 needs1 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1) 
   begin
      reused1 <= 1'b0;
      lst_inv_addr_nrm1 <= 48'd0;
      lst_inv_port_nrm1 <= 2'd0;
   end
   else if ((add_chk_state1 == read_src_add1) & mem_read_data_add1[82] &
            (s_addr1 != mem_read_data_add1[47:0]))
   begin
      reused1 <= 1'b1;
      lst_inv_addr_nrm1 <= mem_read_data_add1[47:0];
      lst_inv_port_nrm1 <= mem_read_data_add1[49:48];
   end
   else if (clear_reused1)
   begin
      reused1 <= 1'b0;
      lst_inv_addr_nrm1 <= lst_inv_addr_nrm1;
      lst_inv_port_nrm1 <= lst_inv_addr_nrm1;
   end
   else 
   begin
      reused1 <= reused1;
      lst_inv_addr_nrm1 <= lst_inv_addr_nrm1;
      lst_inv_port_nrm1 <= lst_inv_addr_nrm1;
   end
   end


// -----------------------------------------------------------------------------
//   Generate1 signals1 for age1 checker to perform1 in-date1 check
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1) 
   begin
      check_age1 <= 1'b0;  
      last_accessed1 <= 32'd0;
   end
   else if (check_age1)
   begin
      check_age1 <= 1'b0;  
      last_accessed1 <= mem_read_data_add1[81:50];
   end
   else if (add_chk_state1 == age_chk1)
   begin
      check_age1 <= 1'b1;  
      last_accessed1 <= mem_read_data_add1[81:50];
   end
   else 
   begin
      check_age1 <= 1'b0;  
      last_accessed1 <= 32'd0;
   end
   end


`ifdef ABV_ON1

// psl1 default clock1 = (posedge pclk1);

// ASSERTION1 CHECKS1
/* Commented1 out as also checking in toplevel1
// it should never be possible1 for the destination1 port to indicate1 the MAC1
// switch1 address and one of the other 4 Ethernets1
// psl1 assert_valid_dest_port1 : assert never (d_port1[4] & |{d_port1[3:0]});


// COVER1 SANITY1 CHECKS1
// check all values of destination1 port can be returned.
// psl1 cover_d_port_01 : cover { d_port1 == 5'b0_0001 };
// psl1 cover_d_port_11 : cover { d_port1 == 5'b0_0010 };
// psl1 cover_d_port_21 : cover { d_port1 == 5'b0_0100 };
// psl1 cover_d_port_31 : cover { d_port1 == 5'b0_1000 };
// psl1 cover_d_port_41 : cover { d_port1 == 5'b1_0000 };
// psl1 cover_d_port_all1 : cover { d_port1 == 5'b0_1111 };
*/
`endif


endmodule 









