function spcData = extractFRQdata(spcSettings,avxData)
    ws=warning('off','all'); restoreWarn=onCleanup(@()warning(ws)); %restore warnings on exit
    
    n=size(avxData.t,2);
    N=2.^nextpow2(n);
    
    spcData.f=linspace(0,avxData.fs.*(1-(1/N)),N);
    spcData.type=spcSettings.type;
    
    %% Windowing
    if spcSettings.windowing==1
        w_=hamming(n)';
    else
        w_=ones(1,n);
    end
    a_ns_w=avxData.a_ns.*w_; a_ew_w=avxData.a_ew.*w_; a_ud_w=avxData.a_ud.*w_;
    v_ns_w=avxData.v_ns.*w_; v_ew_w=avxData.v_ew.*w_; v_ud_w=avxData.v_ud.*w_;
    x_ns_w=avxData.x_ns.*w_; x_ew_w=avxData.x_ew.*w_; x_ud_w=avxData.x_ud.*w_;
    
    switch spcSettings.type
        case 'welch'
            dx=1./avxData.fs;
            window_len=spcSettings.welch_window_dur./dx;
            overlap_len=ceil(window_len.*spcSettings.welch_overlap_rat);
            
            spcData.A_ns=sqrt(pwelch(a_ns_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            spcData.A_ew=sqrt(pwelch(a_ew_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            spcData.A_ud=sqrt(pwelch(a_ud_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            
            spcData.V_ns=sqrt(pwelch(v_ns_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            spcData.V_ew=sqrt(pwelch(v_ew_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            spcData.V_ud=sqrt(pwelch(v_ud_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);

            spcData.X_ns=sqrt(pwelch(x_ns_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            spcData.X_ew=sqrt(pwelch(x_ew_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            spcData.X_ud=sqrt(pwelch(x_ud_w,window_len,overlap_len,spcData.f,avxData.fs,'twosided','psd')).*(512/N);
            
        case 'aryule'
            spcData.A_ns=sqrt(pyulear(a_ns_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
            spcData.A_ew=sqrt(pyulear(a_ew_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
            spcData.A_ud=sqrt(pyulear(a_ud_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
            
            spcData.V_ns=sqrt(pyulear(v_ns_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
            spcData.V_ew=sqrt(pyulear(v_ew_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
            spcData.V_ud=sqrt(pyulear(v_ud_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);

            spcData.X_ns=sqrt(pyulear(x_ns_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
            spcData.X_ew=sqrt(pyulear(x_ew_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
            spcData.X_ud=sqrt(pyulear(x_ud_w,spcSettings.aryule_p,spcData.f,avxData.fs,'twosided')).*(512/N);
        case 'dft'
            spcData.A_ns=abs(fft(a_ns_w,N)./N);
            spcData.A_ew=abs(fft(a_ew_w,N)./N);
            spcData.A_ud=abs(fft(a_ud_w,N)./N);
            
            spcData.V_ns=abs(fft(v_ns_w,N)./N);
            spcData.V_ew=abs(fft(v_ew_w,N)./N);
            spcData.V_ud=abs(fft(v_ud_w,N)./N);

            spcData.X_ns=abs(fft(x_ns_w,N)./N);
            spcData.X_ew=abs(fft(x_ew_w,N)./N);
            spcData.X_ud=abs(fft(x_ud_w,N)./N);
    end
    
    onesided=1:(floor(N/2)+1);
    
    spcData.f=spcData.f(onesided);
    
    spcData.A_ns=spcData.A_ns(onesided);
    spcData.A_ew=spcData.A_ew(onesided);
    spcData.A_ud=spcData.A_ud(onesided);
    
    spcData.V_ns=spcData.V_ns(onesided);
    spcData.V_ew=spcData.V_ew(onesided);
    spcData.V_ud=spcData.V_ud(onesided);
    
    spcData.X_ns=spcData.X_ns(onesided);
    spcData.X_ew=spcData.X_ew(onesided);
    spcData.X_ud=spcData.X_ud(onesided);
end