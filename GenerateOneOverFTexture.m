function [lft,rft,lftS,rftS] = GenerateOneOverFTexture(stdeviation,dsp,imgSize1,imgSize2,optionalplotForStereogram)
% Generates i.i.d binary texture for the left image shifts it by the amount
% of disparity to generate right image
%   Size is always doubled and later reduced to avoid any artifcat related
%   withcirc shift. Use even numbers for the size.
sz=imgSize1*2;
p1=stdeviation;
fil1f = mk_fourier_fil(imgSize1,1);

wnoise = rand(sz,sz); %wnoise = randn(sz,sz);
ftim = fftshift(fft2(fftshift(wnoise)));    % fourier transform image
ftim = fil1f.*ftim;                         % apply fourier filter
iftim = ifftshift(ifft2(ifftshift(ftim)));  % inverse fourier transform
mif = mean(mean(iftim));                    % mean of iftim
sd = sqrt( mean(mean(iftim.*iftim)) - mif^2 );
lft = (iftim-mif)*p1/sd ;

rft = circshift(lft,dsp,2);
lft=lft((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2):(imgSize2+imgSize2/2));
rft=rft((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2):(imgSize2+imgSize2/2));

if optionalplotForStereogram==1
    wnoise = rand(sz,sz); %wnoise = randn(sz,sz);
ftim = fftshift(fft2(fftshift(wnoise)));    % fourier transform image
ftim = fil1f.*ftim;                         % apply fourier filter
iftim = ifftshift(ifft2(ifftshift(ftim)));  % inverse fourier transform
mif = mean(mean(iftim));                    % mean of iftim
sd = sqrt( mean(mean(iftim.*iftim)) - mif^2 );
lftS = (iftim-mif)*p1/sd ;

rftS = lftS;

lftS((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2):(imgSize2+imgSize2/2))=lft;
rftS((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2)+dsp:(imgSize2+imgSize2/2)+dsp)=lft;
figure; sgtitle('Texture and Surround');
 subplot(1,2,1);imagesc(lftS);colormap gray; axis image; axis off; title('\fontsize{16} Left');
        subplot(1,2,2);imagesc(rftS);colormap gray; axis image; axis off; title('\fontsize{16} Right');
        set(gcf,'units','centimeters','position',[1,1,30,12])    
        else
    lftS=0;
    rftS=0;
end
end

