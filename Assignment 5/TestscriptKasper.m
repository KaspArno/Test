clear all, close all
addpath(genpath('C:\Users\Kasper\SkyDrive\Dokumenter\Skole-KaspArno\Vår 2016\Geg3340\scripts'));

dem1 = getTiff('Aster');
dem2 = getTiff('SRTM');

dem1.Z(dem1.Z<0) = NaN;
dem2.Z(dem2.Z<0) = NaN;

areal = 90*90; %Areal pr piksel

myshape = shaperead('maskIsbre');

dem(dem1); %Figure 1
title('DEM1');

figure, dem(dem2); %Figure 2
title('DEM2');

% Legger inn korrigerings vektor og matrise for SRTM
load('grpstats_50m.mat') % Henter Cbånd-Xbånd statestikk
SRTM_Korr = getTiff('Cband_minus_Xband_filt.tif');

Cband_Kor.Z = mytable(:,1);
Cband_Kor.mean = mytable(:,2);
Cband_Kor.median = mytable(:,3);
Cband_Kor.numel = mytable(:,4);

% Cband_Kor.mean(Cband_Kor.mean>0) = 0;
% Cband_Kor.mean(Cband_Kor.median>0) = 0;

% figure, hist(dem1.Z(:),100); %Figure 3
% title('Histogramm, ant piksler i høyde');
% xlabel('Høyde');
% ylabel('ant piksler');


% make figure
figure, hold on % Figure 4
    imagesc(dem1.x,dem1.y,dem1.Z); axis xy
    plot([myshape.X],[myshape.Y],'r-')
    title('Høydemodell med isbre mask');
    colorbar;
hold off

% make binary mask of shapefile
mymask = makeBinMask(dem1.x,dem1.y,myshape,1);
figure, imagesc(mymask); %Figure 5
title('mymask');


% remove land/ice example

dem1_land = dem1;
dem1_ice = dem1;

dem1_land.Z(mymask)=NaN;
dem1_ice.Z(~mymask)=NaN;


% calculate difference

   [X,Y] = meshgrid(dem1.x,dem1.y);
      [Z] = interp2(dem2.x,dem2.y,dem2.Z,X,Y,'linear');
         dem2a.x = dem1.x;
         dem2a.y = dem1.y;
         
         dem2a.Z = Z;
            clear X Y Z

    mydiff = dem1_land.Z - dem2a.Z;           
        mydiff(abs(mydiff)>60)=NaN;
    figure, imagesc(mydiff,[-60 60]); colormap('gray'); %Figure 6
    title('Differanse land (første utkast)');
    colorbar;

% Calculate slope and aspect
    [slp,asp] = CalcSlopeAspect(dem1.Z,nanmean(diff(dem1.x)));

% fitting routing
    [myshift] = Fitting_routine(mydiff(:),slp(:),asp(:),'mytest'); %Figure 7
%     tanmean = tand(asp);
%     tanmean(tanmean == Inf) = NaN;
%     tanmean(tanmean == -Inf) = NaN;
%     tanmean = nanmean(nanmean(tanmean));
    tanmean = tand(nanmean(nanmean(asp)));
    %nanmean(nanmean(mydiff))/tanmean
    %nanmean(nanmean(mydiff))/nanmean(nanmean(asp))
    
    % adjust dem
        dem2b = dem2a;
        dem2b.x = dem2b.x + myshift.x_adj;
        dem2b.y = dem2b.y + myshift.y_adj;
        dem2b.Z = dem2b.Z + myshift.z_adj;    
    
   [X,Y] = meshgrid(dem1.x,dem1.y); 
    [Z] = interp2(dem2b.x,dem2b.y,dem2b.Z,X,Y,'linear');
         dem2c.x = dem1.x;
         dem2c.y = dem1.y;
         dem2c.Z = Z;
            clear X Y Z

        mydiff2 = dem1_land.Z - dem2c.Z;           
            mydiff2(abs(mydiff2)>60)=NaN;
            figure, imagesc(mydiff2,[-60 60]); colormap('gray'); %Figure 8
            title('Differanse land (andre utkast)');
            colorbar;
    
    [myshift2] = Fitting_routine(mydiff2(:),slp(:),asp(:),'mytest'); %Figur 9
    %nanmean(nanmean(mydiff2))/tanmean
    %nanmean(nanmean(mydiff2))/nanmean(nanmean(asp))
    
    % adjust dem (Shoud this be done?
        dem2c = dem2b;
        dem2c.x = dem2c.x + myshift2.x_adj;
        dem2c.y = dem2c.y + myshift2.y_adj;
        dem2c.Z = dem2c.Z + myshift2.z_adj;
        
        mydiff3 = dem1_land.Z - dem2c.Z;
        mydiff3(abs(mydiff3)>60) = NaN;
        
        [myshift3] = Fitting_routine(mydiff3(:),slp(:),asp(:),'mytest'); %Figur 9

        mymean = nanmean(mydiff3(:));
        mymedian = nanmedian(mydiff3(:));
        mystd = nanstd(mydiff3(:));
        mynumel = numel(mydiff3(find(isnan(mydiff3))==0));
        
% Finner dirkete differanse mellom terreng modellene
    dem1_ice.Z(dem1_ice.Z < 0) = NaN;
    dem2c.Z(dem2c.Z < 0) = NaN;
    iceDiff = dem1_ice.Z - dem2c.Z;
    iceDiff(abs(iceDiff) > 200) = NaN;
    diffRes = iceDiff;
    diffRes(isnan(diffRes)) = 0;
    
    dem2c_ice = dem2c;
    dem2c_ice.Z(~mymask) = NaN;
    dem2c_ice.Z(dem2c_ice.Z<400) = NaN;
    dem2c_land = dem2c;
    dem2c_land.Z(mymask) = NaN;
    
%     dem2c_dem1 = dem2c.Z;
%     dem2c_dem1(isnan(dem1.Z)) = NaN;
%     
%     dem1_dem2c = dem1.Z;
%     dem1_dem2c(isnan(dem2c)) = NaN;
    
    figure,hold on
        imagesc(dem1.x,dem1.y,iceDiff); axis xy
        plot([myshape.X],[myshape.Y],'r-')
        title('Høydemodell med isbre mask');
        colorbar;
    hold off
    
    diffRes = nansum(nansum(diffRes*90*90))*10^-9;
    
    figure, plot(dem2c.Z(mymask),iceDiff(mymask), '.'); %Figur 10
    %figure, plot(dem1.Z(mymask),mydiff(mymask), '.'); %endring over høyde
    title('Endring over høyde');
    xlabel('høyde (meter)');
    ylabel('dh (meter)');
    

% Finner endring basert på  lineær regresjon
    %p1 = 0.041354; Endret pga økte intervallet til iceDiff
    %p2 = -80.566;
%     p1 = 0.0369;
%     p2 = -75.058;
%     z = linspace(min(min(dem1_ice.Z)), max(max(dem1_ice.Z)), 100); %høyde z 
%     dh = p1.*z+p2; %høydeendring gitt av høyde z 
%     Az = hist(dem1_ice.Z(:), 100); %antall piksler i gitt høyde z 
%     Az = Az.*(90*90); % setter areale for den høyden  
%     dV = dh.*Az; % finner vulum endringen    
%     linRes1 = sum(dV);
    
    %figure, hist(dem1_ice.Z(:), 100); %Lager histogramm av isbree
        title('Histogram, Folgefonna');
        ylabel('antall piksler');
        xlabel('Høyde');
    
% Finner endring basert på polynomal regeresjon
%     p1 = 7.3087e-05;
%     p2 = -0.1624;
%     p3 = 59.176;
%     dh = p1.*z.^2 + p2.*z + p3;
%     
%     dV2 = dh.*Az;
%     dV2 = sum(dV2)*10^-9;
    
% Finner endring basert på gjennomsnitts høydeenring

    snitt = nanmean(nanmean(iceDiff));
    meanRes = snitt*sum(mymask(:))*areal*1e-9;
    
    


%Lag filer som akn brukes i arcGIS
% dem_diff = dem1;
% dem_diff.Z = iceDiff;
% my_geotiffwrite(dem_diff, 'demDiff', 32632);
% my_geotiffwrite(dem2c, 'SRTMadj', 32632);

% Antall hull i aster
antHull = dem1_ice.Z;
antHull(~mymask) = 0;
antHull(~isnan(antHull)) = 0;
antHull(isnan(antHull)) = 1;
antHull = sum(antHull(:));
prosentHull = (antHull/sum(mymask(:)))*100;

% Error

landmask = (mymask-1)*-1;
Sd = nanmean(mydiff(:))/sum(landmask(:)); %Standard derivation, stander avvik
SE = Sd/sum(mymask(:)); % Standar error, gjennonsnittsfeil


%% Finn resultatene for hver fonn


% Lag Hypsometri?

hypsometri = dem1_ice.Z;
hypsometri(hypsometri<400) = nan; %LLaveste brearm
%figure, hypsometri = hypsometry(hypsometri, [0 1]); %Hypsometrisk kurve over isbreen
hypsometri = sort(reshape(hypsometri,1,numel(hypsometri)), 'descend');
hypsometri(isnan(hypsometri)) = [];
% figure, plot(linspace(0,100,numel(hypsometri)), hypsometri);
%     title('Hypsometrisk kurve, Folgefonna');
%     xlabel('% over Høyde');
%     ylabel('Høyde');
    

% Plot sum, diff og median mot høyde intervaller

intervall = 50;
% X = (750-intervall:intervall:1760);
outmat = floor(dem2c_ice.Z./intervall).*intervall;


imedian = grpstats(iceDiff(:),outmat(:),'nanmedian'); %numel antall elemeter %improfile hent profil av matrie
isum = grpstats(iceDiff(:),outmat(:),'nansum');
imean = grpstats(iceDiff(:),outmat(:),'nanmean');
inumel = grpstats(mymask(:),outmat(:),'nansum');
iMeanRes = nansum(((grpstats(mymask(:),outmat(:),'nansum')).*imean))*areal*1e-9;

% X = unique(outmat(:));
% X(isnan(X)) = [];
% isum(X == 0) = [];
% imean(X == 0) = [];
% imedian(X == 0) = [];
% X(X == 0) = [];  
% 
% figure, plot(X, isum), grid on, title('Sum pr høyde (intervall 50')
% figure, plot(X, imean), grid on, title('Gjennomnsitt pr høyde')
% figure, plot(X, imedian), grid on, title('Median pr høyde')
% figure, plot(dem1.Z(mymask),iceDiff(mymask), '.'), title('Folgefonna');
%     hold on
%     grid on
%     plot(X, imean)
%     hold off


% Finn resultatene for hver fonn

% Henter masker for hver fonn og lager terrengmodeller for fonnene
    sorshape = shaperead('Sørfonna');
    nordshape = shaperead('Nordfonna');
    midtshape = shaperead('Midtfonna');

    %lager individuelle masker
    sormask = makeBinMask(dem1.x,dem1.y,sorshape,1);
    nordmask = makeBinMask(dem1.x,dem1.y,nordshape,1);
    midtmask = makeBinMask(dem1.x,dem1.y,midtshape,1);

    %lager indivudueller terrengmodeller
    dem1_sor = dem1;
    dem1_nor = dem1;
    dem1_midt = dem1;

    dem1_sor.Z(~sormask)=NaN;
    dem1_nor.Z(~nordmask)=NaN;
    dem1_midt.Z(~midtmask)=NaN;

    dem1_sor.Z(dem1_sor.Z<0) = NaN;
    dem1_nor.Z(dem1_nor.Z<0) = NaN;
    dem1_midt.Z(dem1_midt.Z<0) = NaN;
    
    dem2c_sor = dem2c;
    dem2c_nor = dem2c;
    dem2c_midt = dem2c;

    dem2c_sor.Z(~sormask)=NaN;
    dem2c_nor.Z(~nordmask)=NaN;
    dem2c_midt.Z(~midtmask)=NaN;

    dem2c_sor.Z(dem2c_sor.Z<0) = NaN;
    dem2c_nor.Z(dem2c_nor.Z<0) = NaN;
    dem2c_midt.Z(dem2c_midt.Z<0) = NaN;

    %finner differansen for hver fonn
    sorDiff = iceDiff;
    sorDiff(~sormask) = NaN;

    norDiff = iceDiff;
    norDiff(~nordmask) = NaN;

    midtDiff = iceDiff;
    midtDiff(~midtmask) = NaN;

    %Reklassifiserer høydene innenfor gitt intevall
    outmat_sor = floor(dem2c_sor.Z./intervall).*intervall;
    outmat_nor = floor(dem2c_nor.Z./intervall).*intervall;
    outmat_midt = floor(dem2c_midt.Z./intervall).*intervall;

% Plotter endringen i hver fonn mot høyden (nødvendig for regresjon
    %figure, plot(dem2c.Z(sormask),iceDiff(sormask), '.'), title('Sørfonna');
    %figure, plot(dem2c.Z(nordmask),iceDiff(nordmask), '.'), title('Nordfonna');
    %figure, plot(dem2c.Z(midtmask),iceDiff(midtmask), '.'), title('Midtfonna');

% Differanse, gjennomsnitt og median resultat

    %metoden gjør beregninger for hver klasse, definert av outmat
    sorsum = grpstats(sorDiff(:),outmat_sor(:),'nansum');
    norsum = grpstats(norDiff(:),outmat_nor(:),'nansum');
    midtsum = grpstats(midtDiff(:),outmat_midt(:),'nansum');

    sormedian = grpstats(sorDiff(:),outmat_sor(:),'nanmedian');
    normedian = grpstats(norDiff(:),outmat_nor(:),'nanmedian');
    midtmedian = grpstats(midtDiff(:),outmat_midt(:),'nanmedian');

    sormean = grpstats(sorDiff(:),outmat_sor(:),'nanmean');
    normean = grpstats(norDiff(:),outmat_nor(:),'nanmean');
    midtmean = grpstats(midtDiff(:),outmat_midt(:),'nanmean');
    
    sornumel = grpstats(sorDiff(:),outmat_sor(:),'numel');
    nornumel = grpstats(norDiff(:),outmat_nor(:),'numel');
    midtnumel = grpstats(midtDiff(:),outmat_midt(:),'numel');
    
    sorLinMean = nansum(((grpstats(sormask(:),outmat_sor(:),'nansum')).*sormean))*areal*1e-9;
    norLinMean = nansum(((grpstats(nordmask(:),outmat_nor(:),'nansum')).*normean))*areal*1e-9;
    midtLinMean = nansum(((grpstats(midtmask(:),outmat_midt(:),'nansum')).*midtmean))*areal*1e-9;
    
    sorMeanRes = nanmean(sorDiff(:))*sum(sormask(:))*areal*1e-9;
    norMeanRes = nanmean(norDiff(:))*sum(nordmask(:))*areal*1e-9;
    midtMeanRes = nanmean(midtDiff(:))*sum(midtmask(:))*areal*1e-9;
    

% Lineær differanse (dobbeltsjekk at det kan gjøres på denne måten)

    % Folgefonna    
        p1 = 0.035953;
        p2 = -73.762;
        linEndring = p1.*(outmat+(intervall/2)) + p2;
        linVol = linEndring*areal;
        linRes = nansum(nansum(linVol))*1e-9;

    % Sørfonna  
        p1 = 0.035199;
        p2 = -72.928;
        linEndringSor = p1.*outmat_sor + p2;
        linVolSor = linEndringSor*areal;
        sorLinRes = nansum(nansum(linVolSor))*1e-9;
    
    % Nordfonna
        p1 = 0.041632;
        p2 = -80.571;
        linEndringNor = p1.*outmat_nor + p2;
        linVolNor = linEndringNor*areal;
        norLinRes = nansum(nansum(linVolNor))*1e-9;
    
    % MidtFonna
        p1 = 0.0035765;
        p2 = -26.948;
        linEndringMidt = p1.*outmat_midt + p2;
        linVolMidt = linEndringMidt*areal;
        midtLinRes = nansum(nansum(linVolMidt))*1e-9;
    
% Plot

    % Folgefonna
        X = unique(outmat(:));
        X(isnan(X)) = [];
        isum(X == 0) = [];
        imean(X == 0) = [];
        imedian(X == 0) = [];
        X(X == 0) = [];  

        %figure, plot(X, isum), grid on, title('Sum pr høyde (intervall 50')
        %figure, plot(X, imean), grid on, title('Gjennomnsitt pr høyde')
        %figure, plot(X, imedian), grid on, title('Median pr høyde')
        figure, plot(dem2c.Z(mymask),iceDiff(mymask), '.'), title('Folgefonna');
            hold on
            grid on
            plot(X+(intervall/2), imean)
        hold off

    % Sørfonna
        Xsor = unique(outmat_sor(:));
        Xsor(isnan(Xsor)) = [];
        sorsum(Xsor == 0) = [];
        sormean(Xsor == 0) = [];
        sormedian(Xsor == 0) = [];
        Xsor(Xsor == 0) = [];   
        %figure, plot(Xsor, sorsum), grid on, title('Sørfonna, sum pr høyde'),
        %figure, plot(Xsor, sormean), grid on, title('Sørfonna, gjennomnsitt pr høyde'),
        %figure, plot(Xsor, sormedian), grid on, title('Sørfonna, median pr høyde'),       
        %figure, plot(Xsor, sorsum*90*90*1e-9), grid on, title('Sørfonna, Volum pr høyde'),
        figure, plot(dem2c.Z(sormask),iceDiff(sormask), '.'), title('Sørfonna');
            hold on
            grid on
            plot(Xsor+(intervall/2), sormean)
            legend('dh pr piksel','mean', 'location', 'northwest')
            xlabel('moh')
            ylabel('dh (meter)')
        hold off

    % Nordfonna 
        Xnor = unique(outmat_nor(:));
        Xnor(isnan(Xnor)) = [];
        norsum(Xnor == 0) = [];
        normean(Xnor == 0) = [];
        normedian(Xnor == 0) = [];
        Xnor(Xnor == 0) = [];  
        %figure, plot(Xnor, norsum), grid on, title('Nordfonna, sum pr høyde'),
        %figure, plot(Xnor, normean), grid on, title('Nordfonna, gjennomnsitt pr høyde'),
        %figure, plot(Xnor, normedian), grid on, title('Nordfonna, median pr høyde'),
        figure, plot(dem2c.Z(nordmask),iceDiff(nordmask), '.'), title('Nordfonna');
            hold on
            grid on
            plot(Xnor+(intervall/2), normean)
            legend('dh pr piksel','mean', 'location', 'northwest')
            xlabel('moh')
            ylabel('dh (meter)')
            hold off
    
    % Midtfonna
        Xmidt = unique(outmat_midt(:));
        Xmidt(isnan(Xmidt)) = [];
        midtsum(Xmidt == 0) = [];
        midtmean(Xmidt == 0) = [];
        midtmedian(Xmidt == 0) = [];
        Xmidt(Xmidt == 0) = [];  
        %figure, plot(Xmidt, midtsum), grid on, title('Midtfonna, sum pr høyde'),
        %figure, plot(Xmidt, midtmean), grid on, title('Midtfonna, gjennomnsitt pr høyde'),
        %figure, plot(Xmidt, midtmedian), grid on, title('Midtfonna, median pr høyde'),
        figure, plot(dem1.Z(midtmask),iceDiff(midtmask), '.'), title('Midtfonna');
            hold on
            grid on
            plot(Xmidt+(intervall/2), midtmean)
            legend('dh pr piksel','mean', 'location', 'northwest')
            xlabel('moh')
            ylabel('dh (meter)')
            hold off
            
% Felles plott

    % Folgefonna
    figure, hold on
        plot(dem2c.Z(mymask),iceDiff(mymask), '.')
        plot(X+(intervall/2), imean,'linewidth', 2)
        legend('Folgefonna','Gjennonsitts endring')
        grid on
    hold off
        
    %sum plott
    figure
        plot(X+(intervall/2), isum)
        hold on
        plot(Xsor+(intervall/2), sorsum)
        plot(Xnor+(intervall/2), norsum)
        plot(Xmidt+(intervall/2), midtsum)
        xlabel('moh')
        ylabel('dh (meter)')
        title('Folgefonna (sum)')
        legend('Folgefonna','Sørfonna','Nordfonna','Midtfonna','Location','southwest')
        grid on
    hold off
    
    %mean plott
    figure
        plot(X+(intervall/2), imean)
        hold on
        plot(Xsor+(intervall/2), sormean)
        plot(Xnor+(intervall/2), normean)
        plot(Xmidt+(intervall/2), midtmean)
        xlabel('moh')
        ylabel('dh (meter)')
        title('Folgefonna (mean)')
        legend('Folgefonna','Sørfonna','Nordfonna','midtfonna','Location','northwest')
        grid on
    hold off

    %median plott
    figure
        plot(X+(intervall/2), imedian)
        hold on
        plot(Xsor+(intervall/2), sormedian)
        plot(Xnor+(intervall/2), normedian)
        plot(Xmidt+(intervall/2), midtmedian)
        xlabel('moh')
        ylabel('dh (meter)')
        title('Folgefonna (median)')
        legend('Folgefonna','Sørfonna','Nordfonna','midtfonna','Location','northwest')
        grid on
    hold off
    
    % dh over h plott
    figure
        hold on
        plot(dem2c.Z(mymask), iceDiff(mymask), '.','Color','w')
        plot(dem2c.Z(sormask),iceDiff(sormask),'.','Color',[0.5 0.5 1])
        plot(dem2c.Z(nordmask),iceDiff(nordmask), '.','Color',[1 0.5 0.5])
        plot(dem2c.Z(midtmask),iceDiff(midtmask), '.','Color',[0.5 1 0.5])
        plot(Xsor+(intervall/2), sormean,'linewidth',2,'Color',[0 0 0.7])
        plot(Xnor+(intervall/2), normean,'linewidth',2,'Color',[0.7 0 0])
        plot(Xmidt+(intervall/2), midtmean,'linewidth',2,'Color',[0 0.7 0])
        title('Folgefonna dh over høyde')
        xlabel('moh')
        ylabel('dh (meter)')
        legend('Folgefonna','Sørfonna','Nordfonna','Midtfonna','Sør mean','Nord mean','Midt mean','location','northwest')
        grid on
    hold off
    
    % Multiple plot i 1 figur
    
    figure
        subplot(2,2,1)       
            plot(dem2c.Z(midtmask),iceDiff(midtmask), '.')
            hold on
            %lsline
            plot(Xmidt+(intervall/2), midtmean,'linewidth', 2)
            title('Midtfonna')
            ylabel('dh (meter)')
            xlabel('h')
            legend('hvert punkt','gjennomsnitt','location','northwest')
            %hline(0,'k')
            grid on
        hold off

        subplot(2,2,2)      
            plot(dem2c.Z(nordmask),iceDiff(nordmask), '.')
            hold on
            %lsline
            plot(Xnor+(intervall/2), normean,'linewidth', 2)
            title('Nordfinna')
            ylabel('dh (meter)')
            xlabel('h')
            legend('hvert punkt','gjennomsnitt','location','northwest')
            %hline(0,'k')
            grid on
        hold off
            
       subplot(2,2,3)      
            plot(dem2c.Z(sormask),iceDiff(sormask), '.')
            hold on
            %lsline
            plot(Xsor+(intervall/2), sormean,'linewidth', 2)
            title('Sørfonna')
            ylabel('dh (meter)')
            xlabel('h')
            legend('hvert punkt','gjennomsnitt','location','northwest')
            %hline(0,'k')
            grid on
        hold off
            
      subplot(2,2,4)      
            plot(dem2c.Z(mymask),iceDiff(mymask), '.')
            hold on
            %lsline
            plot(X+(intervall/2), imean,'linewidth', 2)
            %hline(0,'k')
            title('Folgefonna')                                                                                            
            ylabel('dh (meter)')
            xlabel('h')
            legend('hvert punkt','gjennomsnitt','location','northwest')
            %hline(0,'k')
            grid on
        hold off
        
        
        % Histogramm Areal av bree
        
        figure, hist(dem2c_ice.Z(mymask),100)
            title('Folgefonna ant piksler i høyde (SRTM)');
            xlabel('moh')
            ylabel('piksler')
        figure, hist(dem1_ice.Z(mymask),100)
            title('Folgefonna 2014, ant piksler i høyde');
            xlabel('moh')
            ylabel('piksler')
        
        figure, hist(iceDiff(mymask),100)
            title('ant piksler i dh');
            xlabel('dh (meter)')
            ylabel('piksler')

        
%% Finn resultat med korrigert SRTM

kormask = makeBinMask(SRTM_Korr.x,SRTM_Korr.y,sorshape,1); %mask for kor
    
    % Folgefonna
    iMeanKor = imean;
    iMeanKor = iMeanKor(X>=min(Cband_Kor.Z));
    iMeanKor = iMeanKor + Cband_Kor.mean;
    iMeanNoneKor = imean(X<=1050); % Cband_Kor.mean er NaN fra 1050 og nedover
    iNumelNoneKor = inumel(X<=1050);
    iMeanResNoneKor = iMeanNoneKor.*iNumelNoneKor;
    iMeanKorRes = (nansum(iMeanKor.*inumel(X>=950)) + nansum(iMeanResNoneKor))*areal*1e-9;


    figure, hold on
        plot(X,imean)
        plot(Cband_Kor.Z, iMeanKor)
        title('Korrigert differanse og ukorrigert differanse (Folgefonna)')
        xlabel('moh')
        ylabel('dh (meter)')
        legend('Ukorrigert', 'Korrigert', 'Location', 'southeast')
        grid on
        grid minor
    hold off
    
    kormask2 = SRTM_Korr.Z(:);
    kormask2(~isnan(kormask2)) = 1;
    
    KorMean = nanmean(SRTM_Korr.Z(:)) + nanmean(iceDiff(:));
    KorMeanRes = KorMean*nansum(mymask(:))*areal*1e-9;
    
    KorProsent = abs((iMeanRes-iMeanKorRes)/iMeanRes)*100;
    KorProsentMean = abs((meanRes-KorMeanRes)/meanRes)*100;
    
    
    % Sørfonna
    sorMeanKor = sormean;
    sorMeanKor = sorMeanKor(Xsor>=min(Cband_Kor.Z));
    sorMeanKor = sorMeanKor + Cband_Kor.mean;
    sorMeanNoneKor = sormean(Xsor<=1050);
    sorNumelNoneKor = sornumel(Xsor<=1050);
    sorMeanResNoneKor = sorMeanNoneKor.*sorNumelNoneKor;
    sorMeanKorRes = (nansum(sorMeanKor.*sornumel(Xsor>=950)) + nansum(sorMeanResNoneKor))*areal*1e-9;

    figure, hold on
        plot(Xsor,sormean)
        plot(Cband_Kor.Z, sorMeanKor)
    hold off
    
    tempMask = makeBinMask(SRTM_Korr.x,SRTM_Korr.y,sorshape,1);
    
    sorKorMean = nanmean(SRTM_Korr.Z(tempMask)) + nanmean(sorDiff(:));
    sorKorMeanRes = KorMean*sum(tempMask(:))*areal*1e-9;
    
    sorKorProsent = abs((sorLinMean-sorMeanKorRes)/sorLinMean)*100;
    sorKorProsentMean = abs((sorMeanRes-sorKorMeanRes)/sorMeanRes)*100;
    
    
%% Make profile
    
    %S = shaperead('C:\Users\Kasper\OneDrive\Dokumenter\Skole-KaspArno\Vår 2016\Geg3340\Profile.shp');
%     S = shaperead('C:\Users\Kasper\OneDrive\Dokumenter\Skole-KaspArno\Vår 2016\Geg3340\Profil2.shp');
    S = shaperead('C:\Users\Kasper\OneDrive\Dokumenter\Skole-KaspArno\Vår 2016\Geg3340\Bearbeidet data\breLine.shp');
   
    mydh = dem1;
%     mydh.Z = nanmedfilt2(mydh.Z);
%     mydh.Z = mydh.Z-dem2c.Z;
    mydh.Z = dem1.Z-dem2c.Z;    
 

    Legend = cell(length(S),1);
    dist = zeros(1,length(S));

    for i = 1:length(S);
        x = S(i).X;
        y  = S(i).Y;

        [x2,y2,~] = improfile(mydh.x,mydh.y,mydh.Z,x(1:end-1),y(1:end-1),100);
        S(i).X2 = x2;
        S(i).Y2 = y2;
        
        S(i).dh = interp2(mydh.x,mydh.y,mydh.Z,x2,y2,'linear');
        
        z = interp2(dem1.x,dem1.y,dem1.Z,S(i).X2,S(i).Y2,'linear');
        z2 = interp2(dem2c.x,dem2c.y,dem2c.Z,S(i).X2,S(i).Y2,'linear');
        
        S(i).dem1 = z;
        S(i).dem2 = z2;
   
        mydist1 = sqrt(diff(x2).^2+diff(y2).^2);
        mydist2 = cumsum(mydist1);
        S(i).dist = mydist2;

        Legend{i} = S(i).Name;
        
    end
    
    figure,
        dem(dem1)
        hold on
        for i = 1:length(S)
            plot([S(i).X],[S(i).Y],'Linewidth',2)
        end
        legend(Legend, 'Location', 'southeast')
    hold off
    
    figure, imagesc(mydh.x,mydh.y,iceDiff); axis xy 
        hold on
        for i = 1:length(S)
            plot([S(i).X],[S(i).Y],'Linewidth',2)
        end
        legend(Legend, 'Location', 'southeast')
    hold off
   

    for i = 1:length(S)
        figure('name',S(i).Name,'numbertitle','off')
        subplot(2,1,1)
            hold on 
            
            plot(S(i).dist,S(i).dem1(2:end), 'Linewidth',2)
            plot(S(i).dist,S(i).dem2(2:end), 'Linewidth',2)
            
            xlim([S(i).dist(1) S(i).dist(end)])
            
            legend('ASTER 2014', 'SRTM 2000','Location', 'southeast')
            Title = strcat({'Profil: '}, S(i).Name);
            title(Title)
            xlabel('Meter')
            ylabel('moh')
            grid on
            grid minor     
        hold off
        
        subplot(2,1,2)
            plot (S(i).dist, S(i).dh(2:end), 'Linewidth', 2)
            xlim([S(i).dist(1) S(i).dist(end)])
            Title = strcat({'Profil (dh): '}, S(i).Name);
            title(Title)
            xlabel('Meter')
            ylabel('dh (meter)')
            grid on
            grid minor
    end

%% Make table

    fonner = {'Midtfonna';'Nordfonna';'Sørfonna';'Folgefonna'};
    Areal = [areal*sum(midtmask(:));areal*sum(nordmask(:));areal*sum(sormask(:));areal*sum(mymask(:))];
    Bunn = [min(dem1_midt.Z(:));min(dem1_nor.Z(:));min(dem1_sor.Z(:));min(dem1_ice.Z(:))];
    Topp = [max(dem1_midt.Z(:));max(dem1_nor.Z(:));max(dem1_sor.Z(:));max(dem1_ice.Z(:))];
    Intervall = Topp-Bunn;
    linear_regression = [midtLinRes;norLinRes;sorLinRes;linRes]; %Lineær differanse
    DiffRes = [nansum(midtDiff(:)*areal*1e-9);nansum(norDiff(:)*areal*1e-9);nansum(sorDiff(:)*areal*1e-9);diffRes]; %Differanse
    MeanRes = [midtMeanRes;norMeanRes;sorMeanRes;meanRes];
    Mean_intervals = [midtLinMean;norLinMean;sorLinMean;iMeanRes];
    Cor_intervals = [NaN;NaN;sorMeanKorRes;iMeanKorRes];
    Cor_mean = [NaN;NaN;sorKorMeanRes;KorMeanRes];
    Areal = Areal*1e-6;
    
    T = table(linear_regression,Mean_intervals,MeanRes,Cor_intervals,Cor_mean,'RowNames',fonner);
    
    %writetable(T3,'tabel3.xls','WriteRowNames',true)


     resultater = {'Linear_regression';'Mean_intervals';'Mean';'Cor_intervals';'Cor_mean'};
%     result = [DiffRes(4) LinRes(4) MeanRes(4) LinMeanRes(4)];
%     result2 = result';
%     m = [DiffRes LinRes MeanRes LinMeanRes];

    vektor = [linear_regression(4) Mean_intervals(4) MeanRes(4)  Cor_intervals(4) Cor_mean(4)];
    matrise = zeros(length(vektor));

    for i = 1:length(vektor)
        for j = 1:length(vektor)
            matrise(i,j) = vektor(i) - vektor(j);
        end
    end
    T2 = array2table(matrise,'VariableNames',resultater,'RowNames',resultater);
    
    prosentMatrise = matrise;
    for i = 1:length(vektor)
        for j = 1:length(vektor)
            prosentMatrise(i,j) = ((vektor(i) - vektor(j))/vektor(j))*100;
        end
    end
    T3 = array2table(prosentMatrise,'VariableNames',resultater,'RowNames',resultater);





    
    