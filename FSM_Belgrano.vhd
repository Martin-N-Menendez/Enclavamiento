library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity FSM_Belgrano is
	generic( N_CV: natural := 12; N_SM: natural := 11; N_PaN: natural := 3; N_rutas: natural := 11 );
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
	
	type rutas is (RUTA0,RUTA1,RUTA2,RUTA3,RUTA4,RUTA5,RUTA6,RUTA7,RUTA8,RUTA9,RUTA10,RUTA11);
	type rutas_asc is (ASC_0,ASC_1,ASC_2,ASC_3,ASC_4,ASC_5,ASC_10,ASC_11);
	type rutas_des is (DES_0,DES_6,DES_7,DES_8,DES_9,DES_10,DES_11);
	type circuitos_t is (CIRC1,CIRC2,CIRC3,CIRC4,CIRC5,CIRC6,CIRC7,CIRC8,CIRC9,CIRC10,CIRC11,CIRC12);
	type semaforos_t is (SEM_1,SEM_2,SEM_3,SEM_4,SEM_5,SEM_6,SEM_7,SEM_8,SEM_9,SEM_10,SEM_11);
	type SEM_asc_t is (SEM_1,SEM_3,SEM_5,SEM_7,SEM_9,SEM_10);
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
	constant BARRERA_BAJA: std_logic := '0';
	constant BARRERA_ALTA: std_logic := '1';	
	
	signal habilitacion: std_logic_vector(N_rutas downto 0);
	
	signal Semaforos_ASC: std_logic_vector(N_SM/2-1 downto 0);
	signal Semaforos_DES: std_logic_vector(N_SM/2-1 downto 0);
	
	signal PaN_ASC: std_logic_vector(N_PaN-1 downto 0);
	signal PaN_DES: std_logic_vector(N_PaN-1 downto 0);
	signal Maquina_ASC: std_logic := '0';
	signal Maquina_DES: std_logic := '0';
	
begin	
	habilitacion(rutas'pos(RUTA0)) <= '1';
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
						 
	ASIGNAR_RUTAS: process(Clock, Reset)
	begin
		if (Clock ='1' and Clock'Event) then
			if(Reset = '1') then
				Ruta_ascendente <= ASC_0;
				Ruta_descendente <= DES_0;
			end if;
			if (Ruta(ASCENDENTES) = 0 and habilitacion(rutas'pos(RUTA0)) = '1') then
				Ruta_ascendente <= ASC_0;
			end if;
			if (Ruta(DESCENDENTES) = 0 and habilitacion(rutas'pos(RUTA0)) = '1') then
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
	
	ESTADOS_ASC: process (Ruta_ascendente,Clock)
	begin
		if (Clock'event and Clock ='1') then
			case Ruta_ascendente is
				when ASC_0 =>
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
				when ASC_1 => 
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= VERDE;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
					--Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
					--Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;	
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;				
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_ALTA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;
				when ASC_2 => 
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= VERDE;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
					--Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;	
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;				
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;
				when ASC_3 =>
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= VERDE;
					Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;	
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;				
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
				when ASC_4 =>
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= AMARILLO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= VERDE;
					Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;	
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;				
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_ALTA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
				when ASC_5 =>
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= VERDE;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= AMARILLO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= VERDE;	
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;				
					Maquina_ASC <= NORMAL;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_ASC(JURAMENTO) <= BARRERA_ALTA;
				when ASC_10 => 
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= AMARILLO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;	
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= AMARILLO;				
					Maquina_ASC <= REVERSA;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
				when ASC_11 =>
					Semaforos_ASC(SEM_asc_t'pos(SEM_1)) <= AMARILLO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_3)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_5)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_7)) <= ROJO;
					Semaforos_ASC(SEM_asc_t'pos(SEM_9)) <= ROJO;	
					Semaforos_ASC(SEM_asc_t'pos(SEM_10)) <= ROJO;				
					Maquina_ASC <= REVERSA;
					PaN_ASC(PAMPA) <= BARRERA_BAJA;
					PaN_ASC(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_ASC(JURAMENTO) <= BARRERA_BAJA;
			end case;
		end if;		
	end process ESTADOS_ASC;
	
	ESTADOS_DES: process (Ruta_descendente,Clock)
	begin
		if (Clock'event and Clock ='1') then
			case Ruta_descendente is
				when DES_0 =>
					Semaforos_DES(sem_des_t'pos(SEM_2)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_4)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_6)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_8)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
				when DES_6 => 
					Semaforos_DES(sem_des_t'pos(SEM_2)) <= VERDE;
					Semaforos_DES(sem_des_t'pos(SEM_4)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_6)) <= ROJO;
					--Semaforos_DES(sem_des_t'pos(SEM_8)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_ALTA;
					PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
				when DES_7 => 
					Semaforos_DES(sem_des_t'pos(SEM_2)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_4)) <= VERDE;
					Semaforos_DES(sem_des_t'pos(SEM_6)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_8)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
				when DES_8 =>
					Semaforos_DES(sem_des_t'pos(SEM_2)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_4)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_6)) <= VERDE;
					Semaforos_DES(sem_des_t'pos(SEM_8)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_ALTA;
				when DES_9 =>
					Semaforos_DES(sem_des_t'pos(SEM_2)) <= AMARILLO;
					Semaforos_DES(sem_des_t'pos(SEM_4)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_6)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_8)) <= VERDE;
					Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
					Maquina_DES <= NORMAL;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_ALTA;
					PaN_DES(JURAMENTO) <= BARRERA_ALTA;
				when DES_10 => 
					Semaforos_DES(sem_des_t'pos(SEM_2)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_4)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_6)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_8)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
					Maquina_DES <= REVERSA;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
				when DES_11 =>
					Semaforos_DES(sem_des_t'pos(SEM_2)) <= AMARILLO;
					Semaforos_DES(sem_des_t'pos(SEM_4)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_6)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_8)) <= ROJO;
					Semaforos_DES(sem_des_t'pos(SEM_11)) <= ROJO;
					Maquina_DES <= REVERSA;
					PaN_DES(PAMPA) <= BARRERA_BAJA;
					PaN_DES(ECHEVERRIA) <= BARRERA_BAJA;
					PaN_DES(JURAMENTO) <= BARRERA_BAJA;
			end case;
		end if;		
	end process ESTADOS_DES;
	
	SEMAFORO_ASIGNADOR: process(Clock, Reset)
	begin
		if (Clock ='1' and Clock'Event and Reset='1') then
			Semaforos <= "00000000000";
		elsif (Clock'event and Clock='1') then
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
		end if;
	end process SEMAFORO_ASIGNADOR;
	
	BARRERAS: process(Clock, Reset)
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
	
	MAQUINAS: process(Clock, Reset)
	begin
		if (Clock ='1' and Clock'Event and Reset='1') then
			Maquina <= NORMAL;
		elsif (Clock'event and Clock='1') then
			Maquina <= Maquina_ASC and Maquina_DES;
		end if;
	end process MAQUINAS;
	
end architecture;