function W_figs( FigLoc, filenames, varargin)
%W_figs - Save figures as PDF and generate matlab output or IPE output
%  By: Wesley Peijnenburg (w.peijnenburg@student.tue.nl)
% Usage: W_figs(<figure location>,'name_of_figure')
% 
%   Options:
%  'width', 7          Make the picture bigger, default = 6.5 in
%  'ratio',  [1 2]      Give the width to length scaling of the picture
%                      Default: [6 5]
%                      Common:  [14 9] / [6 5] / [10 8]
%  'ipe',true          Make ipe-compatible PDF. 
%                      WARNING: THIS REQUIRES PEARL SCRIPT
%                      See: https://github.com/otfried/ipe-wiki/wiki/Matlab
%  'mcode',true        Generates the matlab code for this figure
%                      WARNING: if more than one figure, also specify 
%                      the number of figures in the option 'grid_width'
%  'grid_width',3      The number of figures placed next to each other
%  'savePDF',false     Generate PDF, yes or no. Default = yes
%  'savePNG',true      Generate PNG, yes or no. Default = no 
%  'savefig',false     Allows you to disable this function with a variable 
%                      save_fig defined somewhere else in your script
% 
% 
%  If you want to use it for more figures, then you must specify these:
%  'handles',{<h1>,<h2>,...}  Figure handles
%  'grid_width',2             How many figures should be placed side by side?



%% Set default values
    Pwidth      = 6.5; % inches
    Ratio       = [6 5];
    IPE         = false;
    Mcode       = false;
    savePDF     = true; 
    savePNG     = false; 
    Nfigs       = 1;    % Amount of figures to save
    handles{1}  = gcf;  % select current figure

  
%% Overwrite default values, if specified

    for k = 1:2:length(varargin)
      name = varargin{k};  
      if isempty(strfind(name,'width')) == false
        Pwidth = varargin{k + 1}; end 
       
      if isempty(strfind(name,'ratio')) == false
        Ratio = varargin{k + 1}; end             
        
      if isempty(strfind(name,'ipe')) == false
        IPE = varargin{k + 1}; end 
    
      if isempty(strfind(name,'mcode')) == false
        Mcode = varargin{k + 1}; end 
    
      if isempty(strfind(name,'savePDF')) == false
        savePDF = varargin{k + 1}; end 
    
      if isempty(strfind(name,'savePNG')) == false
        savePNG = varargin{k + 1}; end 
    
      if isempty(strfind(name,'handles')) == false
        handles = varargin{k + 1}; end 
    
      if isempty(strfind(name,'grid_width')) == false
        grid_width = varargin{k + 1}; end  
    
      if isempty(strfind(name,'savefig')) == false
          savefig = varargin{k + 1};
          if ~savefig; return; end
      end    
    
    end
    
    
    if iscell(filenames) % If it's a cell, multiple figures are given
        Nfigs = length(filenames);
    else
        temp = filenames; clearvars filenames
        filenames{1} = temp; %Make a cell out of it
        clearvars temp
    end  
    
   
%     If the folder location is invalid, give an error
    if ~exist(FigLoc, 'dir'); error('I cannot find the pictures folder, please check the figure location:\n%s',FigLoc); return ; end   
  
    
    
%% Calculate figure dimensions
    Ratio = Ratio ./ Ratio(1); % Normalise to width   
    Ratio = Ratio .* Pwidth; % Calculate new dimensions 
    

%% Save figure(s)

for Nfig = 1:Nfigs

    name = filenames{Nfig}; % get the name of each fig
    figure(handles{Nfig});  % Select each fig to save it
    
    set(gcf,'PaperUnits', 'inches');
    set(gcf,'Papersize',Ratio); % % [14 9] / [6 5] / [10 8]
    set(gcf,'PaperPositionMode','manual');
    set(gcf,'PaperPosition',[0 0 Ratio]);
    
    % OPTIONAL: SAVE PDF
    if savePDF; 
        print(gcf,'-dpdf',strcat(FigLoc,name,'.pdf')); 
        % Confirmation message:
        fprintf('Saved %s.pdf at %s\n',name,FigLoc)
    end
    % OPTIONAL: SAVE PNG
    if savePNG; 
        print(gcf,'-dpng',strcat(FigLoc,name,'.png')); 
        % Confirmation message:
        fprintf('Saved %s.png at %s\n',name,FigLoc)
    end
    % OPTIONAL: SAVE IPE compatible
    if IPE; cdc = cd; cd(FigLoc); 
        pdftoipe = 'C:/Program Files/ipe-7.2.1/bin/pdftoipe.exe';
        ipetoipe = 'C:/Program Files/ipe-7.2.1/bin/ipetoipe.exe';
        system(['"' pdftoipe '" "' name '.pdf" "' name '.xml"']);
        system(['"' ipetoipe '" -pdf "' name '.xml" "' name '.pdf"']);
        delete([name '.xml']);
        cd(cdc); 
    end
end


if Mcode && Nfigs ==1
    fprintf('\nLATEX CODE:\n\n\\begin{figure}[H] \\begin{center}\n\\includegraphics[scale=1]{%s}\n%% \\caption{Caption_goes_here}\n\\label{%s}\n\\end{center}\\end{figure}\n',...
        name,name); 
end
        
if Mcode && Nfigs >1    
    fprintf('\nLATEX CODE:\n\n\\begin{figure}[H]%%  \\usepackage{subfig}\n\\centering\n')    
    for Nfig = 1:Nfigs        
        name = filenames{Nfig}; % get the name of each fig
        
        fprintf('\t\\subfloat[Caption %i]\n\t{{\\includegraphics[width=%0.2f\\textwidth]{%s}}}%%\n',...
        Nfig,0.9/grid_width,name); 
        
        if mod(Nfig,grid_width) == 0 && Nfig ~= Nfigs
            fprintf('~\\\\')
        elseif Nfig ~= Nfigs
            fprintf('\\qquad\n')
        end    
        
    end    
    fprintf('\\caption{Caption for all figures}\n\\end{figure}\n')        
end









