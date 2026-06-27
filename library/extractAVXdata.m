function avxData = extractAVXdata(extractSettings, eqData)
    g2cms2=980.6;%cm/s2
    
    NN=size(eqData,2);
    
    avxData=cell(1,NN);
    for i=1:NN
        avxData{i}.stationName=eqData{i}.stationName;
        avxData{i}.fs=eqData{i}.fs;
        avxData{i}.ML=eqData{i}.ML;
        avxData{i}.latit=eqData{i}.latit;
        avxData{i}.longi=eqData{i}.longi;
        avxData{i}.epi_latit=eqData{i}.epi_latit;
        avxData{i}.epi_longi=eqData{i}.epi_longi;
        
        n_range=round(1+(eqData{i}.t-min(eqData{i}.t)).*avxData{i}.fs);
        avxData{i}.t=eqData{i}.t;
        avxData{i}.t_full=eqData{i}.t_full;

        %design filter
        [b,a] = butter(extractSettings.filter_order,extractSettings.filter_cutoff./(avxData{i}.fs/2), 'low');
        L=round(extractSettings.filter_cutoff); %upsampling coefficient
        M=round(avxData{i}.fs/2); %downsampling coefficient

        %acceleration data, pre-processing and airas intensity
        avxData{i}.a_ns=customFilter(b,a,eqData{i}.EQ_NS(n_range),eqData{i}.fs);
        avxData{i}.a_ns=customResample(avxData{i}.a_ns,L,M);
        avxData{i}.a_ew=customFilter(b,a,eqData{i}.EQ_EW(n_range),eqData{i}.fs);
        avxData{i}.a_ew=customResample(avxData{i}.a_ew,L,M);
        avxData{i}.a_ud=customFilter(b,a,eqData{i}.EQ_UD(n_range),eqData{i}.fs);
        avxData{i}.a_ud=customResample(avxData{i}.a_ud,L,M);

        %new axes and filter
        max_t=max(avxData{i}.t); min_t=min(avxData{i}.t);
        avxData{i}.t =linspace(min_t,max_t,floor((L/M).*size(avxData{i}.t,2)));
        avxData{i}.fs=1./(eps+mean(diff(avxData{i}.t)));
        avxData{i}.N=size(avxData{i}.t,2);
        
        max_t=max(avxData{i}.t_full); min_t=min(avxData{i}.t_full);
        avxData{i}.t_full =linspace(min_t,max_t,floor((L/M).*size(avxData{i}.t_full,2)));
        
        b=1;a=1;

        %arias intensity
        avxData{i}.Ia_ns=(pi./(2.*g2cms2)).*cumtrapz(avxData{i}.t, avxData{i}.a_ns.^2);
        avxData{i}.Ia_ew=(pi./(2.*g2cms2)).*cumtrapz(avxData{i}.t, avxData{i}.a_ew.^2);
        avxData{i}.Ia_ud=(pi./(2.*g2cms2)).*cumtrapz(avxData{i}.t, avxData{i}.a_ud.^2);

        %velocity is integral of acceleration in time plus initial velocity
        avxData{i}.v_ns=customFilter(b,a,cumtrapz(avxData{i}.t, avxData{i}.a_ns),avxData{i}.fs);
        avxData{i}.v_ew=customFilter(b,a,cumtrapz(avxData{i}.t, avxData{i}.a_ew),avxData{i}.fs);
        avxData{i}.v_ud=customFilter(b,a,cumtrapz(avxData{i}.t, avxData{i}.a_ud),avxData{i}.fs);

        %displacement is integral of velocity in time plus initial velocity
        avxData{i}.x_ns=customFilter(b,a,cumtrapz(avxData{i}.t, avxData{i}.v_ns),avxData{i}.fs);
        avxData{i}.x_ew=customFilter(b,a,cumtrapz(avxData{i}.t, avxData{i}.v_ew),avxData{i}.fs);
        avxData{i}.x_ud=customFilter(b,a,cumtrapz(avxData{i}.t, avxData{i}.v_ud),avxData{i}.fs);
    end
end

function y=customFilter(b,a,x,fs)
    fc=1.5;

    wc=fc./(fs/2);
    alpha=1-wc;

    b_=[alpha -alpha];
    a_=[1 -alpha];    
    
    H = freqz(b_,a_); 
    gain = 1./max(abs(H)); 
    
    v=gain.*filter(b_,a_,x);
    
    y=filter(b,a,v);
end

function y=customResample(x,L,M)
    G=gcd(L,M);
    L=ceil(L/G);M=ceil(M/G);
    
    N=size(x,2);
    z=zeros(1,max(L,M).*N);
    z(1+L.*(0:(N-1)))=x;
    Z=fft(z); Z(floor(N/2):floor(end-(N/2)))=0;
    z=L.*real(ifft(Z));
    y=z(1+M.*(0:(N-1)));
    y=y(1:floor((L/M).*N));
end
