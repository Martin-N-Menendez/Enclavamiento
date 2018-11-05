library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity FSM_Belgrano is
	generic( N_CV: natural := 12; N_SM: natural := 11; N_PaN: natural := 3; 
N_rutas: natural := 13 );
	port(
		Clock,Reset: in std_logic;
		Ruta: in ruta_array;
		Modo: in std_logic;
		Circuito_Via: in std_logic_vector(N_CV-1 downto 0);	
		Semaforos_in: in std_logic_vector(N_SM-1 downto 0);
		Maquina_N: in std_logic;
		Maquina_R: in std_logic;
		PaN_Bajo: in std_logic_vector(N_PaN-1 downto 0);
		PaN_Alto: in std_logic_vector(N_PaN-1 downto 0);
		--Semaforos: out SEMAFORO;
		Semaforos: out std_logic_vector(N_SM-1 downto 0);
		Maquina: out std_logic;
		PaN: out std_logic_vector(N_PaN-1 downto 0)
	);
end FSM_Belgrano;

architecture FSM_Belgrano_arq of FSM_Belgrano is
	
	type rutas is (RUTA_RESET,RUTA1,RUTA2,RUTA3,RUTA4,RUTA5,RUTA6,RUTA7,RUTA8,RUTA9,RUTA10,RUTA11,RUTA_0ASC,RUTA_0DES);
	type rutas_asc is (ASC_0,ASC_1,ASC_2,ASC_3,ASC_4,ASC_5,ASC_10,ASC_11,ASC_RESET);
	type rutas_des is (DES_0,DES_6,DES_7,DES_8,DES_9,DES_10,DES_11,DES_RESET);
	type circuitos_t is (CIRC1,CIRC2,CIRC3,CIRC4,CIRC5,CIRC6,CIRC7,CIRC8,CIRC9,CIRC10,CIRC11,CIRC12);
	type semaforos_t is (SEM_1,SEM_2,SEM_3,SEM_4,SEM_5,SEM_6,SEM_7,SEM_8,SEM_9,SEM_10,SEM_11);
	type sem_asc_t is (SEM_1,SEM_3,SEM_5,SEM_7,SEM_9,SEM_10);
	type sem_des_t is (SEM_2,SEM_4,SEM_6,SEM_8,SEM_11);
	
	signal Ruta_ascendente: rutas_asc := ASC_0;
	signal Ruta_descendente: rutas_des := DES_0;
	
	constant SEMIAUTOMATICO: std_logic := '0';
	constant AUTOMATICO: std_logic := '1';
	
	constant ASCENDENTES: integer:= 0;
	constant DESCENDENTES: integer := 1;
	
	constant PAMPA: integer:= 0;
	constant ECHEVERRIA: integer := 1;
	constant JURAMENTO: integer := 2;
	
	constant OCUPADO: std_logic := '0';
	constant LIBRE: std_logic := '1';
	--constant ROJO: SM_ESTADO := "00";		--  0
	--constant AMARILLO: SM_ESTADO := "01";	-- +1
	--constant VERDE: SM_ESTADO := "11";		-- -1
	constant ROJO: std_logic := '0';		--  0
	constant AMARILLO: std_logic := '1';	-- +1
	constant VERDE: std_logic := '1';		-- -1
	constant NORMAL: std_logic := '0';
	constant REVERSA: std_logic := '1';
	
	constant S_NORMAL: std_logic := '0';
	constant S_NO_NORMAL: std_logic := '1';
	
	constant S_REVERSA: std_logic := '0';
	constant S_NO_REVERSA: std_logic := '1';
	
	constant S_BAJO: std_logic := '0';
	constant S_NO_BAJO: std_logic := '1';
	
	constant S_ALTO: std_logic := '0';
	constant S_NO_ALTO: std_logic := '1';
	
	constant BARRERA_BAJA: std_logic := '0';
	constant BARRERA_ALTA: std_logic := '1';	
	
	signal habilitacion: std_logic_vector(N_rutas downto 0);
	
	signal semaforo_auto_CV_1: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_2: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_3: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_4: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_5: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_6: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_7: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_8: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_9: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_10: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_11: std_logic_vector(N_SM-1 downto 0);
	signal semaforo_auto_CV_12: std_logic_vector(N_SM-1 downto 0);
	
	signal Semaforos_ASC: std_logic_vector(7-1 downto 0);
	signal Semaforos_DES: std_logic_vector(6-1 downto 0);
	
	signal PaN_ASC: std_logic_vector(N_PaN-1 downto 0);
	signal PaN_DES: std_logic_vector(N_PaN-1 downto 0);
	signal Maquina_ASC: std_logic := '0';
	signal Maquina_DES: std_logic := '0';
	
begin	
	habilitacion(rutas'pos(RUTA_RESET)) <= '1';
	habilitacion(rutas'pos(RUTA1)) <= '1' when 
						 Circuito_Via(circuitos_t'pos(CIRC1)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA2)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC1)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA3)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC1)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE  else '0';
	habilitacion(rutas'pos(RUTA4)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA5)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA6)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = OCUPADO else '0';
	habilitacion(rutas'pos(RUTA7)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA8)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA9)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA10)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA11)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA_0ASC)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC1)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA_0DES)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
						 
	ASIGNAR_RUTAS: process(Clock)
	begin
		if (Clock ='1' and Clock'Event and Modo = SEMIAUTOMATICO) then
			-- if(Reset = '1') then
				-- Ruta_ascendente <= ASC_RESET;
				-- Ruta_descendente <= DES_RESET;
			-- end if;
			if (Ruta(ASCENDENTES) = 0 and habilitacion(rutas'pos(RUTA_0ASC)) = '1') then
				Ruta_ascendente <= ASC_0;
			end if;
			if (Ruta(DESCENDENTES) = 0 and habilitacion(rutas'pos(RUTA_0DES)) = '1') then
				Ruta_descendente <= DES_0;
			end if;
			if (Ruta(ASCENDENTES) = 1 and habilitacion(rutas'pos(RUTA1)) = '1') then
				Ruta_ascendente <= ASC_1;
			end if;
			if (Ruta(ASCENDENTES) = 2 and habilitacion(rutas'pos(RUTA2)) = '1') then
				Ruta_ascendente <= ASC_2;
			end if;
			if (Ruta(ASCENDENTES) = 3 and habilitacion(rutas'pos(RUTA3)) = '1') then
				Ruta_ascendente <= ASC_3;
			end if;
			if (Ruta(ASCENDENTES) = 4 and habilitacion(rutas'pos(RUTA4)) = '1') then
				Ruta_ascendente <= ASC_4;
			end if;
			if (Ruta(ASCENDENTES) = 5 and habilitacion(rutas'pos(RUTA5)) = '1') then
				Ruta_ascendente <= ASC_5;
			end if;
			if (Ruta(DESCENDENTES) = 6 and habilitacion(rutas'pos(RUTA6)) = '1') then
				Ruta_descendente <= DES_6;
			end if;
			if (Ruta(DESCENDENTES) = 7 and habilitacion(rutas'pos(RUTA7)) = '1') then
				Ruta_descendente <= DES_7;
			end if;
			if (Ruta(DESCENDENTES) = 8 and habilitacion(rutas'pos(RUTA8)) = '1') then
				Ruta_descendente <= DES_8;
			end if;
			if (Ruta(DESCENDENTES) = 9 and habilitacion(rutas'pos(RUTA9)) = '1') then
				Ruta_descendente <= DES_9;
			end if;
			if ((Ruta(ASCENDENTES) = 10 or Ruta(DESCENDENTES) = 10) and habilitacion(rutas'pos(RUTA10)) = '1') then
				Ruta_ascendente <= ASC_10;
				Ruta_descendente <= DES_10;
			end if;
			if ((Ruta(ASCENDENTES) = 11 or Ruta(DESCENDENTES) = 11) and habilitacion(rutas'pos(RUTA11)) = '1') then
				Ruta_ascendente <= ASC_11;
				Ruta_descendente <= DES_11;
			end if;
		end if;
	end process ASIGNAR_RUTAS;	
	
	SEMI_ASC: process (Ruta_ascendente,Clock)
	begin
		if (Clock'event and Clock ='1' and Modo = SEMIAUTOMATICO) then
			case Ruta_ascendente is
				when ASC_RESET =>
					-- Manejo de sistemas
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_ALTA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;				
					-- comprobar maquina
					--if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						--if(Barreras in = Barreras)
							--if(SEMAFOROS_IN !=) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= ROJO;
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
								Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							--end if;
						--end if;								
					--end if;							
				when ASC_0 =>
					-- Manejo de sistemas
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_ALTA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;			
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) >= S_BAJO and PaN_Alto(PAMPA) <= S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) >= S_BAJO and PaN_Alto(ECHEVERRIA) <= S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_7)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_9)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							end if;
						end if;								
					end if;				
					
				when ASC_1 => 
					-- Manejo de sistemas
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_ALTA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;		
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) >= S_BAJO and PaN_Alto(PAMPA) <= S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) >= S_BAJO and PaN_Alto(ECHEVERRIA) <= S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= VERDE ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
							end if;
							--if( Semaforos_in(semaforos_t'pos(SEM_7)) /= ROJO ) then -- dont care
							--	Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
							--end if;
							--if( Semaforos_in(semaforos_t'pos(SEM_9)) /= ROJO ) then -- dont care
							--	Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
							--end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							end if;
						end if;								
					end if;
					
				when ASC_2 => 
					-- Manejo de sistemas
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;	
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= VERDE ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_7)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
							end if;
							--if( Semaforos_in(semaforos_t'pos(SEM_9)) /= ROJO ) then -- dont care
							--	Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO; 		
							--end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							end if;
						end if;								
					end if;						
					
				when ASC_3 =>
					-- Manejo de sistemas
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= VERDE ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_7)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_9)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							end if;
						end if;								
					end if;						
					
				when ASC_4 =>
					-- Manejo de sistemas
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_ALTA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) >= S_BAJO and PaN_Alto(PAMPA) <= S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= AMARILLO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= AMARILLO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_7)) /= VERDE ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_9)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							end if;
						end if;								
					end if;
					
				when ASC_5 =>
					-- Manejo de sistemas
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) >= S_BAJO and PaN_Alto(ECHEVERRIA) <= S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= VERDE ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= AMARILLO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= AMARILLO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_7)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_9)) /= VERDE ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							end if;
						end if;								
					end if;
					
				when ASC_10 => 
					-- Manejo de sistemas
					Maquina_ASC <= REVERSA;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
					-- comprobar maquina
					if (Maquina_N = S_NO_NORMAL and Maquina_R = S_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= AMARILLO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= AMARILLO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_7)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_9)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= AMARILLO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= AMARILLO;
							end if;
						end if;								
					end if;							
					
				when ASC_11 =>
					-- Manejo de sistemas
					Maquina_ASC <= REVERSA;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
					-- comprobar maquina
					if (Maquina_N = S_NO_NORMAL and Maquina_R = S_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_1)) /= AMARILLO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= AMARILLO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_3)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_5)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_7)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_9)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_10)) /= ROJO ) then
								Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
							end if;
						end if;								
					end if;										
			end case;
		end if;		
	end process SEMI_ASC;
	
	SEMI_DES: process (Ruta_descendente,Clock)
	begin
		if (Clock'event and Clock ='1' and Modo = SEMIAUTOMATICO) then
			case Ruta_descendente is
				when DES_RESET =>
					-- Manejo de sistemas
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_ALTA;
					PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_DES(JURAMENTO) <= BARRERA_ALTA;
					-- comprobar maquina
					--if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) >= S_BAJO and PaN_Alto(PAMPA) <= S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) >= S_BAJO and PaN_Alto(ECHEVERRIA) <= S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then
							--if(SEMAFOROS_IN !=) then					
								Semaforos_DES(sem_des_t'pos(SEM_2)) <= ROJO;
								Semaforos_DES(sem_des_t'pos(SEM_4)) <= ROJO;
								Semaforos_DES(sem_des_t'pos(SEM_6)) <= ROJO;
								Semaforos_DES(sem_des_t'pos(SEM_8)) <= ROJO;
								Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
							--end if;
						end if;								
					--end if;			
					
				when DES_0 =>
					-- Manejo de sistemas
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_ALTA;
					PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_DES(JURAMENTO) <= BARRERA_ALTA;	
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) >= S_BAJO and PaN_Alto(PAMPA) <= S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) >= S_BAJO and PaN_Alto(ECHEVERRIA) <= S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then					
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_2)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_2)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_4)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_4)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_6)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_6)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_8)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_8)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_11)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_11)) <= ROJO;
							end if;
						end if;								
					end if;
							
				when DES_6 => 
					-- Manejo de sistemas
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_ALTA;
					PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) >= S_BAJO and PaN_Alto(PAMPA) <= S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) >= S_BAJO and PaN_Alto(ECHEVERRIA) <= S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_2)) /= VERDE ) then
								Semaforos_DES(SEM_des_t'pos(SEM_2)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_4)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_4)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_6)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_6)) <= ROJO;
							end if;
							--if( Semaforos_in(semaforos_t'pos(SEM_8)) /= ROJO ) then -- dont care
							--	Semaforos_DES(SEM_des_t'pos(SEM_8)) <= ROJO;
							--end if;
							if( Semaforos_in(semaforos_t'pos(SEM_11)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_11)) <= ROJO;
							end if;
						end if;								
					end if;
										
				when DES_7 => 
					-- Manejo de sistemas
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;	
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_2)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_2)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_4)) /= VERDE ) then
								Semaforos_DES(SEM_des_t'pos(SEM_4)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_6)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_6)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_8)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_8)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_11)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_11)) <= ROJO;
							end if;
						end if;								
					end if;
												
				when DES_8 =>
					-- Manejo de sistemas
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_ALTA;
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_2)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_2)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_4)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_4)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_6)) /= VERDE ) then
								Semaforos_DES(SEM_des_t'pos(SEM_6)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_8)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_8)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_11)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_11)) <= ROJO;
							end if;
						end if;								
					end if;
	
				when DES_9 =>
					-- Manejo de sistemas
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_DES(JURAMENTO) <= BARRERA_ALTA;
					-- comprobar maquina
					if (Maquina_N = NORMAL and Maquina_R = S_NO_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) >= S_BAJO and PaN_Alto(ECHEVERRIA) <= S_NO_ALTO and
							PaN_Bajo(JURAMENTO) >= S_BAJO and PaN_Alto(JURAMENTO) <= S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_2)) /= AMARILLO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_2)) <= AMARILLO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_4)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_4)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_6)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_6)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_8)) /= VERDE ) then
								Semaforos_DES(SEM_des_t'pos(SEM_8)) <= VERDE;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_11)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_11)) <= ROJO;
							end if;
						end if;								
					end if;
					
				when DES_10 => 
					-- Manejo de sistemas
					Maquina_DES <= REVERSA;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
					-- comprobar maquina
					if (Maquina_N = S_NO_NORMAL and Maquina_R = S_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_2)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_2)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_4)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_4)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_6)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_6)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_8)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_8)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_11)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_11)) <= ROJO;
							end if;
						end if;								
					end if;
	
				when DES_11 =>
					-- Manejo de sistemas
					Maquina_DES <= REVERSA;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
					-- comprobar maquina
					if (Maquina_N = S_NO_NORMAL and Maquina_R = S_REVERSA) then
						-- Controlar barreras
						if( PaN_Bajo(PAMPA) = S_BAJO and PaN_Alto(PAMPA) = S_NO_ALTO and
							PaN_Bajo(ECHEVERRIA) = S_BAJO and PaN_Alto(ECHEVERRIA) = S_NO_ALTO and
							PaN_Bajo(JURAMENTO) = S_BAJO and PaN_Alto(JURAMENTO) = S_NO_ALTO) then
							-- Control de semaforos
							if( Semaforos_in(semaforos_t'pos(SEM_2)) /= AMARILLO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_2)) <= AMARILLO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_4)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_4)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_6)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_6)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_8)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_8)) <= ROJO;
							end if;
							if( Semaforos_in(semaforos_t'pos(SEM_11)) /= ROJO ) then
								Semaforos_DES(SEM_des_t'pos(SEM_11)) <= ROJO;
							end if;
						end if;								
					end if;					
			end case;
		end if;		
	end process SEMI_DES;
	
	AUTOMATICO_ASC: process (Clock)
	begin
		if (Clock'event and Clock ='1' and Modo = AUTOMATICO) then
			if (Circuito_Via(circuitos_t'pos(CIRC1)) = OCUPADO) then
				semaforo_auto_CV_1(semaforos_t'pos(SEM_1)) <= ROJO;
				PaN_ASC(PAMPA) <= BARRERA_BAJA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC1)) = LIBRE) then
				semaforo_auto_CV_1 <= "11111111111";
			end if;
						
			if (Circuito_Via(circuitos_t'pos(CIRC3)) = OCUPADO) then
				semaforo_auto_CV_3(semaforos_t'pos(SEM_1)) <= ROJO;
				semaforo_auto_CV_3(semaforos_t'pos(SEM_3)) <= ROJO;
				PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE) then
				semaforo_auto_CV_3 <= "11111111111";
			end if;
						
			if (Circuito_Via(circuitos_t'pos(CIRC5)) = OCUPADO) then
				semaforo_auto_CV_5(semaforos_t'pos(SEM_1)) <= ROJO;
				semaforo_auto_CV_5(semaforos_t'pos(SEM_3)) <= ROJO;
				PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE) then
				semaforo_auto_CV_5 <= "11111111111";
			end if;
						
			if (Circuito_Via(circuitos_t'pos(CIRC7)) = OCUPADO) then
				semaforo_auto_CV_7(semaforos_t'pos(SEM_1)) <= AMARILLO;
				semaforo_auto_CV_7(semaforos_t'pos(SEM_3)) <= ROJO;
				semaforo_auto_CV_7(semaforos_t'pos(SEM_5)) <= ROJO;
				PaN_ASC(PAMPA) <= BARRERA_ALTA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE) then
				semaforo_auto_CV_7 <= "11111111111";
			end if;
					
			if (Circuito_Via(circuitos_t'pos(CIRC9)) = OCUPADO) then
				semaforo_auto_CV_9(semaforos_t'pos(SEM_3)) <= AMARILLO;
				semaforo_auto_CV_9(semaforos_t'pos(SEM_5)) <= ROJO;
				semaforo_auto_CV_9(semaforos_t'pos(SEM_7)) <= ROJO;
				PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE) then
				semaforo_auto_CV_9 <= "11111111111";
			end if;
			
			if (Circuito_Via(circuitos_t'pos(CIRC11)) = OCUPADO) then
				semaforo_auto_CV_11(semaforos_t'pos(SEM_5)) <= AMARILLO;
				semaforo_auto_CV_11(semaforos_t'pos(SEM_7)) <= ROJO;
				semaforo_auto_CV_11(semaforos_t'pos(SEM_9)) <= ROJO;
				PaN_ASC(JURAMENTO) <= BARRERA_ALTA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE) then
				semaforo_auto_CV_11 <= "11111111111";
			end if;
			
			-- if ( Circuito_Via(circuitos_t'pos(CIRC1)) = LIBRE and
				 -- Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and
				 -- Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and
				 -- Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and
				 -- Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and
				 -- Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE) then
				-- PaN_ASC(PAMPA) <= BARRERA_ALTA;
				-- PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
				-- PaN_ASC(JURAMENTO) <= BARRERA_ALTA;
			-- end if;
						
		end if;		
	end process AUTOMATICO_ASC;
	
	AUTOMATICO_DES: process (Clock)
	begin
		if (Clock'event and Clock ='1' and Modo = AUTOMATICO) then
			
			if ( Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and
				 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and
				 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and
				 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and
				 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and
				 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE) then
				PaN_DES(PAMPA) <= BARRERA_ALTA;
				PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
				PaN_DES(JURAMENTO) <= BARRERA_ALTA;
			end if;
			
			if (Circuito_Via(circuitos_t'pos(CIRC12)) = OCUPADO) then
				--semaforo_auto_CV_12(semaforos_t'pos(SEM_3)) <= ROJO;
				PaN_DES(JURAMENTO) <= BARRERA_BAJA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE) then
				semaforo_auto_CV_12 <= "11111111111";
			end if;	
			
			if (Circuito_Via(circuitos_t'pos(CIRC10)) = OCUPADO) then
				semaforo_auto_CV_10(semaforos_t'pos(SEM_2)) <= ROJO;
				PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE) then
				semaforo_auto_CV_10 <= "11111111111";
			end if;
			
			if (Circuito_Via(circuitos_t'pos(CIRC8)) = OCUPADO) then
				semaforo_auto_CV_8(semaforos_t'pos(SEM_2)) <= ROJO;
				semaforo_auto_CV_8(semaforos_t'pos(SEM_4)) <= ROJO;
				PaN_DES(PAMPA) <= BARRERA_BAJA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE) then
				semaforo_auto_CV_8 <= "11111111111";
			end if;
			
			if (Circuito_Via(circuitos_t'pos(CIRC6)) = OCUPADO) then
				semaforo_auto_CV_6(semaforos_t'pos(SEM_2)) <= ROJO;
				semaforo_auto_CV_6(semaforos_t'pos(SEM_4)) <= ROJO;
				PaN_DES(JURAMENTO) <= BARRERA_ALTA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE) then
				semaforo_auto_CV_6 <= "11111111111";
			end if;
			
			if (Circuito_Via(circuitos_t'pos(CIRC4)) = OCUPADO) then
				semaforo_auto_CV_4(semaforos_t'pos(SEM_2)) <= AMARILLO;
				semaforo_auto_CV_4(semaforos_t'pos(SEM_4)) <= ROJO;	
				semaforo_auto_CV_4(semaforos_t'pos(SEM_6)) <= ROJO;
				PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE) then
				semaforo_auto_CV_4 <= "11111111111";
			end if;
			
			if (Circuito_Via(circuitos_t'pos(CIRC2)) = OCUPADO) then
				semaforo_auto_CV_2(semaforos_t'pos(SEM_4)) <= AMARILLO;
				semaforo_auto_CV_2(semaforos_t'pos(SEM_6)) <= ROJO;
				semaforo_auto_CV_2(semaforos_t'pos(SEM_8)) <= ROJO;
				PaN_DES(PAMPA) <= BARRERA_ALTA;
			elsif (Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE) then
				semaforo_auto_CV_2 <= "11111111111";
			end if;	
			
		end if;		
	end process AUTOMATICO_DES;
	
	SEMAFORO_ASIGNADOR: process(Clock)
	begin
		if (Clock ='1' and Clock'Event) then
			if (Reset = '1') then
				Semaforos <= "00000000000";
			else
				if(Modo = SEMIAUTOMATICO) then			
					Semaforos(semaforos_t'pos(SEM_1)) <= Semaforos_ASC(SEM_asc_t'pos(SEM_1));
					Semaforos(semaforos_t'pos(SEM_2)) <= Semaforos_DES(sem_des_t'pos(SEM_2));
					Semaforos(semaforos_t'pos(SEM_3)) <= Semaforos_ASC(SEM_asc_t'pos(SEM_3));
					Semaforos(semaforos_t'pos(SEM_4)) <= Semaforos_DES(sem_des_t'pos(SEM_4));
					Semaforos(semaforos_t'pos(SEM_5)) <= Semaforos_ASC(SEM_asc_t'pos(SEM_5));
					Semaforos(semaforos_t'pos(SEM_6)) <= Semaforos_DES(sem_des_t'pos(SEM_6));
					Semaforos(semaforos_t'pos(SEM_7)) <= Semaforos_ASC(SEM_asc_t'pos(SEM_7));
					Semaforos(semaforos_t'pos(SEM_8)) <= Semaforos_DES(sem_des_t'pos(SEM_8));
					Semaforos(semaforos_t'pos(SEM_9)) <= Semaforos_ASC(SEM_asc_t'pos(SEM_9));
					Semaforos(semaforos_t'pos(SEM_10)) <= Semaforos_ASC(SEM_asc_t'pos(SEM_10));
					Semaforos(semaforos_t'pos(SEM_11)) <= Semaforos_DES(sem_des_t'pos(SEM_11));
				elsif (Modo = AUTOMATICO) then
					--Semaforos <= "10010010011";
					Semaforos <= semaforo_auto_CV_1 and semaforo_auto_CV_2 and semaforo_auto_CV_3 and
								 semaforo_auto_CV_4 and semaforo_auto_CV_5 and semaforo_auto_CV_6 and
								 semaforo_auto_CV_7 and semaforo_auto_CV_8 and semaforo_auto_CV_9 and
								 semaforo_auto_CV_10 and semaforo_auto_CV_11 and semaforo_auto_CV_12;			
				end if;
			end if;
		end if;
	end process SEMAFORO_ASIGNADOR;
	
	BARRERAS: process(Clock)
	begin
		if (Clock ='1' and Clock'Event) then
			if (Reset = '1') then
				PaN(PAMPA) <= BARRERA_BAJA;
				PaN(ECHEVERRIA) <= BARRERA_BAJA;
				PaN(JURAMENTO) <= BARRERA_BAJA;
			else
				PaN(PAMPA) <= PaN_ASC(PAMPA) and PaN_DES(PAMPA);
				PaN(ECHEVERRIA) <= PaN_ASC(ECHEVERRIA) and PaN_DES(ECHEVERRIA);
				PaN(JURAMENTO) <= PaN_ASC(JURAMENTO) and PaN_DES(JURAMENTO);		
			end if;
		end if;
	end process BARRERAS;
	
	MAQUINAS: process(Clock)
	begin
		if (Clock ='1' and Clock'Event) then
			if (Reset = '1') then
				Maquina <= NORMAL;
			else	
				Maquina <= Maquina_ASC and Maquina_DES;
			end if;
		end if;
	end process MAQUINAS;
	
	-- MODOS: process(Clock, Reset)
	-- begin
		-- if (Clock ='1' and Clock'Event and Reset='1') then
			-- Modo <= SEMIAUTOMATICO;
		-- elsif (Clock'event and Clock='1') then
			-- if (Modo = AUTOMATICO and habilitacion(rutas'pos(RUTA_0ASC)) = '1' habilitacion(rutas'pos(RUTA_0DES)) = '1') then
				-- Modo = Modo;
			-- end if;
		-- end if;
	-- end process MODOS;
	
end architecture;