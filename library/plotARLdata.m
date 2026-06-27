function plotARLdata(plotSettings, arlData)
    arlFig=figure('Name','Earthquake Data Graphs','NumberTitle','off','units','normalized','outerposition',[0 0 1 1],'Visible','off');
    N=size(arlData,2);
    set(findall(arlFig,'-property','FontSize'),'FontSize',plotSettings.font_size);
    
    max_c=-inf; min_c=inf;
    for i=1:N
        arlDataTemp=arlData{i};
        max_c_=max(arlDataTemp.PHA);
        min_c_=min(arlDataTemp.PHA);
        
        if max_c_>max_c
            max_c=max_c_;
        end
        
        if min_c_<min_c
            min_c=min_c_;
        end
    end
    
    min_mesh=inf(2,1); max_mesh=-inf(2,1);
    for i=1:N
        min_mesh_temp=min(arlData{i}.zone,[],2);
        min_mesh(min_mesh_temp<min_mesh)=min_mesh_temp(min_mesh_temp<min_mesh);
        max_mesh_temp=max(arlData{i}.zone,[],2);
        max_mesh(max_mesh_temp>max_mesh)=max_mesh_temp(max_mesh_temp>max_mesh);
    end
    [xi,yi] = meshgrid( min_mesh(1):0.01:max_mesh(1),min_mesh(2):0.01:max_mesh(2));
                        
    for i=1:N
        arlDataTemp=arlData{i};
        N_=ceil(sqrt(2));
        
        F = scatteredInterpolant(arlDataTemp.zone',arlDataTemp.PHA');
        zi = F(xi,yi);
        
        subplot(N_,N_,i);
        hold on;
        imagesc(xi(1,:),yi(:,1),zi); colorbar;
        scatter(arlDataTemp.coord(1,:),arlDataTemp.coord(2,:),10,'r','filled');
        text(arlDataTemp.coord(1,:)',arlDataTemp.coord(2,:)',arlDataTemp.stationName,...
                'Color','white','FontSize',8,'HorizontalAlignment','center');
        
        axis tight; grid minor; title([arlDataTemp.type ' (cm/s^2) Site Class: ' arlDataTemp.class]);
        ylabel('Latitude (deg)'); xlabel('Longtitude (deg)');
        pbaspect([1 1 1]); caxis([min_c max_c]);
        
        set(gca, 'XDir','normal');
        set(gca, 'YDir','normal');
        
        fitImage(gca);
    end

    saveas(arlFig,['outputs/' plotSettings.file_name '_AR' plotSettings.postfix '.png']);
    set(arlFig,'Visible','on');
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
