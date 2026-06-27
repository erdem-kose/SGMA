function plotFRQdata(plotSettings, frqData)
    frqFig=figure('Name','Earthquake Data Graphs','NumberTitle','off','units','normalized','outerposition',[0 0 1 1],'Visible','off');
    
    %% Acceleration part
    subplot(3,3,1)
    stem(frqData.f,frqData.A_ns,plotSettings.line_colors{1},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('|A(f)| (cm/s^2)'); xlabel('f(Hz)');
    fitImage(gca);
    
    subplot(3,3,2)
    stem(frqData.f,frqData.A_ew,plotSettings.line_colors{2},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('East-West');
    ylabel('|A(f)| (cm/s^2)'); xlabel('f(Hz)');
    fitImage(gca);
    
    subplot(3,3,3)
    stem(frqData.f,frqData.A_ud,plotSettings.line_colors{3},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('|A(f)| (cm/s^2)'); xlabel('f(Hz)');
    fitImage(gca);
    
    %% Velocity part
    subplot(3,3,4)
    stem(frqData.f,frqData.V_ns,plotSettings.line_colors{1},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('|V(f)| (cm/s)'); xlabel('f(Hz)');
    fitImage(gca);
    
    subplot(3,3,5)
    stem(frqData.f,frqData.V_ew,plotSettings.line_colors{2},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('East-West');
    ylabel('|V(f)| (cm/s)'); xlabel('f(Hz)');
    fitImage(gca);
    
    subplot(3,3,6)
    stem(frqData.f,frqData.V_ud,plotSettings.line_colors{3},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('|V(f)| (cm/s)'); xlabel('f(Hz)');
    fitImage(gca);
    
    %% Displacement part
    subplot(3,3,7)
    stem(frqData.f,frqData.X_ns,plotSettings.line_colors{1},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('|X(f)| (cm)'); xlabel('f(Hz)');
    fitImage(gca);
    
    subplot(3,3,8)
    stem(frqData.f,frqData.X_ew,plotSettings.line_colors{2},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('East-West');
    ylabel('|X(f)| (cm)'); xlabel('f(Hz)');
    fitImage(gca);
    
    subplot(3,3,9)
    stem(frqData.f,frqData.X_ud,plotSettings.line_colors{3},'marker','none','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('|X(f)| (cm)'); xlabel('f(Hz)');
    fitImage(gca);
    
    set(findall(frqFig,'-property','FontSize'),'FontSize',plotSettings.font_size);
    figHeader(plotSettings, ['Frequency Spectra (' frqData.type '): Acceleration / Velocity / Displacement']);

    saveas(frqFig,['outputs/' plotSettings.file_name '_' frqData.type plotSettings.postfix '.png']);
    set(frqFig,'Visible','on');
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