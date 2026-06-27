function plotASRdata(plotSettings, asrData)
    prsFig=figure('Name','Earthquake Data Graphs','NumberTitle','off','units','normalized','outerposition',[0 0 1 1],'Visible','off');

    %% Acceleration part
    subplot(3,3,1); hold on;
    plot(asrData.T,asrData.SA_ns,plotSettings.line_colors{1},'LineWidth',plotSettings.line_width)
    plot(asrData.T_h,asrData.ds_h,'k','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('|a(t)|_{max} (cm/s^2)'); xlabel('T(sec)');
    fitImage(gca);
    
    subplot(3,3,2); hold on;
    plot(asrData.T,asrData.SA_ew,plotSettings.line_colors{2},'LineWidth',plotSettings.line_width)
    plot(asrData.T_h,asrData.ds_h,'k','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title({'Absolute-Spectral Responses','East-West'});
    ylabel('|a(t)|_{max} (cm/s^2)'); xlabel('T(sec)');
    fitImage(gca);
    
    subplot(3,3,3); hold on;
    plot(asrData.T,asrData.SA_ud,plotSettings.line_colors{3},'LineWidth',plotSettings.line_width)
    plot(asrData.T_v,asrData.ds_v,'k','LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('|a(t)|_{max} (cm/s^2)'); xlabel('T(sec)');
    fitImage(gca);
    
    %% Velocity part %semilogy can be used instead of plot
    subplot(3,3,4);
    plot(asrData.T,asrData.SV_ns,plotSettings.line_colors{1},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('|v(t)|_{max} (cm/s)'); xlabel('T(sec)');
    fitImage(gca);
    
    subplot(3,3,5);
    plot(asrData.T,asrData.SV_ew,plotSettings.line_colors{2},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('East-West');
    ylabel('|v(t)|_{max} (cm/s)'); xlabel('T(sec)');
    fitImage(gca);
    
    subplot(3,3,6);
    plot(asrData.T,asrData.SV_ud,plotSettings.line_colors{3},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('|v(t)|_{max} (cm/s)'); xlabel('T(sec)');
    fitImage(gca);
    
    %% Displacement part %semilogy can be used instead of plot
    subplot(3,3,7);
    plot(asrData.T,asrData.SX_ns,plotSettings.line_colors{1},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('North-South');
    ylabel('|x(t)|_{max} (cm)'); xlabel('T(sec)');
    fitImage(gca);
    
    subplot(3,3,8);
    plot(asrData.T,asrData.SX_ew,plotSettings.line_colors{2},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('East-West');
    ylabel('|x(t)|_{max} (cm)'); xlabel('T(sec)');
    fitImage(gca);
    
    subplot(3,3,9);
    plot(asrData.T,asrData.SX_ud,plotSettings.line_colors{3},'LineWidth',plotSettings.line_width)
    axis tight; grid minor; title('Up-Down');
    ylabel('|x(t)|_{max} (cm)'); xlabel('T(sec)');
    fitImage(gca);
    
    set(findall(prsFig,'-property','FontSize'),'FontSize',plotSettings.font_size);
    
    if isfield(asrData,'name'), asrTag=asrData.name; else, asrTag='ASR'; end
    saveas(prsFig,['outputs/' plotSettings.file_name '_' asrTag plotSettings.postfix '.png']);
    set(prsFig,'Visible','on');
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