function plotAVXdata(plotSettings, avxData)
    avxFig=figure('Name','Earthquake Data Graphs','NumberTitle','off','units','normalized','outerposition',[0 0 1 1],'Visible','off');
    
    %% Arias Intensity part
    subplot(4,3,1)
    plot(avxData.t,avxData.Ia_ns,plotSettings.line_colors{1},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('I_A(t) (cm/s)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,2)
    plot(avxData.t,avxData.Ia_ew,plotSettings.line_colors{2},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title({'Waveform','East-West'});
    ylabel('I_A(t) (cm/s)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,3)
    plot(avxData.t,avxData.Ia_ud,plotSettings.line_colors{3},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('I_A(t) (cm/s)'); xlabel('t(sec)');
    fitImage(gca);
    
    %% Acceleration part
    subplot(4,3,4)
    plot(avxData.t,avxData.a_ns,plotSettings.line_colors{1},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('a(t) (cm/s^2)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,5)
    plot(avxData.t,avxData.a_ew,plotSettings.line_colors{2},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title({'Waveform','East-West'});
    ylabel('a(t) (cm/s^2)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,6)
    plot(avxData.t,avxData.a_ud,plotSettings.line_colors{3},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('a(t) (cm/s^2)'); xlabel('t(sec)');
    fitImage(gca);
    
    %% Velocity part
    subplot(4,3,7)
    plot(avxData.t,avxData.v_ns,plotSettings.line_colors{1},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('v(t) (cm/s)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,8)
    plot(avxData.t,avxData.v_ew,plotSettings.line_colors{2},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('East-West');
    ylabel('v(t) (cm/s)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,9)
    plot(avxData.t,avxData.v_ud,plotSettings.line_colors{3},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('v(t) (cm/s)'); xlabel('t(sec)');
    fitImage(gca);
    
    %% Displacement part
    subplot(4,3,10)
    plot(avxData.t,avxData.x_ns,plotSettings.line_colors{1},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('x(t) (cm)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,11)
    plot(avxData.t,avxData.x_ew,plotSettings.line_colors{2},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('East-West');
    ylabel('x(t) (cm)'); xlabel('t(sec)');
    fitImage(gca);
    
    subplot(4,3,12)
    plot(avxData.t,avxData.x_ud,plotSettings.line_colors{3},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('x(t) (cm)'); xlabel('t(sec)');
    fitImage(gca);
    
    set(findall(avxFig,'-property','FontSize'),'FontSize',plotSettings.font_size);
    
    saveas(avxFig,['outputs/' plotSettings.file_name '_Waveform' plotSettings.postfix '.png']);
    set(avxFig,'Visible','on');
end

function fitImage(ax)
    outerpos = ax.OuterPosition;
    ti = ax.TightInset;
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    ax.Position = [left bottom ax_width ax_height];
end