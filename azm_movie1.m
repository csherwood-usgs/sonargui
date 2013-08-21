% azm_movie1
% make a series of azimuth images using Matlab 2012 oe newer
 addpath('\Users\emontgomery\Documents\GitHub\sonargui\geom\')
 MCR13_960_geom
 azpath='C:\home\data\proc\960north_az_fan\azm_files\';
  azms=dir(azpath);
  knt=1;
  figure('Renderer','zbuffer');
surf(Z);
axis tight;
set(gca,'NextPlot','replaceChildren');
  % skip 5-08-13 file- no data
  for jj=4:length(azms)
      fn=[azpath azms(jj).name]
  for ik=1:12
      ik
    plot_azdataNative(fn, ik, instloc)
    pause (1)
    h=get(gcf);
    M(knt)=getframe(h);
    knt=knt+1;
    delete(h)
  end
  end
  movie2avi(M,'testAZout','compression','none')