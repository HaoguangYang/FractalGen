function varargout = UI(varargin)
%UI M-file for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('Property','Value',...) creates a new UI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to UI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      UI('CALLBACK') and UI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in UI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 19-Jun-2015 00:17:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

global handlesdata;
handlesdata=[];
handlesdata{1}='Polynomial';
%handles.graph=[];
set(gcf,'toolbar','figure');
handles.axes1=[];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in status.
function status_Callback(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
str = get(hObject, 'String');
global handlesdata
global handlesold
switch str{val};
    case 'Logistic'
        set(handles.uipanel1,'Visible','on');
        set(handles.uipanel2,'Visible','off');
        set(handles.uipanel3,'Visible','off');
        set(handles.LogisticRes2,'Enable','off');
        set(handles.Prev,'Enable','on');
        handlesold=handlesdata;
        handlesdata=[];
        handlesdata{1}='Logistic';
        set(handles.LogisticInit,'String','');
        set(handles.xRangeMin,'String','');
        set(handles.xRangeMax,'String','');
        set(handles.LogisticRes,'String','');
    case 'Polynomial'
        set(handles.uipanel1,'Visible','off');
        set(handles.uipanel2,'Visible','on');
        set(handles.uipanel3,'Visible','off');
        set(handles.Prev,'Enable','on');
        handlesold=handlesdata;
        handlesdata=[];
        handlesdata{1}='Polynomial';
        set(handles.PolyCoeff,'Data',[]);
        set(handles.PolyDeg,'String','');
        set(handles.xRes,'String','');
        set(handles.yRes,'String','');
        set(handles.xFrm,'String','');
        set(handles.xTo,'String','');
        set(handles.yFrm,'String','');
        set(handles.yTo,'String','');
    case 'IFS-Tree'
        set(handles.uipanel1,'Visible','off');
        set(handles.uipanel2,'Visible','off');
        set(handles.uipanel3,'Visible','on');
        set(handles.Prev,'Enable','off');
        handlesold=handlesdata;
        handlesdata=[];
        handlesdata{1}='Tree';
        set(handles.DataAA,'Data',zeros(4,6));
        set(handles.IterNo,'String','');
end
% Hints: contents = cellstr(get(hObject,'String')) returns status contents as cell array
%        contents{get(hObject,'Value')} returns selected item from status


% --- Executes during object creation, after setting all properties.
function status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Calc.
function Calc_Callback(~, ~, ~)
% hObject    handle to Calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handlesdata
global graph 
switch handlesdata{1}
    case 'Logistic'
        amin = handlesdata{2};
        amax = handlesdata{3};
        x0 =   handlesdata{4};
        xres =  handlesdata{5};
        loadlibrary('Logistic',@mLogistic);
        graph=zeros(250,xres);
        [~,~,~,~,graph]=calllib('Logistic','logistical',amin,amax,x0,xres,graph);
        unloadlibrary('Logistic');
        mesh(graph);
        set(gca,'Tag','axes1');
    case 'Polynomial'
        deg = handlesdata{2};
        coef = handlesdata{3};
        yres = handlesdata{4};
        xres = handlesdata{5};
        yrange = handlesdata{6};
        xrange = handlesdata{7};
        loadlibrary('Poly',@mPoly);
        graph=zeros(yres,xres);
        [~,~,~,~,~,~,graph]=calllib('Poly','polynomial',deg,coef,yres,xres,yrange,xrange,graph);
        unloadlibrary('Poly');
        imagesc(graph);
    case 'Tree'
        N = handlesdata{2};
        AA = handlesdata{3};
        loadlibrary('Tree',@mTree);
        xx=zeros(N,1);
        yy=zeros(N,1);
        [~,~,xx,yy]=calllib('Tree','tree',N,AA,xx,yy);
        unloadlibrary('Tree');
        plot(xx,yy,'.g','markersize',2)
        %graph=get(gca,'CData');
end

% --- Executes on button press in Esc.
function Esc_Callback(~, ~, ~)
% hObject    handle to Esc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
quit;

% --- Executes on button press in Export.
function Export_Callback(~, ~, ~)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handlesdata
[filename,pathname,fileindex]=uiputfile({'*.png';'*.bmp';'*.jpg'},'Figure Save As');
if or(strcmp(handlesdata{1},'Logistic'),strcmp(handlesdata{1},'Tree'))==1
    if  filename~=0   %未点“取消”按钮或未关闭
        file=strcat(pathname,filename);
        switch fileindex   %根据不同的选择保存为不同的类型        
            case 1
                print(gcf,'-r300',file,'-dpng','-noui');
            case 2
                print(gcf,'-r300',file,'-dbitmap','-noui');
            case 3
                print(gcf,'-r300',file,'-djpg','-noui');
        end 
        msgbox({'';'       Figure saved successfully.       ';''});
    end
else            
global graph
graph = (graph - [min(min(graph))])/(max(max(graph))-min(min(graph)))*256;
    if  filename~=0%未点“取消”按钮或未关闭
        file=strcat(pathname,filename);
        switch fileindex %根据不同的选择保存为不同的类型        
            case 1
                imwrite(graph,jet(256),file,'png');%将图像打印到指定文件中
                %fprintf('Figure saved as: %s\n',file);
            case 2
                imwrite(graph,jet(256),file,'bmp');
                %fprintf('Figure saved as: %s\n',file);
            case 3
                imwrite(graph,jet(256),file,'jpeg');
                %fprintf('Figure saved as: %s\n',file);
        end 
        msgbox({'';'       Figure saved successfully.       ';''});
    end
end


% --- Executes on button press in Prev.
function Prev_Callback(~, ~, ~)
% hObject    handle to Prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handlesdata
switch handlesdata{1}
    case 'Logistic'
        amin = handlesdata{2};
        amax = handlesdata{3};
        x0 =   handlesdata{4};
        xres =  250;
        loadlibrary('Logistic',@mLogistic);
        graph=zeros(250,xres);
        [~,~,~,~,graph]=calllib('Logistic','logistical',amin,amax,x0,xres,graph);
        unloadlibrary('Logistic');
        mesh(graph);
        %ax=gca;
        %set(ax,'Tag','axes1');
    case 'Polynomial'
        deg = handlesdata{2};
        coef = handlesdata{3};
        yres = 40*deg;
        xres = 40*deg;
        yrange = handlesdata{6};
        xrange = handlesdata{7};
        loadlibrary('Poly',@mPoly);
        graph=zeros(yres,xres);
        [~,~,~,~,~,~,graph]=calllib('Poly','polynomial',deg,coef,yres,xres,yrange,xrange,graph);
        unloadlibrary('Poly');
        imagesc(graph);
end


function PolyDeg_Callback(hObject, eventdata, handles)
% hObject    handle to PolyDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
deg = str2num(str);
global handlesdata
handlesdata{2}=deg;
set(handles.PolyCoeff,'Data',zeros(deg+1,1));
% Hints: get(hObject,'String') returns contents of PolyDeg as text
%        str2double(get(hObject,'String')) returns contents of PolyDeg as a double


% --- Executes during object creation, after setting all properties.
function PolyDeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PolyDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xRes_Callback(hObject, eventdata, ~)
% hObject    handle to xRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata
temp=str2num(val);
if mod(temp,100)==0
    temp=temp+1;
end
handlesdata{5}=temp;
% Hints: get(hObject,'String') returns contents of xRes as text
%        str2double(get(hObject,'String')) returns contents of xRes as a double


% --- Executes during object creation, after setting all properties.
function xRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yRes_Callback(hObject, eventdata, ~)
% hObject    handle to yRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
temp=str2num(val);
if mod(temp,100)==0
    temp=temp+1;
end
handlesdata{4}=temp;

% Hints: get(hObject,'String') returns contents of yRes as text
%        str2double(get(hObject,'String')) returns contents of yRes as a double


% --- Executes during object creation, after setting all properties.
function yRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xFrm_Callback(hObject, eventdata, ~)
% hObject    handle to xFrm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{7}(1)=str2double(val);
% Hints: get(hObject,'String') returns contents of xFrm as text
%        str2double(get(hObject,'String')) returns contents of xFrm as a double


% --- Executes during object creation, after setting all properties.
function xFrm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xFrm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xTo_Callback(hObject, eventdata, ~)
% hObject    handle to xTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{7}(2)=str2double(val);
% Hints: get(hObject,'String') returns contents of xTo as text
%        str2double(get(hObject,'String')) returns contents of xTo as a double


% --- Executes during object creation, after setting all properties.
function xTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yFrm_Callback(hObject, eventdata, ~)
% hObject    handle to yFrm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{6}(1)=str2double(val);
% Hints: get(hObject,'String') returns contents of yFrm as text
%        str2double(get(hObject,'String')) returns contents of yFrm as a double


% --- Executes during object creation, after setting all properties.
function yFrm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yFrm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yTo_Callback(hObject, eventdata, ~)
% hObject    handle to yTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{6}(2)=str2double(val);
% Hints: get(hObject,'String') returns contents of yTo as text
%        str2double(get(hObject,'String')) returns contents of yTo as a double


% --- Executes during object creation, after setting all properties.
function yTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LogisticRes_Callback(hObject, eventdata, ~)
% hObject    handle to LogisticRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{5}=str2num(val);
% Hints: get(hObject,'String') returns contents of LogisticRes as text
%        str2double(get(hObject,'String')) returns contents of LogisticRes as a double


% --- Executes during object creation, after setting all properties.
function LogisticRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogisticRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LogisticInit_Callback(hObject, eventdata, ~)
% hObject    handle to LogisticInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{4}=str2double(val);

% Hints: get(hObject,'String') returns contents of LogisticInit as text
%        str2double(get(hObject,'String')) returns contents of LogisticInit as a double


% --- Executes during object creation, after setting all properties.
function LogisticInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogisticInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xRangeMin_Callback(hObject, eventdata, ~)
% hObject    handle to xRangeMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{2}=str2double(val);

% Hints: get(hObject,'String') returns contents of xRangeMin as text
%        str2double(get(hObject,'String')) returns contents of xRangeMin as a double


% --- Executes during object creation, after setting all properties.
function xRangeMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xRangeMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xRangeMax_Callback(hObject, eventdata, ~)
% hObject    handle to xRangeMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{3}=str2double(val);

% Hints: get(hObject,'String') returns contents of xRangeMax as text
%        str2double(get(hObject,'String')) returns contents of xRangeMax as a double


% --- Executes during object creation, after setting all properties.
function xRangeMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xRangeMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in PolyCoeff.
function PolyCoeff_CellEditCallback(hObject, eventdata, ~)
% hObject    handle to PolyCoeff (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global handlesdata;
handlesdata{3}=get(hObject,'Data');



function LogisticRes2_Callback(hObject, eventdata, handles)
% hObject    handle to LogisticRes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LogisticRes2 as text
%        str2double(get(hObject,'String')) returns contents of LogisticRes2 as a double


% --- Executes during object creation, after setting all properties.
function LogisticRes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogisticRes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Peeling_Callback(hObject, eventdata, handles)
% hObject    handle to Peeling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global graph
val=get(hObject,'String');
val=str2num(val);
mesh(graph(val:250,:));

% Hints: get(hObject,'String') returns contents of Peeling as text
%        str2double(get(hObject,'String')) returns contents of Peeling as a double


% --- Executes during object creation, after setting all properties.
function Peeling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Peeling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IterNo_Callback(hObject, eventdata, handles)
% hObject    handle to IterNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'String');
global handlesdata;
handlesdata{2}=str2num(val);
% Hints: get(hObject,'String') returns contents of IterNo as text
%        str2double(get(hObject,'String')) returns contents of IterNo as a double


% --- Executes during object creation, after setting all properties.
function IterNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IterNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','off');

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','off');

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in DataAA.
function DataAA_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to DataAA (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global handlesdata;
handlesdata{3}=get(hObject,'Data');
