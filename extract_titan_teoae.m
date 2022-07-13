function [TEOAE_data] = extract_titan_teoae(folder,filename,plotdata)
% MATLAB function to extract TEOAE data from Interacoustics Suite (3.4) Titan (2.0.6) exported xml file. Main code: extract_titan_teoae.m
% extract_titan_teoae(folder,filename,plotdata)
% folder = directory string
% filename = exported Titan .xml file string
% plotdata = 1 to plot data
% requires xml2struct by W. Falkena
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data=xml2struct([folder filename]);

% save filename to structure
TEOAE_data.filename=filename;

% save test ear to structure
TEOAE_data.ear=data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.EarSide;

% save band summary data to TEOAE_data structure
for nfreqs=1:length(data.SaData.Session.Test.Settings.Settings.LineSettings)
    TEOAE_data.TElevel(nfreqs)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.BandResults.Band{1, nfreqs}.Attributes.Signal);
    TEOAE_data.TEnoiselevel(nfreqs)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.BandResults.Band{1, nfreqs}.Attributes.Noise);
    TEOAE_data.TEcenterfreqs(nfreqs)=str2num(data.SaData.Session.Test.Settings.Settings.LineSettings{1, nfreqs}.CenterFrequency.Text);
    TEOAE_data.TEstartfreqs(nfreqs)=str2num(data.SaData.Session.Test.Settings.Settings.LineSettings{1, nfreqs}.StartFrequency.Text);
end

% save response waveform to TEOAE_data structure
for i=1:length(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.BufferA.Point)
    % buffer A data
    TEOAE_data.bufferAdataX(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.BufferA.Point{1, i}.X.Text);
    TEOAE_data.bufferAdataY(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.BufferA.Point{1, i}.Y.Text);
    % buffer B data
    TEOAE_data.bufferBdataX(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.BufferB.Point{1, i}.X.Text);
    TEOAE_data.bufferBdataY(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.BufferB.Point{1, i}.Y.Text);
end

% save probe data to TEOAE_data structure
for i=1:length(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.ProbeData.Point)
    % probe data (probe check)   
    TEOAE_data.probedataX(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.ProbeData.Point{1, i}.X.Text);
    TEOAE_data.probedataY(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.ProbeData.Point{1, i}.Y.Text);
    % oae data
    TEOAE_data.oaedataX(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.OaeData.Point{1, i}.X.Text);
    TEOAE_data.oaedataY(i)=str2num(data.SaData.Session.Test.Data.RecordedData{1, 1}.Measured.OaeData.Point{1, i}.Y.Text);
end

% plot data if plotdata == 1
if plotdata==1
    close all
    figure('position',[300 100 1000 500],'paperpositionmode','auto');
    subplot(1,2,1)
    % RESPONSE WAVEFORM
    plot(TEOAE_data.bufferBdataX,TEOAE_data.bufferAdataY,'r')
    hold on
    plot(TEOAE_data.bufferBdataX,TEOAE_data.bufferBdataY,'r--')
    xlim([min(TEOAE_data.bufferBdataX) max(TEOAE_data.bufferBdataX)])
    ylim([-.4 .4])
    xlabel('\bfTIME \rm(ms)','FontSize',15)
    ylabel('\bfmPA','FontSize',15)
    grid on
    % TE RESPONSE
    subplot(1,2,2)
    plot(TEOAE_data.TEcenterfreqs,TEOAE_data.TElevel,'r-o','MarkerSize',11,'LineWidth',1.5,'MarkerFaceColor','w')
    hold on
    plot(TEOAE_data.TEcenterfreqs,TEOAE_data.TEnoiselevel,'r-','MarkerSize',15)
    a=area(TEOAE_data.TEcenterfreqs,TEOAE_data.TEnoiselevel,-50);
    a(1).FaceColor = [111 111 111]/256;
    alpha(.2)
    plot(TEOAE_data.TEcenterfreqs,TEOAE_data.TEnoiselevel,'r-','MarkerSize',15)
    xlabel('\bfFREQUENCY \rm(Hz)','FontSize',15)
    ylabel('\bfTEOAE \rm(dB SPL)','FontSize',15)
    ylim([min(TEOAE_data.TEnoiselevel)-5 max(TEOAE_data.TElevel)+5])
    ylim([-25 15])
    grid on
end
end