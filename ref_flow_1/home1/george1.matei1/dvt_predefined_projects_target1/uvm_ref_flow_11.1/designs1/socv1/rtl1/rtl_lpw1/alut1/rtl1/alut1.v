//File1 name   : alut1.v
//Title1       : ALUT1 top level
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
module alut1
(   
   // Inputs1
   pclk1,
   n_p_reset1,
   psel1,            
   penable1,       
   pwrite1,         
   paddr1,           
   pwdata1,          

   // Outputs1
   prdata1  
);

   parameter   DW1 = 83;          // width of data busses1
   parameter   DD1 = 256;         // depth of RAM1


   // APB1 Inputs1
   input             pclk1;               // APB1 clock1                          
   input             n_p_reset1;          // Reset1                              
   input             psel1;               // Module1 select1 signal1               
   input             penable1;            // Enable1 signal1                      
   input             pwrite1;             // Write when HIGH1 and read when LOW1  
   input [6:0]       paddr1;              // Address bus for read write         
   input [31:0]      pwdata1;             // APB1 write bus                      

   output [31:0]     prdata1;             // APB1 read bus                       

   wire              pclk1;               // APB1 clock1                           
   wire [7:0]        mem_addr_add1;       // hash1 address for R/W1 to memory     
   wire              mem_write_add1;      // R/W1 flag1 (write = high1)            
   wire [DW1-1:0]     mem_write_data_add1; // write data for memory             
   wire [7:0]        mem_addr_age1;       // hash1 address for R/W1 to memory     
   wire              mem_write_age1;      // R/W1 flag1 (write = high1)            
   wire [DW1-1:0]     mem_write_data_age1; // write data for memory             
   wire [DW1-1:0]     mem_read_data_add1;  // read data from mem                 
   wire [DW1-1:0]     mem_read_data_age1;  // read data from mem  
   wire [31:0]       curr_time1;          // current time
   wire              active;             // status[0] adress1 checker active
   wire              inval_in_prog1;      // status[1] 
   wire              reused1;             // status[2] ALUT1 location1 overwritten1
   wire [4:0]        d_port1;             // calculated1 destination1 port for tx1
   wire [47:0]       lst_inv_addr_nrm1;   // last invalidated1 addr normal1 op
   wire [1:0]        lst_inv_port_nrm1;   // last invalidated1 port normal1 op
   wire [47:0]       lst_inv_addr_cmd1;   // last invalidated1 addr via cmd1
   wire [1:0]        lst_inv_port_cmd1;   // last invalidated1 port via cmd1
   wire [47:0]       mac_addr1;           // address of the switch1
   wire [47:0]       d_addr1;             // address of frame1 to be checked1
   wire [47:0]       s_addr1;             // address of frame1 to be stored1
   wire [1:0]        s_port1;             // source1 port of current frame1
   wire [31:0]       best_bfr_age1;       // best1 before age1
   wire [7:0]        div_clk1;            // programmed1 clock1 divider1 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata1;             // APB1 read bus
   wire              age_confirmed1;      // valid flag1 from age1 checker        
   wire              age_ok1;             // result from age1 checker 
   wire              clear_reused1;       // read/clear flag1 for reused1 signal1           
   wire              check_age1;          // request flag1 for age1 check
   wire [31:0]       last_accessed1;      // time field sent1 for age1 check




alut_reg_bank1 i_alut_reg_bank1
(   
   // Inputs1
   .pclk1(pclk1),
   .n_p_reset1(n_p_reset1),
   .psel1(psel1),            
   .penable1(penable1),       
   .pwrite1(pwrite1),         
   .paddr1(paddr1),           
   .pwdata1(pwdata1),          
   .curr_time1(curr_time1),
   .add_check_active1(add_check_active1),
   .age_check_active1(age_check_active1),
   .inval_in_prog1(inval_in_prog1),
   .reused1(reused1),
   .d_port1(d_port1),
   .lst_inv_addr_nrm1(lst_inv_addr_nrm1),
   .lst_inv_port_nrm1(lst_inv_port_nrm1),
   .lst_inv_addr_cmd1(lst_inv_addr_cmd1),
   .lst_inv_port_cmd1(lst_inv_port_cmd1),

   // Outputs1
   .mac_addr1(mac_addr1),    
   .d_addr1(d_addr1),   
   .s_addr1(s_addr1),    
   .s_port1(s_port1),    
   .best_bfr_age1(best_bfr_age1),
   .div_clk1(div_clk1),     
   .command(command), 
   .prdata1(prdata1),  
   .clear_reused1(clear_reused1)           
);


alut_addr_checker1 i_alut_addr_checker1
(   
   // Inputs1
   .pclk1(pclk1),
   .n_p_reset1(n_p_reset1),
   .command(command),
   .mac_addr1(mac_addr1),
   .d_addr1(d_addr1),
   .s_addr1(s_addr1),
   .s_port1(s_port1),
   .curr_time1(curr_time1),
   .mem_read_data_add1(mem_read_data_add1),
   .age_confirmed1(age_confirmed1),
   .age_ok1(age_ok1),
   .clear_reused1(clear_reused1),

   //outputs1
   .d_port1(d_port1),
   .add_check_active1(add_check_active1),
   .mem_addr_add1(mem_addr_add1),
   .mem_write_add1(mem_write_add1),
   .mem_write_data_add1(mem_write_data_add1),
   .lst_inv_addr_nrm1(lst_inv_addr_nrm1),
   .lst_inv_port_nrm1(lst_inv_port_nrm1),
   .check_age1(check_age1),
   .last_accessed1(last_accessed1),
   .reused1(reused1)
);


alut_age_checker1 i_alut_age_checker1
(   
   // Inputs1
   .pclk1(pclk1),
   .n_p_reset1(n_p_reset1),
   .command(command),          
   .div_clk1(div_clk1),          
   .mem_read_data_age1(mem_read_data_age1),
   .check_age1(check_age1),        
   .last_accessed1(last_accessed1), 
   .best_bfr_age1(best_bfr_age1),   
   .add_check_active1(add_check_active1),

   // outputs1
   .curr_time1(curr_time1),         
   .mem_addr_age1(mem_addr_age1),      
   .mem_write_age1(mem_write_age1),     
   .mem_write_data_age1(mem_write_data_age1),
   .lst_inv_addr_cmd1(lst_inv_addr_cmd1),  
   .lst_inv_port_cmd1(lst_inv_port_cmd1),  
   .age_confirmed1(age_confirmed1),     
   .age_ok1(age_ok1),
   .inval_in_prog1(inval_in_prog1),            
   .age_check_active1(age_check_active1)
);   


alut_mem1 i_alut_mem1
(   
   // Inputs1
   .pclk1(pclk1),
   .mem_addr_add1(mem_addr_add1),
   .mem_write_add1(mem_write_add1),
   .mem_write_data_add1(mem_write_data_add1),
   .mem_addr_age1(mem_addr_age1),
   .mem_write_age1(mem_write_age1),
   .mem_write_data_age1(mem_write_data_age1),

   .mem_read_data_add1(mem_read_data_add1),  
   .mem_read_data_age1(mem_read_data_age1)
);   



`ifdef ABV_ON1
// psl1 default clock1 = (posedge pclk1);

// ASSUMPTIONS1

// ASSERTION1 CHECKS1
// the invalidate1 aged1 in progress1 flag1 and the active flag1 
// should never both be set.
// psl1 assert_inval_in_prog_active1 : assert never (inval_in_prog1 & active);

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

`endif


endmodule
