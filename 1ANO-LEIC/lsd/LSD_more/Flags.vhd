library ieee; 
 use ieee.std_logic_1164.all; 
 
 entity Flags is  
   port( 
  A, B, R, iCBo: in std_logic;  
  OV, oCBo: out std_logic
  );  
 end Flags;
 
 architecture arq_Flags of Flags is 
 
 begin
 
 oCBo <= iCBo;
 OV <= ((not A) and (not B) and R) or (A and B and (not R));  

 end arq_Flags; 