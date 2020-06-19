function [lft,rft,lftS,rftS] = GenerateBinaryTexture(ScRate,dsp,imgSize1,imgSize2,optionalplotForStereogram)
% Generates i.i.d binary texture for the left image and shifts it by the amount
% of true disparity to generate right image
%   Size is always doubled and later reduced to the original size to avoid any artifcat related
%   withcirc shift. Use even numbers for the size.

% inputs are sucess rate of Bernouilli, true disparity, image size,
% optional plot argument
%outputs are left and right texture, left and right texture with background
%if and only if optional plot argument is 1.

lft=double((rand(imgSize1*2,imgSize2*2)<ScRate)); % double the image size
rft = circshift(lft,dsp,2); % use circshift to generate right image
lft=lft((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2):(imgSize2+imgSize2/2)); % reduce the size to original
rft=rft((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2):(imgSize2+imgSize2/2)); % reduce the size to original

% optional figure for the texture with background
if optionalplotForStereogram==1
lftS=double((rand(imgSize1*2,imgSize2*2)<ScRate)); % double size since background will be there
rftS=lftS; % double size since background will be there
lftS((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2):(imgSize2+imgSize2/2))=lft; % put the left image to its place 
rftS((1+imgSize1/2):(imgSize1+imgSize1/2),(1+imgSize2/2)+dsp:(imgSize2+imgSize2/2)+dsp)=lft; % put the left image to its place
% plot the ones with background
figure; sgtitle('Texture and Surround');
 subplot(1,2,1);imagesc(lftS);colormap gray; axis image; axis off; title('\fontsize{16} Left');
        subplot(1,2,2);imagesc(rftS);colormap gray; axis image; axis off; title('\fontsize{16} Right');
        set(gcf,'units','centimeters','position',[1,1,30,12])      
else
    lftS=0;
    rftS=0;
end
end

