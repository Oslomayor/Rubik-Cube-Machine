% GUI for Magic Cube Machine test
% 双臂魔方机器的测试上位机
% GitHub: Oslomayor
% Date: 2019-03-05

function cube_machine_test_GUI(~,~)

% GUI Layout
figure('pos',[800 400 260 210],'menu','none','numbertitle','off','name','Cube Machine');
uicontrol('pos',[30 10 80 40],'string','reset','callback',@call_reset,'fontsize',14);
uicontrol('pos',[150 10 80 40],'string','ready','callback',@call_ready,'fontsize',14);
uicontrol('pos',[30 90 40 30],'string','+90','callback',@call_A_P90,'fontsize',12);
uicontrol('pos',[70 90 40 30],'string','none','callback',@call_none,'fontsize',12);
uicontrol('pos',[30 130 40 30],'string','-90','callback',@call_A_N90,'fontsize',12);
uicontrol('pos',[70 130 40 30],'string','0','callback',@call_A_0,'fontsize',12);
uicontrol('pos',[30 170 40 30],'string','松','callback',@call_A_lose,'fontsize',12);
uicontrol('pos',[70 170 40 30],'string','夹','callback',@call_A_catch,'fontsize',12);
uicontrol('pos',[150 90 40 30],'string','+90','callback',@call_B_P90,'fontsize',12);
uicontrol('pos',[190 90 40 30],'string','none','callback',@call_none,'fontsize',12);
uicontrol('pos',[150 130 40 30],'string','-90','callback',@call_B_N90,'fontsize',12);
uicontrol('pos',[190 130 40 30],'string','0','callback',@call_B_0,'fontsize',12);
uicontrol('pos',[150 170 40 30],'string','松','callback',@call_B_lose,'fontsize',12);
uicontrol('pos',[190 170 40 30],'string','夹','callback',@call_B_catch,'fontsize',12);
uicontrol('Style','text','pos',[40 60 60 20],'string','机械臂α','fontsize',12);
uicontrol('Style','text','pos',[160 60 60 20],'string','机械臂β','fontsize',12);
uicontrol('Style','text','pos',[110 60 40 20],'string','串口','fontsize',12);
uicontrol('pos',[110 30 20 20],'string','开','callback',@start_serialport,'fontsize',8);
uicontrol('pos',[130 30 20 20],'string','关','callback',@close_serialport,'fontsize',8);

% Serial Port
global scom_flag;
global scom;
global port;
scom_flag = false;

% 打开串口
function start_serialport(~,~)
serialinfo = instrhwinfo('serial');
port = serialinfo.SerialPorts;
if true == isempty(port)
    msgbox('Serial Port is not found.');
    return;
else
    scom = serial(port,'BaudRate',9600);
    scom.BytesAvailableFcnMode = 'byte';
    scom.Timeout = 1;
    scom.TimerPeriod = 2;
    scom.TimerFcn = @receive_data;
end
try
    fopen(scom);
    if true == strcmp(scom.Status,'open')
        msgbox(strcat(port,' is opened.'));
        scom_flag = true;
    end
catch
    msgbox('Can not open Serial Port.');
    s = instrfind;
    fclose(s);
    delete(s);
end 
end
% 关闭串口  
function close_serialport(~,~)
if false == scom_flag
    return;
else
    fclose(scom);
    delete(scom);
    msgbox(strcat(port,' is closed.'));
end
end

end

% 接收串口数据
function [data] = receive_data(~,~)
global scom;
data = fread(scom,10,'uint8');
disp(data);
warning off;
end

% call_A_P90
function call_A_P90(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('01111100'));
fwrite(scom,hex2dec('0A'));
end

% call_A_N90
function call_A_N90(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('01001111'));
fwrite(scom,hex2dec('0A'));
end

% call_A_0
function call_A_0(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('01110011'));
fwrite(scom,hex2dec('0A'));
end

% call_B_P90
function call_B_P90(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('10111100'));
fwrite(scom,hex2dec('0A'));
end

% call_B_N90
function call_B_N90(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('10001111'));
fwrite(scom,hex2dec('0A'));
end

% call_B_0
function call_B_0(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('10110011'));
fwrite(scom,hex2dec('0A'));
end

% call_A_catch
function call_A_catch(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('01001100'));
fwrite(scom,hex2dec('0A'));
end

% call_A_lose
function call_A_lose(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('01100001'));
fwrite(scom,hex2dec('0A'));
end

% call_B_catch
function call_B_catch(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('10001100'));
fwrite(scom,hex2dec('0A'));
end

% call_B_lose
function call_B_lose(~,~)
global scom;
fwrite(scom,'@');
fwrite(scom,bin2dec('10100001'));
fwrite(scom,hex2dec('0A'));
end

% call reset
function call_reset(~,~)
call_A_lose;
call_B_lose;
call_A_0;
call_B_0;
end

% call ready
function call_ready(~,~)
call_A_catch;
call_B_catch;
end