function [ear,frequencies,dB_HL,masked_dB_HL,transducer] = extract_puretonethresholds(filename)
%extract_puretonethresholds Function for extracting pure-tone thresholds from Interacoustics Equinox Suite exported xml file. 
% Requires xml2struct found on file exchange.

% convert xml to structure
data=xml2struct(filename);
% relevant data
data=data.SaData.Session.Test.Data.RecordedData.Measured;

% for ncon number of conditions
for ncon=1:size(data,2)
    % for nfreq number of test frequencies
    for nfreq=1:size(data{1, ncon}.Tone.TonePoint,2)
        conduction(ncon)=data{1, ncon}.Tone.ConductionTypes;
        ear(ncon)=string(data{1, ncon}.Tone.Earside.Text);
        frequencies(nfreq,ncon)=str2double(data{1, ncon}.Tone.TonePoint{1, nfreq}.Frequency.Text);
        dB_HL(nfreq,ncon)=str2double(data{1, ncon}.Tone.TonePoint{1, nfreq}.IntensityUT.Text);
        masked_dB_HL(nfreq,ncon)=str2double(data{1, ncon}.Tone.TonePoint{1, nfreq}.IntensityMT.Text);
        transducer(nfreq,ncon)=string(data{1, ncon}.Tone.TonePoint{1, nfreq}.Transducer.Text);
    end
end

% replace blanks with NaNs
frequencies(frequencies==-2.147483648000000e+09)=NaN;
dB_HL(dB_HL==-2.147483648000000e+09)=NaN;
masked_dB_HL(masked_dB_HL==-2.147483648000000e+09)=NaN;
% NaN out where frequencies not tested
dB_HL(frequencies==0)=NaN;
masked_dB_HL(frequencies==0)=NaN;
frequencies(frequencies==0)=NaN;
end