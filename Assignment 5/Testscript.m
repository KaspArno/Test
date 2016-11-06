clear all, close all

dem1 = getTiff('DEM_AST_L1A_00309142014110751_20160202070855_4754');
dem2 = getTiff('AST14DMO_00302142002223906_20100218090518_4814_DEM');
myshape = shaperead('2002masks');

dem(dem1.x,dem1.y,dem.Z);

figure, hist(dem1.Z(:),100);

% make figure
figure, hold on
    imagesc(dem1.x,dem1.y,dem1.Z); axis xy
    plot([myshape.X],[myshape.Y],'r-')

% make binary mask of shapefile
mymask = makeBinMask(dem1.x,dem1.y,myshape,1);
figure, imagesc(mymask);


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

    mydiff = dem1.Z - dem2a.Z;           
        mydiff(abs(mydiff)>60)=NaN;
    figure, imagesc(mydiff,[-30 30]); colormap('gray');

% Calculate slope and aspect
    [slp,asp] = CalcSlopeAspect(dem1.Z,nanmean(diff(dem1.x)));

% fitting routing
    [myshift] = Fitting_routine(mydiff(:),slp(:),asp(:),'mytest');
    
    
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

        mydiff = dem1.Z - dem2c.Z;           
            mydiff(abs(mydiff)>60)=NaN;
            figure, imagesc(mydiff,[-30 30]); colormap('gray');
    
    [myshift] = Fitting_routine(mydiff(:),slp(:),asp(:),'mytest');
            
    
    