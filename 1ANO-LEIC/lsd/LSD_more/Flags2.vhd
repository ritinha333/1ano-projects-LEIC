library ieee; 
 use ieee.std_logic_1164.all; 
 
 entity Flags2 is  
 port(iOV, iCB, OP2, Cy: in std_logic;
		R: in std_logic_vector (3 DOWNTO 0);
		BE, oGE, Z, oOV, oCB: out std_logic);
 end Flags2;
 
 architecture arq_Flags2 of Flags2 is 
 
begin
 
Z <= ((not R(3)) and (not R(2)) and (not R(1)) and (not R(0)));
oOV <= iOV;
BE <= ((not R(3)) and (not R(2)) and (not R(1)) and (not R(0))) or iCB;
oGE <= (not iOV and not R(3)) or (iOV and R(3));
oCB <= ((not OP2 and Cy) or (OP2 and iCB));

 end arq_Flags2; 