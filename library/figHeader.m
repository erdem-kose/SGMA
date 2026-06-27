function figHeader(plotSettings, description)
    %Reserves a band at the top of the current figure and writes a descriptive
    %title there, so a multi-subplot figure is self-explanatory regardless of
    %its filename. The subplots (and their colorbars) are compressed downwards
    %to make room, because fitImage expands them to the figure edges.
    if isfield(plotSettings,'event') && ~isempty(plotSettings.event)
        headerStr=[plotSettings.event ' - ' description];
    else
        headerStr=description;
    end

    fig=gcf;
    headerH=0.07; %fraction of figure height reserved for the header

    objs=[findobj(fig,'Type','axes'); findobj(fig,'Type','colorbar')];
    for k=1:numel(objs)
        if strcmp(get(objs(k),'Units'),'normalized')
            p=get(objs(k),'Position');
            p(2)=p(2)*(1-headerH);
            p(4)=p(4)*(1-headerH);
            set(objs(k),'Position',p);
        end
    end

    annotation(fig,'textbox',[0 1-headerH 1 headerH],'String',headerStr,...
        'EdgeColor','none','HorizontalAlignment','center','VerticalAlignment','middle',...
        'FontWeight','bold','FontSize',plotSettings.font_size+2,'Interpreter','none',...
        'FitBoxToText','off');
end
