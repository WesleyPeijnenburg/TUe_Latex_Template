clear all; close all; clc;% Initialisation 
Curr_Path = fileparts(mfilename('fullpath'));% Path to this M file
Py_Path   = [Curr_Path '\Py_appendPDF.py'];

load('March_Data.mat'); % Load demonstration data
for i = 1:Movie_Res% For each movie frame
    % Demo data, you can remove the for loops and plot your own things:
    pause(0.00001); clf% Pause to show the frame and then clear the figure
    eval(figsett);% Set figure settings (demo)
    title('Marchetti Cam Action Engine Principle')
    for e = 1:length(evalsx)% For each polyline
        plot(eval(evalsx{e}),eval(evalsy{e}),P{e}{:});        
    end
    for e = 1:length(evalsx_ppos)% For each repetetive feature (4 wheels, 8 arms, ...)
        for pos = 1:4; plot(eval(evalsx_ppos{e}),eval(evalsy_ppos{e}),P_ppos); end
    end
    
    % Create each frame for the animation and save it as a pdf picture:
    figures{i} = ['Frame_' num2str(i) '.pdf'];% Give the picture a unique name, save it for later
    fig = gcf;% Get current figure
    set(fig,'PaperPositionMode','auto'); % Set scaling on (to remove white borders)
    set(fig,'PaperSize', [fig.PaperPosition(3) fig.PaperPosition(4)]);% Remove white borders
    print(fig,'-dpdf',figures{i});% Save the figure as a pdf picture with the unique name

end
eval(legendeval); % Place predefined (demo) legend on the figure
Anim_name = 'MyAnimation.pdf';% Choose a name for your animation
system(['python "' Py_Path '" ' Anim_name ' ' figures{:}]);% Run windows command to start the python script
delete(figures{:}); %Cleaning up the mess we created: remove each separate frame :)


