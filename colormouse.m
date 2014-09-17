function [] = colormouse(input,~)
%COLORMOUSE Mouse control of color axis.
%   COLORMOUSE adds a toggle button to the current figure which enables
%   dynamic mouse control of the color axis. When the toggle button is
%   enabled, clicking on an object and moving the mouse while the mouse
%   button is held down will continuously change the color axis. 
%
%   Moving the mouse up and down changes shifts the value of entire
%   color axis up and down, while moving left and right expands and
%   contracts the range of the color axis. 
%
%   The toggle button also enables a context menu for the figure which
%   allows the selection of a colormap.
%
%   COLORMOUSE(H) adds the toggle button to the figure with handle H. 
%
%   COLORMOUSE ON changes default settings so that all new figures have the
%   colormouse toggle button.
%
%   COLORMOUSE OFF changes default settings so that all new figures do not
%   have the colormouse toggle button.
%
%   See also CAXIS, COLORMAP, UITOGGLETOOL

%   Patrick Maher
%   v. 1.2 9/16/2014
if nargin==0
    input=gcbf;
    if isempty(input), input=gcf; end
end

if ischar(input)
    if strcmp(input,'on')
        set(0,'defaultfigurecreatefcn',@colormouse);
    elseif strcmp(input,'off')
        set(0,'defaultfigurecreatefcn',{});
    end
elseif ishandle(input)
    numcolors = 200; %number of distinct colors used, 200 produces smooth colormaps that export properly
    hcmenu = uicontextmenu;
    %cmaps is cell array of valid colormaps, custom colormaps can be added
    cmaps={'jet','hsv','hot','cool','spring','summer','autumn','winter','gray','bone','copper','pink','lines','colorcube','flag','prism'};
    for i=1:length(cmaps)
        hcbs{i}=['colormap(' cmaps{i} '(' num2str(numcolors) '))'];
        cmitems(i)=uimenu(hcmenu,'Label',cmaps{i},'Callback',hcbs{i});
    end
    set(hcmenu,'Parent',input);
    onCallBackFn=@(src,EventData) set(gcbf,'WindowButtonDownFcn',@MouseClick,'WindowButtonUpFcn',@MouseUnClick,'UIContextMenu',hcmenu);
    offCallBackFn=@(src,EventData) set(gcbf,'WindowButtonDownFcn',{},'WindowButtonUpFcn',{},'UIContextMenu',[]);
    toolbars = findall(input,'Type','uitoolbar');
    htt = uitoggletool(toolbars(1),'CData',cm_icon, 'Separator','on', 'ToolTipString','Color Axis Mouse Control', 'OnCallback', onCallBackFn, 'OffCallback', offCallBackFn);
else
    error('Invalid input type');
end

end

function [] = MouseClick(src,eventData)
handles=guidata(src);
handles.mouseposition=get(gcbo,'CurrentPoint');
guidata(src,handles);
set(src,'WindowButtonMotionFcn',@MoveMouse)
end

function [] = MouseUnClick(src,eventData)
handles=guidata(src);
set(src,'WindowButtonMotionFcn',{})
end

function [] = MoveMouse(src,eventData)
handles=guidata(src);
axes=gca;
oldmouseposition=handles.mouseposition;
newmouseposition=get(gcbo,'CurrentPoint');
oldclim=get(gca,'CLim');
oldmidpt=(oldclim(1)+oldclim(2))/2;
oldrange=oldclim(2)-oldclim(1);
%sensitivity is how strongly colormap responds to mouse movement. larger
%numbers mean more sensitive
sensitivity=1/100;
mousedelta=newmouseposition(1:2)-oldmouseposition(1:2); %delta x,y for the mouse (typically in the range of 1 to 10)
mousedelta(1)=min(1/sensitivity/2,abs(mousedelta(1)))*sign(mousedelta(1)); %force mousedelta(1) to be less than half of the max sensitivity
newmidpt=oldmidpt-mousedelta(2)*sensitivity*oldrange;
newrange=oldrange*(1-mousedelta(1)*sensitivity);
newclim=[newmidpt-newrange/2 newmidpt+newrange/2];
set(gca,'CLim',newclim);
handles.mouseposition=newmouseposition;
guidata(src,handles);
end

function C = cm_icon()
%creates 16x16 color matrix for icon
C(:,:,1) = [
  240 240 240  50  50  50  50  50  50  50  50  50  50 240 240 240
  240 240 240  50 155 155 155 155 155 155 155 155  50 159 240 240
  240 240 240  50 155 155 155 155 155 155 155 155  50 159 240 240
  240 240 240  50 155   0   0 155 155 155 155 155  50 159 240 240
  240 240 240  50 155   0 255   0 155 155 155 155  50 159 240 240
  240 240 240  50 155   0 255 255   0 155 155 155  50 159 240 240
  240 240 240  50 165   0 255 255 255   0 165 165  50 159 240 240
  240 240 240  50 185   0 255 255 255 255   0 185  50 159 240 240
  240 240 240  50 203   0 255 255   0   0   0 203  50 159 240 240
  240 240 240  50 223   0 255   0   0 223 223 223  50 159 240 240
  240 240 240  50 237   0   0 237   0   0 237 237  50 159 240 240
  240 240 240  50 237 237 237 237 237   0 202 237  50 159 240 240
  240 240 240  50 237 237 237 237 237 237 237 237  50 159 240 240
  240 240 240  50 237 237 237 237 237 237 237 237  50 159 240 240
  240 240 240  50  50  50  50  50  50  50  50  50  50 159 240 240
  240 240 240 240 159 159 159 159 159 159 159 159 159 159 240 240]/255;

C(:,:,2) = [
  240 240 240  70  70  70  70  70  70  70  70  70  70 240 240 240
  240 240 240  70 155 155 155 155 155 155 155 155  70 165 240 240
  240 240 240  70 171 171 171 171 171 171 171 171  70 165 240 240
  240 240 240  70 191   0   0 191 191 191 191 191  70 165 240 240
  240 240 240  70 209   0 255   0 209 209 209 209  70 165 240 240
  240 240 240  70 229   0 255 255   0 229 229 229  70 165 240 240
  240 240 240  70 237   0 255 255 255   0 237 237  70 165 240 240
  240 240 240  70 237   0 255 255 255 255   0 237  70 165 240 240
  240 240 240  70 237   0 255 255   0   0   0 237  70 165 240 240
  240 240 240  70 237   0 255   0   0 237 237 237  70 165 240 240
  240 240 240  70 231   0   0 231   0   0 231 231  70 165 240 240
  240 240 240  70 213 213 213 213 213   0 182 213  70 165 240 240
  240 240 240  70 195 195 195 195 195 195 195 195  70 165 240 240
  240 240 240  70 175 175 175 175 175 175 175 175  70 165 240 240
  240 240 240  70  70  70  70  70  70  70  70  70  70 165 240 240
  240 240 240 240 165 165 165 165 165 165 165 165 165 165 240 240]/255;

C(:,:,3) = [
  240 240 240 120 120 120 120 120 120 120 120 120 120 240 240 240
  240 240 240 120 235 235 235 235 235 235 235 235 120 169 240 240
  240 240 240 120 237 237 237 237 237 237 237 237 120 169 240 240
  240 240 240 120 237   0   0 237 237 237 237 237 120 169 240 240
  240 240 240 120 237   0 255   0 237 237 237 237 120 169 240 240
  240 240 240 120 237   0 255 255   0 237 237 237 120 169 240 240
  240 240 240 120 225   0 255 255 255   0 225 225 120 169 240 240
  240 240 240 120 207   0 255 255 255 255   0 207 120 169 240 240
  240 240 240 120 187   0 255 255   0   0   0 187 120 169 240 240
  240 240 240 120 167   0 255   0   0 167 167 167 120 169 240 240
  240 240 240 120 155   0   0 155   0   0 155 155 120 169 240 240
  240 240 240 120 155 155 155 155 155   0 132 155 120 169 240 240
  240 240 240 120 155 155 155 155 155 155 155 155 120 169 240 240
  240 240 240 120 155 155 155 155 155 155 155 155 120 169 240 240
  240 240 240 120 120 120 120 120 120 120 120 120 120 169 240 240
  240 240 240 240 169 169 169 169 169 169 169 169 169 169 240 240]/255;
end