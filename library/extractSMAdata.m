function asrData = extractSMAdata(smaSettings, spcSettings, avxData, eqData)
    asrData.name='SMA';
    asrData.T=(smaSettings.T_min):smaSettings.T_step:(smaSettings.T_max);

    K=size(asrData.T,2);
    
    asrData.T_h=eqData{1}.T_h; asrData.ds_h=eqData{1}.ds_h;
    asrData.T_v=eqData{1}.T_v; asrData.ds_v=eqData{1}.ds_v;

    asrDataTemp=absoluteSpectralResponse(asrData,avxData,smaSettings.zeta);
    
    for k=1:K
        [~,h_ind]=min(pdist2(asrData.T(k), asrData.T_h));
        [~,v_ind]=min(pdist2(asrData.T(k), asrData.T_v));
        
        [~,ns_sel(k)]=min(abs(asrDataTemp.SA_ns(:,k)-asrData.ds_h(h_ind)));
        [~,ew_sel(k)]=min(abs(asrDataTemp.SA_ew(:,k)-asrData.ds_h(h_ind)));
        [~,ud_sel(k)]=min(abs(asrDataTemp.SA_ud(:,k)-asrData.ds_v(v_ind)));
        
        asrData.SX_ns(k)=asrDataTemp.SX_ns(ns_sel(k),k); asrData.SV_ns(k)=asrDataTemp.SV_ns(ns_sel(k),k); asrData.SA_ns(k)=asrDataTemp.SA_ns(ns_sel(k),k);
        asrData.SX_ew(k)=asrDataTemp.SX_ew(ew_sel(k),k); asrData.SV_ew(k)=asrDataTemp.SV_ew(ew_sel(k),k); asrData.SA_ew(k)=asrDataTemp.SA_ew(ew_sel(k),k);
        asrData.SX_ud(k)=asrDataTemp.SX_ud(ud_sel(k),k); asrData.SV_ud(k)=asrDataTemp.SV_ud(ud_sel(k),k); asrData.SA_ud(k)=asrDataTemp.SA_ud(ud_sel(k),k);
    end
end

function asrData=absoluteSpectralResponse(asrDataTemp,avxData,zeta)
    M=size(avxData,2);
    K=size(asrDataTemp.T,2);
    
    w=2.*pi./(eps+asrDataTemp.T);
    wd=w.*sqrt(1-(zeta.^2));
    
    asrData.SX=zeros(M,K);
    asrData.SV=zeros(M,K);
    asrData.SA=zeros(M,K);
        
    accel=cell(1,M);
    
    for k=1:K
        
        for i=1:M
            a_all=[avxData{i}.a_ns;avxData{i}.a_ew;avxData{i}.a_ud];
            
            t=avxData{i}.t;
            fs=avxData{i}.fs;
            
            N=size(t,2);
            
            t_shifted=t-min(t);
            
            h_sin=exp(-zeta.*w(k).*t_shifted).*sin(wd(k).*t_shifted)./(eps+wd(k));
            h_sin(isinf(h_sin))=sign(h_sin(isinf(h_sin)))./eps;
            
            a_fltd=a_all;
            for j=1:3
                a_fltd_tmp=conv(a_all(j,:),h_sin,'full')./fs;
                a_fltd_tmp((N+1):end)=[];
                a_fltd(j,:)=a_fltd_tmp;
            end
            
            x_0=-a_fltd;
            x_1=[x_0(:,1) diff(x_0,1,2)].*fs;
            x_2=[x_1(:,1) diff(x_1,1,2)].*fs;
            SX=max(abs(x_0),[],2);
            SV=max(abs(x_1),[],2);
            SA=max(abs(x_2+a_all),[],2);
            
            asrData.SX_ns(i,k)=SX(1);
            asrData.SV_ns(i,k)=SV(1);
            asrData.SA_ns(i,k)=SA(1);
            
            asrData.SX_ew(i,k)=SX(2);
            asrData.SV_ew(i,k)=SV(2);
            asrData.SA_ew(i,k)=SA(2);
            
            asrData.SX_ud(i,k)=SX(3);
            asrData.SV_ud(i,k)=SV(3);
            asrData.SA_ud(i,k)=SA(3);
            
            accel{i}=x_2+a_all;
        end
        
        [~,h_ind]=min(pdist2(asrDataTemp.T(k), asrDataTemp.T_h));
        [~,v_ind]=min(pdist2(asrDataTemp.T(k), asrDataTemp.T_v));
        
        [~,ns_sel]=min(abs(asrData.SA_ns(:,k)-asrDataTemp.ds_h(h_ind)));
        [~,ew_sel]=min(abs(asrData.SA_ew(:,k)-asrDataTemp.ds_h(h_ind)));
        [~,ud_sel]=min(abs(asrData.SA_ud(:,k)-asrDataTemp.ds_v(v_ind)));
        
        asrData.SX_ns(k)=asrData.SX_ns(ns_sel,k); asrData.SV_ns(k)=asrData.SV_ns(ns_sel,k); asrData.SA_ns(k)=asrData.SA_ns(ns_sel,k);
        asrData.SX_ew(k)=asrData.SX_ew(ew_sel,k); asrData.SV_ew(k)=asrData.SV_ew(ew_sel,k); asrData.SA_ew(k)=asrData.SA_ew(ew_sel,k);
        asrData.SX_ud(k)=asrData.SX_ud(ud_sel,k); asrData.SV_ud(k)=asrData.SV_ud(ud_sel,k); asrData.SA_ud(k)=asrData.SA_ud(ud_sel,k);
        
        asrData.a_ns=accel{ns_sel}(1,:);
        asrData.a_ew=accel{ew_sel}(1,:);
        asrData.a_ud=accel{ud_sel}(1,:);
    end
end