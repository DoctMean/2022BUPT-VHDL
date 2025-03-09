library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity countAndSetting is
    port (
        clk : in std_logic;                        -- ʱ���ź�
        reset : in std_logic;                      -- ��λ�ź�
        set : in std_logic;                        -- �����źţ����ڿ����Ƿ��������״̬
        input : in unsigned(11 downto 0);-- ��ʱ���������ڴ洢���������ֵ��9λ��
		print_light_one : out unsigned(6 downto 0);
		show_switch : in unsigned(1 downto 0);
		show : out unsigned(7 downto 0); 
		pause : in std_logic				
    );
end entity countAndSetting;

architecture Behavioral of countAndSetting is
    signal pills_need : unsigned(11 downto 0);  -- ���������ֵ����������ÿƿ��Ҫװ��ҩƬ��������
    signal bottom_need : unsigned(11 downto 0);
    signal pills_count_8421 : unsigned(11 downto 0);  -- �����������ڼ�¼��װ���ҩƬ����8421��
    signal bottom_count_8421:unsigned(11 downto 0);
    signal all_pills_count_8421 : unsigned(11 downto 0);  -- ��װ����ҩƿ����8421��
	signal error : std_logic;
	signal show_temp : unsigned(11 downto 0);
	signal stop : std_logic;
begin
    process(clk)
    begin
        if reset = '1' then
            pills_count_8421 <= (others => '0');  -- ���������
            pills_need <= (others => '0');  -- ��λ pills_need
            all_pills_count_8421 <= (others => '0'); -- ������װ����ҩƿ��
            bottom_need<=(others =>'0');
            error <= '0';
            stop <= '1';
        elsif set = '1' then
                -- ����Ƿ����������������ź������س���
			if input = "000000000000"then
				error<='1';
			end if;
			case show_switch is
				when "00" =>
					pills_need <=input;
				when "01" =>
					bottom_need <=input;
				when others =>
					null;
			end case;
		elsif pause = '1' then
			stop<=not stop;
		elsif rising_edge(clk) and pills_need /= "000000000000" and stop='0' then
			-- �������������״̬������������źž����Ƿ�װҩƬ
			if all_pills_count_8421(3 downto 0) = "1001"then
				if all_pills_count_8421(7 downto 0) = "10011001"then
					all_pills_count_8421 <= all_pills_count_8421 + "01100111";
				else
					all_pills_count_8421 <= all_pills_count_8421 + "0111";
				end if;
			else 
				all_pills_count_8421 <= all_pills_count_8421 + 1;
			end if;
			if pills_count_8421(3 downto 0) = "1001"then
				if pills_count_8421(7 downto 0) = "10011001"then
					pills_count_8421 <= pills_count_8421 + "01100111";
				else
					pills_count_8421 <= pills_count_8421 + "0111";
				end if;
			else 
				pills_count_8421 <= pills_count_8421 + 1;  -- ÿ��װҩƬʱ��������һ
			end if;
			
			if pills_count_8421 = pills_need then
				pills_count_8421 <= (others => '0');
				if bottom_count_8421(3 downto 0) = "1001"then
					if bottom_count_8421(7 downto 0) = "10011001"then
						bottom_count_8421 <= bottom_count_8421 + "01100111";
					else
						bottom_count_8421 <= bottom_count_8421 + "0111";
					end if;
				else 
					bottom_count_8421 <= bottom_count_8421 + 1;
				end if;
				if bottom_count_8421 = bottom_need then
					stop<='1';
				end if;
			end if;
        end if;
        case show_switch is
			when "00" =>
				show_temp <=pills_count_8421;
			when "01" =>
				show_temp <=all_pills_count_8421;
			when "10" =>
				show_temp <=pills_need;
			when "11" =>
				show_temp <=bottom_count_8421;
			when others =>
				null;
		end case;
		if error = '1' then
			show_temp<="100010001000";
		end if;
    end process;
	
	process(show_temp,clk)
	begin
		case show_temp(3 downto 0) is
			when "0000" =>
				print_light_one <= "1111110"; -- 0
			when "0001" =>
				print_light_one <= "0110000"; -- 1
			when "0010" =>
				print_light_one <= "1101101"; -- 2
			when "0011" =>
				print_light_one <= "1111001"; -- 3
			when "0100" =>
				print_light_one <= "0110011"; -- 4
			when "0101" =>
				print_light_one <= "1011011"; -- 5
			when "0110" =>
				print_light_one <= "0011111"; -- 6
			when "0111" =>
				print_light_one <= "1110000"; -- 7
			when "1000" =>
				print_light_one <= "1111111"; -- 8
			when "1001" =>
				print_light_one <= "1110011"; -- 9
			when others =>
				-- ���û��ƥ���������򲻽����κβ������ɸ�����Ҫ����ʵ��Ĵ����߼�
				null;
		end case;
	end process;
	show <= show_temp(11 downto 4);
end architecture Behavioral;