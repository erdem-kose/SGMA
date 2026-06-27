function asrData = extractASRdata(asrSettings, avxData, eqData)
    asrData.name='ASR';
    asrData.T=(asrSettings.T_min):asrSettings.T_step:(asrSettings.T_max);

    asrData.T_h=eqData.T_h; asrData.ds_h=eqData.ds_h;
    asrData.T_v=eqData.T_v; asrData.ds_v=eqData.ds_v;

    [asrData.SX_ns,asrData.SV_ns,asrData.SA_ns]=absoluteSpectralResponse(asrData,avxData.a_ns,avxData.t,avxData.fs,asrSettings.zeta);
    [asrData.SX_ew,asrData.SV_ew,asrData.SA_ew]=absoluteSpectralResponse(asrData,avxData.a_ew,avxData.t,avxData.fs,asrSettings.zeta);
    [asrData.SX_ud,asrData.SV_ud,asrData.SA_ud]=absoluteSpectralResponse(asrData,avxData.a_ud,avxData.t,avxData.fs,asrSettings.zeta);

    if (asrSettings.T_scale >= min(asrData.T)) && (asrSettings.T_scale <= max(asrData.T))
        [~,SA_ind]=min(pdist2(asrSettings.T_scale',asrData.T'));
        [~,h_ind]=min(pdist2(asrSettings.T_scale', asrData.T_h));
        [~,v_ind]=min(pdist2(asrSettings.T_scale', asrData.T_v));
        asrData.SA_ns=asrData.SA_ns.*asrData.ds_h(h_ind)./(eps+asrData.SA_ns(SA_ind));
        asrData.SA_ew=asrData.SA_ew.*asrData.ds_h(h_ind)./(eps+asrData.SA_ew(SA_ind));
        asrData.SA_ud=asrData.SA_ud.*asrData.ds_v(v_ind)./(eps+asrData.SA_ud(SA_ind));
    end
end

function [SX,SV,SA]=absoluteSpectralResponse(asrData,accel,t,fs,zeta)
    w=2.*pi./(eps+asrData.T);
    wd=w.*sqrt(1-(zeta.^2));
    
    N=size(accel,2);
    K=size(asrData.T,2);
    
    t_shifted=t-min(t);
    
    SX=zeros(1,K);
    SV=zeros(1,K);
    SA=zeros(1,K);
    
    for k=1:K
        h_sin=exp(-zeta.*w(k).*t_shifted).*sin(wd(k).*t_shifted)./(eps+wd(k));
        h_sin(isinf(h_sin))=sign(h_sin(isinf(h_sin)))./eps;
        
        accel_fltd=conv(accel,h_sin,'full')./fs;
        accel_fltd((N+1):end)=[];
        
        x_0=-accel_fltd;
        x_1=[x_0(1) diff(x_0)].*fs;
        x_2=[x_1(1) diff(x_1)].*fs;
        SX(k)=max(abs(x_0));
        SV(k)=max(abs(x_1));
        SA(k)=max(abs(x_2+accel));
    end
end