----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Control
-- Descripción: 	Máquina de estados para el control de los módulos
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
	port (	clk, rst, inicia, per_listo: in std_logic;
				IND,men_1,men_2,rst_int,Guarda,Motor_listo: out std_logic
			);
end Control;

architecture Arq of Control is

type estados is(INICIO, PWM, REC_RPM, MEMORIA, TRAN);

signal edo_presente,edo_futuro: estados;
signal cnt1: std_logic_vector(27 downto 0); 
signal cnt2: std_logic_vector(3 downto 0); 
signal cnt3:std_logic_vector(5 downto 0);
signal cnt4: std_logic_vector(31 downto 0);

begin


process(clk, rst, edo_presente, edo_futuro, inicia, Per_Listo, cnt1, cnt2, cnt3, cnt4)
begin
	
	if rst='1' then
		edo_futuro <= INICIO;
		cnt1<=(others=>'0');
		cnt2<=(others=>'0');
		cnt3<=(others=>'0');
		cnt4<=(others=>'0');
	elsif clk'event and clk = '1' then
		edo_presente <= edo_futuro;	
		case edo_presente is
			when INICIO  =>	IND<='0'; Motor_Listo<='0'; men_1<='0'; men_2<='0'; rst_int<='0'; Guarda <='0';cnt4<=(others=>'0'); 
										if inicia='0' then
											edo_futuro <= INICIO;
										else
											edo_futuro <= PWM;
											IND<='1';
										end if;
			
			when PWM		 =>	men_1<='1'; cnt2<=(others=>'0'); IND<='0';

										if cnt1 <= x"BEBC200" then -- cnt1 <= 4seg  
											cnt1 <= cnt1+1;
											edo_futuro <= PWM;
										else 
											edo_futuro <= REC_RPM;
											Motor_Listo <= '1';
										end if;
										
			when REC_RPM =>	men_1<='1'; Motor_Listo<='0'; cnt1<=(others => '0');
										if Per_Listo='0' then
											edo_futuro <= REC_RPM;
										elsif Per_Listo='1' then
											if cnt3 <= "100111" then  -- cnt3 <= 39 
												cnt3 <= cnt3+1;
											   edo_futuro <= MEMORIA;
												Guarda <= '1';
											else
												edo_futuro <= TRAN;
												rst_int <= '1';
											end if;
										end if;
										
			when MEMORIA =>	men_1<='1'; Guarda<='0';
										if cnt2 <= "1010" then -- cnt2 <= 10 
											cnt2 <= cnt2+1;
											edo_futuro <= MEMORIA;
										else
											edo_futuro <= PWM;
											IND<='1';
										end if;
										
			when TRAN	 =>	men_2<='1'; rst_int<='0'; cnt3<=(others => '0');
										if cnt4 <= x"1DCD6500" then --cnt4 <= 10seg 
											cnt4 <= cnt4+1;
											edo_futuro <= TRAN;
										else
											edo_futuro <= INICIO;
										end if;
	end case;
	end if;
end process;


end Arq;