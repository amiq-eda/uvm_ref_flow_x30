//File3 name   : alut_addr_checker3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

// compiler3 directives3
`include "alut_defines3.v"


module alut_addr_checker3
(   
   // Inputs3
   pclk3,
   n_p_reset3,
   command,
   mac_addr3,
   d_addr3,
   s_addr3,
   s_port3,
   curr_time3,
   mem_read_data_add3,
   age_confirmed3,
   age_ok3,
   clear_reused3,

   //outputs3
   d_port3,
   add_check_active3,
   mem_addr_add3,
   mem_write_add3,
   mem_write_data_add3,
   lst_inv_addr_nrm3,
   lst_inv_port_nrm3,
   check_age3,
   last_accessed3,
   reused3
);



   input               pclk3;               // APB3 clock3                           
   input               n_p_reset3;          // Reset3                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr3;           // address of the switch3              
   input [47:0]        d_addr3;             // address of frame3 to be checked3     
   input [47:0]        s_addr3;             // address of frame3 to be stored3      
   input [1:0]         s_port3;             // source3 port of current frame3       
   input [31:0]        curr_time3;          // current time,for storing3 in mem    
   input [82:0]        mem_read_data_add3;  // read data from mem                 
   input               age_confirmed3;      // valid flag3 from age3 checker        
   input               age_ok3;             // result from age3 checker 
   input               clear_reused3;       // read/clear flag3 for reused3 signal3           

   output [4:0]        d_port3;             // calculated3 destination3 port for tx3 
   output              add_check_active3;   // bit 0 of status register           
   output [7:0]        mem_addr_add3;       // hash3 address for R/W3 to memory     
   output              mem_write_add3;      // R/W3 flag3 (write = high3)            
   output [82:0]       mem_write_data_add3; // write data for memory             
   output [47:0]       lst_inv_addr_nrm3;   // last invalidated3 addr normal3 op    
   output [1:0]        lst_inv_port_nrm3;   // last invalidated3 port normal3 op    
   output              check_age3;          // request flag3 for age3 check
   output [31:0]       last_accessed3;      // time field sent3 for age3 check
   output              reused3;             // indicates3 ALUT3 location3 overwritten3

   reg   [2:0]         add_chk_state3;      // current address checker state
   reg   [2:0]         nxt_add_chk_state3;  // current address checker state
   reg   [4:0]         d_port3;             // calculated3 destination3 port for tx3 
   reg   [3:0]         port_mem3;           // bitwise3 conversion3 of 2bit port
   reg   [7:0]         mem_addr_add3;       // hash3 address for R/W3 to memory
   reg                 mem_write_add3;      // R/W3 flag3 (write = high3)            
   reg                 reused3;             // indicates3 ALUT3 location3 overwritten3
   reg   [47:0]        lst_inv_addr_nrm3;   // last invalidated3 addr normal3 op    
   reg   [1:0]         lst_inv_port_nrm3;   // last invalidated3 port normal3 op    
   reg                 check_age3;          // request flag3 for age3 checker
   reg   [31:0]        last_accessed3;      // time field sent3 for age3 check


   wire   [7:0]        s_addr_hash3;        // hash3 of address for storing3
   wire   [7:0]        d_addr_hash3;        // hash3 of address for checking
   wire   [82:0]       mem_write_data_add3; // write data for memory  
   wire                add_check_active3;   // bit 0 of status register           


// Parameters3 for Address Checking3 FSM3 states3
   parameter idle3           = 3'b000;
   parameter mac_addr_chk3   = 3'b001;
   parameter read_dest_add3  = 3'b010;
   parameter valid_chk3      = 3'b011;
   parameter age_chk3        = 3'b100;
   parameter addr_chk3       = 3'b101;
   parameter read_src_add3   = 3'b110;
   parameter write_src3      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash3 conversion3 of source3 and destination3 addresses3
// -----------------------------------------------------------------------------
   assign s_addr_hash3 = s_addr3[7:0] ^ s_addr3[15:8] ^ s_addr3[23:16] ^
                        s_addr3[31:24] ^ s_addr3[39:32] ^ s_addr3[47:40];

   assign d_addr_hash3 = d_addr3[7:0] ^ d_addr3[15:8] ^ d_addr3[23:16] ^
                        d_addr3[31:24] ^ d_addr3[39:32] ^ d_addr3[47:40];



// -----------------------------------------------------------------------------
//   State3 Machine3 For3 handling3 the destination3 address checking process and
//   and storing3 of new source3 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state3 or age_confirmed3 or age_ok3)
   begin
      case (add_chk_state3)
      
      idle3:
         if (command == 2'b01)
            nxt_add_chk_state3 = mac_addr_chk3;
         else
            nxt_add_chk_state3 = idle3;

      mac_addr_chk3:   // check if destination3 address match MAC3 switch3 address
         if (d_addr3 == mac_addr3)
            nxt_add_chk_state3 = idle3;  // return dest3 port as 5'b1_0000
         else
            nxt_add_chk_state3 = read_dest_add3;

      read_dest_add3:       // read data from memory using hash3 of destination3 address
            nxt_add_chk_state3 = valid_chk3;

      valid_chk3:      // check if read data had3 valid bit set
         nxt_add_chk_state3 = age_chk3;

      age_chk3:        // request age3 checker to check if still in date3
         if (age_confirmed3)
            nxt_add_chk_state3 = addr_chk3;
         else
            nxt_add_chk_state3 = age_chk3; 

      addr_chk3:       // perform3 compare between dest3 and read addresses3
            nxt_add_chk_state3 = read_src_add3; // return read port from ALUT3 mem

      read_src_add3:   // read from memory location3 about3 to be overwritten3
            nxt_add_chk_state3 = write_src3; 

      write_src3:      // write new source3 data (addr and port) to memory
            nxt_add_chk_state3 = idle3; 

      default:
            nxt_add_chk_state3 = idle3;
      endcase
   end


// destination3 check FSM3 current state
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      add_chk_state3 <= idle3;
   else
      add_chk_state3 <= nxt_add_chk_state3;
   end



// -----------------------------------------------------------------------------
//   Generate3 returned value of port for sending3 new frame3 to
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      d_port3 <= 5'b0_1111;
   else if ((add_chk_state3 == mac_addr_chk3) & (d_addr3 == mac_addr3))
      d_port3 <= 5'b1_0000;
   else if (((add_chk_state3 == valid_chk3) & ~mem_read_data_add3[82]) |
            ((add_chk_state3 == age_chk3) & ~(age_confirmed3 & age_ok3)) |
            ((add_chk_state3 == addr_chk3) & (d_addr3 != mem_read_data_add3[47:0])))
      d_port3 <= 5'b0_1111 & ~( 1 << s_port3 );
   else if ((add_chk_state3 == addr_chk3) & (d_addr3 == mem_read_data_add3[47:0]))
      d_port3 <= {1'b0, port_mem3} & ~( 1 << s_port3 );
   else
      d_port3 <= d_port3;
   end


// -----------------------------------------------------------------------------
//   convert read port source3 value from 2bits to bitwise3 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      port_mem3 <= 4'b1111;
   else begin
      case (mem_read_data_add3[49:48])
         2'b00: port_mem3 <= 4'b0001;
         2'b01: port_mem3 <= 4'b0010;
         2'b10: port_mem3 <= 4'b0100;
         2'b11: port_mem3 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded3 off3 add_chk_state3
// -----------------------------------------------------------------------------
assign add_check_active3 = (add_chk_state3 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate3 memory addressing3 signals3.
//   The check address command will be taken3 as the indication3 from SW3 that the 
//   source3 fields (address and port) can be written3 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3) 
   begin
       mem_write_add3 <= 1'b0;
       mem_addr_add3  <= 8'd0;
   end
   else if (add_chk_state3 == read_dest_add3)
   begin
       mem_write_add3 <= 1'b0;
       mem_addr_add3  <= d_addr_hash3;
   end
// Need3 to set address two3 cycles3 before check
   else if ( (add_chk_state3 == age_chk3) && age_confirmed3 )
   begin
       mem_write_add3 <= 1'b0;
       mem_addr_add3  <= s_addr_hash3;
   end
   else if (add_chk_state3 == write_src3)
   begin
       mem_write_add3 <= 1'b1;
       mem_addr_add3  <= s_addr_hash3;
   end
   else
   begin
       mem_write_add3 <= 1'b0;
       mem_addr_add3  <= d_addr_hash3;
   end
   end


// -----------------------------------------------------------------------------
//   Generate3 databus3 for writing to memory
//   Data written3 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add3 = {1'b1, curr_time3, s_port3, s_addr3};



// -----------------------------------------------------------------------------
//   Evaluate3 read back data that is about3 to be overwritten3 with new source3 
//   address and port values. Decide3 whether3 the reused3 flag3 must be set and
//   last_inval3 address and port values updated.
//   reused3 needs3 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3) 
   begin
      reused3 <= 1'b0;
      lst_inv_addr_nrm3 <= 48'd0;
      lst_inv_port_nrm3 <= 2'd0;
   end
   else if ((add_chk_state3 == read_src_add3) & mem_read_data_add3[82] &
            (s_addr3 != mem_read_data_add3[47:0]))
   begin
      reused3 <= 1'b1;
      lst_inv_addr_nrm3 <= mem_read_data_add3[47:0];
      lst_inv_port_nrm3 <= mem_read_data_add3[49:48];
   end
   else if (clear_reused3)
   begin
      reused3 <= 1'b0;
      lst_inv_addr_nrm3 <= lst_inv_addr_nrm3;
      lst_inv_port_nrm3 <= lst_inv_addr_nrm3;
   end
   else 
   begin
      reused3 <= reused3;
      lst_inv_addr_nrm3 <= lst_inv_addr_nrm3;
      lst_inv_port_nrm3 <= lst_inv_addr_nrm3;
   end
   end


// -----------------------------------------------------------------------------
//   Generate3 signals3 for age3 checker to perform3 in-date3 check
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3) 
   begin
      check_age3 <= 1'b0;  
      last_accessed3 <= 32'd0;
   end
   else if (check_age3)
   begin
      check_age3 <= 1'b0;  
      last_accessed3 <= mem_read_data_add3[81:50];
   end
   else if (add_chk_state3 == age_chk3)
   begin
      check_age3 <= 1'b1;  
      last_accessed3 <= mem_read_data_add3[81:50];
   end
   else 
   begin
      check_age3 <= 1'b0;  
      last_accessed3 <= 32'd0;
   end
   end


`ifdef ABV_ON3

// psl3 default clock3 = (posedge pclk3);

// ASSERTION3 CHECKS3
/* Commented3 out as also checking in toplevel3
// it should never be possible3 for the destination3 port to indicate3 the MAC3
// switch3 address and one of the other 4 Ethernets3
// psl3 assert_valid_dest_port3 : assert never (d_port3[4] & |{d_port3[3:0]});


// COVER3 SANITY3 CHECKS3
// check all values of destination3 port can be returned.
// psl3 cover_d_port_03 : cover { d_port3 == 5'b0_0001 };
// psl3 cover_d_port_13 : cover { d_port3 == 5'b0_0010 };
// psl3 cover_d_port_23 : cover { d_port3 == 5'b0_0100 };
// psl3 cover_d_port_33 : cover { d_port3 == 5'b0_1000 };
// psl3 cover_d_port_43 : cover { d_port3 == 5'b1_0000 };
// psl3 cover_d_port_all3 : cover { d_port3 == 5'b0_1111 };
*/
`endif


endmodule 









