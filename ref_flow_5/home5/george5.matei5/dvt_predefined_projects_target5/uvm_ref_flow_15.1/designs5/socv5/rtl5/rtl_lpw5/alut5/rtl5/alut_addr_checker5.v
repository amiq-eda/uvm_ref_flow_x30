//File5 name   : alut_addr_checker5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
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

// compiler5 directives5
`include "alut_defines5.v"


module alut_addr_checker5
(   
   // Inputs5
   pclk5,
   n_p_reset5,
   command,
   mac_addr5,
   d_addr5,
   s_addr5,
   s_port5,
   curr_time5,
   mem_read_data_add5,
   age_confirmed5,
   age_ok5,
   clear_reused5,

   //outputs5
   d_port5,
   add_check_active5,
   mem_addr_add5,
   mem_write_add5,
   mem_write_data_add5,
   lst_inv_addr_nrm5,
   lst_inv_port_nrm5,
   check_age5,
   last_accessed5,
   reused5
);



   input               pclk5;               // APB5 clock5                           
   input               n_p_reset5;          // Reset5                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr5;           // address of the switch5              
   input [47:0]        d_addr5;             // address of frame5 to be checked5     
   input [47:0]        s_addr5;             // address of frame5 to be stored5      
   input [1:0]         s_port5;             // source5 port of current frame5       
   input [31:0]        curr_time5;          // current time,for storing5 in mem    
   input [82:0]        mem_read_data_add5;  // read data from mem                 
   input               age_confirmed5;      // valid flag5 from age5 checker        
   input               age_ok5;             // result from age5 checker 
   input               clear_reused5;       // read/clear flag5 for reused5 signal5           

   output [4:0]        d_port5;             // calculated5 destination5 port for tx5 
   output              add_check_active5;   // bit 0 of status register           
   output [7:0]        mem_addr_add5;       // hash5 address for R/W5 to memory     
   output              mem_write_add5;      // R/W5 flag5 (write = high5)            
   output [82:0]       mem_write_data_add5; // write data for memory             
   output [47:0]       lst_inv_addr_nrm5;   // last invalidated5 addr normal5 op    
   output [1:0]        lst_inv_port_nrm5;   // last invalidated5 port normal5 op    
   output              check_age5;          // request flag5 for age5 check
   output [31:0]       last_accessed5;      // time field sent5 for age5 check
   output              reused5;             // indicates5 ALUT5 location5 overwritten5

   reg   [2:0]         add_chk_state5;      // current address checker state
   reg   [2:0]         nxt_add_chk_state5;  // current address checker state
   reg   [4:0]         d_port5;             // calculated5 destination5 port for tx5 
   reg   [3:0]         port_mem5;           // bitwise5 conversion5 of 2bit port
   reg   [7:0]         mem_addr_add5;       // hash5 address for R/W5 to memory
   reg                 mem_write_add5;      // R/W5 flag5 (write = high5)            
   reg                 reused5;             // indicates5 ALUT5 location5 overwritten5
   reg   [47:0]        lst_inv_addr_nrm5;   // last invalidated5 addr normal5 op    
   reg   [1:0]         lst_inv_port_nrm5;   // last invalidated5 port normal5 op    
   reg                 check_age5;          // request flag5 for age5 checker
   reg   [31:0]        last_accessed5;      // time field sent5 for age5 check


   wire   [7:0]        s_addr_hash5;        // hash5 of address for storing5
   wire   [7:0]        d_addr_hash5;        // hash5 of address for checking
   wire   [82:0]       mem_write_data_add5; // write data for memory  
   wire                add_check_active5;   // bit 0 of status register           


// Parameters5 for Address Checking5 FSM5 states5
   parameter idle5           = 3'b000;
   parameter mac_addr_chk5   = 3'b001;
   parameter read_dest_add5  = 3'b010;
   parameter valid_chk5      = 3'b011;
   parameter age_chk5        = 3'b100;
   parameter addr_chk5       = 3'b101;
   parameter read_src_add5   = 3'b110;
   parameter write_src5      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash5 conversion5 of source5 and destination5 addresses5
// -----------------------------------------------------------------------------
   assign s_addr_hash5 = s_addr5[7:0] ^ s_addr5[15:8] ^ s_addr5[23:16] ^
                        s_addr5[31:24] ^ s_addr5[39:32] ^ s_addr5[47:40];

   assign d_addr_hash5 = d_addr5[7:0] ^ d_addr5[15:8] ^ d_addr5[23:16] ^
                        d_addr5[31:24] ^ d_addr5[39:32] ^ d_addr5[47:40];



// -----------------------------------------------------------------------------
//   State5 Machine5 For5 handling5 the destination5 address checking process and
//   and storing5 of new source5 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state5 or age_confirmed5 or age_ok5)
   begin
      case (add_chk_state5)
      
      idle5:
         if (command == 2'b01)
            nxt_add_chk_state5 = mac_addr_chk5;
         else
            nxt_add_chk_state5 = idle5;

      mac_addr_chk5:   // check if destination5 address match MAC5 switch5 address
         if (d_addr5 == mac_addr5)
            nxt_add_chk_state5 = idle5;  // return dest5 port as 5'b1_0000
         else
            nxt_add_chk_state5 = read_dest_add5;

      read_dest_add5:       // read data from memory using hash5 of destination5 address
            nxt_add_chk_state5 = valid_chk5;

      valid_chk5:      // check if read data had5 valid bit set
         nxt_add_chk_state5 = age_chk5;

      age_chk5:        // request age5 checker to check if still in date5
         if (age_confirmed5)
            nxt_add_chk_state5 = addr_chk5;
         else
            nxt_add_chk_state5 = age_chk5; 

      addr_chk5:       // perform5 compare between dest5 and read addresses5
            nxt_add_chk_state5 = read_src_add5; // return read port from ALUT5 mem

      read_src_add5:   // read from memory location5 about5 to be overwritten5
            nxt_add_chk_state5 = write_src5; 

      write_src5:      // write new source5 data (addr and port) to memory
            nxt_add_chk_state5 = idle5; 

      default:
            nxt_add_chk_state5 = idle5;
      endcase
   end


// destination5 check FSM5 current state
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      add_chk_state5 <= idle5;
   else
      add_chk_state5 <= nxt_add_chk_state5;
   end



// -----------------------------------------------------------------------------
//   Generate5 returned value of port for sending5 new frame5 to
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      d_port5 <= 5'b0_1111;
   else if ((add_chk_state5 == mac_addr_chk5) & (d_addr5 == mac_addr5))
      d_port5 <= 5'b1_0000;
   else if (((add_chk_state5 == valid_chk5) & ~mem_read_data_add5[82]) |
            ((add_chk_state5 == age_chk5) & ~(age_confirmed5 & age_ok5)) |
            ((add_chk_state5 == addr_chk5) & (d_addr5 != mem_read_data_add5[47:0])))
      d_port5 <= 5'b0_1111 & ~( 1 << s_port5 );
   else if ((add_chk_state5 == addr_chk5) & (d_addr5 == mem_read_data_add5[47:0]))
      d_port5 <= {1'b0, port_mem5} & ~( 1 << s_port5 );
   else
      d_port5 <= d_port5;
   end


// -----------------------------------------------------------------------------
//   convert read port source5 value from 2bits to bitwise5 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      port_mem5 <= 4'b1111;
   else begin
      case (mem_read_data_add5[49:48])
         2'b00: port_mem5 <= 4'b0001;
         2'b01: port_mem5 <= 4'b0010;
         2'b10: port_mem5 <= 4'b0100;
         2'b11: port_mem5 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded5 off5 add_chk_state5
// -----------------------------------------------------------------------------
assign add_check_active5 = (add_chk_state5 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate5 memory addressing5 signals5.
//   The check address command will be taken5 as the indication5 from SW5 that the 
//   source5 fields (address and port) can be written5 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5) 
   begin
       mem_write_add5 <= 1'b0;
       mem_addr_add5  <= 8'd0;
   end
   else if (add_chk_state5 == read_dest_add5)
   begin
       mem_write_add5 <= 1'b0;
       mem_addr_add5  <= d_addr_hash5;
   end
// Need5 to set address two5 cycles5 before check
   else if ( (add_chk_state5 == age_chk5) && age_confirmed5 )
   begin
       mem_write_add5 <= 1'b0;
       mem_addr_add5  <= s_addr_hash5;
   end
   else if (add_chk_state5 == write_src5)
   begin
       mem_write_add5 <= 1'b1;
       mem_addr_add5  <= s_addr_hash5;
   end
   else
   begin
       mem_write_add5 <= 1'b0;
       mem_addr_add5  <= d_addr_hash5;
   end
   end


// -----------------------------------------------------------------------------
//   Generate5 databus5 for writing to memory
//   Data written5 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add5 = {1'b1, curr_time5, s_port5, s_addr5};



// -----------------------------------------------------------------------------
//   Evaluate5 read back data that is about5 to be overwritten5 with new source5 
//   address and port values. Decide5 whether5 the reused5 flag5 must be set and
//   last_inval5 address and port values updated.
//   reused5 needs5 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5) 
   begin
      reused5 <= 1'b0;
      lst_inv_addr_nrm5 <= 48'd0;
      lst_inv_port_nrm5 <= 2'd0;
   end
   else if ((add_chk_state5 == read_src_add5) & mem_read_data_add5[82] &
            (s_addr5 != mem_read_data_add5[47:0]))
   begin
      reused5 <= 1'b1;
      lst_inv_addr_nrm5 <= mem_read_data_add5[47:0];
      lst_inv_port_nrm5 <= mem_read_data_add5[49:48];
   end
   else if (clear_reused5)
   begin
      reused5 <= 1'b0;
      lst_inv_addr_nrm5 <= lst_inv_addr_nrm5;
      lst_inv_port_nrm5 <= lst_inv_addr_nrm5;
   end
   else 
   begin
      reused5 <= reused5;
      lst_inv_addr_nrm5 <= lst_inv_addr_nrm5;
      lst_inv_port_nrm5 <= lst_inv_addr_nrm5;
   end
   end


// -----------------------------------------------------------------------------
//   Generate5 signals5 for age5 checker to perform5 in-date5 check
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5) 
   begin
      check_age5 <= 1'b0;  
      last_accessed5 <= 32'd0;
   end
   else if (check_age5)
   begin
      check_age5 <= 1'b0;  
      last_accessed5 <= mem_read_data_add5[81:50];
   end
   else if (add_chk_state5 == age_chk5)
   begin
      check_age5 <= 1'b1;  
      last_accessed5 <= mem_read_data_add5[81:50];
   end
   else 
   begin
      check_age5 <= 1'b0;  
      last_accessed5 <= 32'd0;
   end
   end


`ifdef ABV_ON5

// psl5 default clock5 = (posedge pclk5);

// ASSERTION5 CHECKS5
/* Commented5 out as also checking in toplevel5
// it should never be possible5 for the destination5 port to indicate5 the MAC5
// switch5 address and one of the other 4 Ethernets5
// psl5 assert_valid_dest_port5 : assert never (d_port5[4] & |{d_port5[3:0]});


// COVER5 SANITY5 CHECKS5
// check all values of destination5 port can be returned.
// psl5 cover_d_port_05 : cover { d_port5 == 5'b0_0001 };
// psl5 cover_d_port_15 : cover { d_port5 == 5'b0_0010 };
// psl5 cover_d_port_25 : cover { d_port5 == 5'b0_0100 };
// psl5 cover_d_port_35 : cover { d_port5 == 5'b0_1000 };
// psl5 cover_d_port_45 : cover { d_port5 == 5'b1_0000 };
// psl5 cover_d_port_all5 : cover { d_port5 == 5'b0_1111 };
*/
`endif


endmodule 









