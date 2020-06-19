function [lptch,rptch,lfi,rti] = AddNoise_CropPattches(leftTexture,rightTexture,noiseSigma,noiseType,pathHalfWidth,SearchHalfWidth,optionalplot)

phwr=(SearchHalfWidth+pathHalfWidth); % total right patch size
[sz1, sz2]=size(leftTexture);
                %add noise to stimuli 
                if noiseType==1
                %Gaussian Noise
                lfi = leftTexture + randn(sz1,sz2)*noiseSigma;   % left image
                rti = rightTexture + randn(sz1,sz2)*noiseSigma;   % right image
                elseif noiseType==2
                % 1/f Noise
                [noiseL, ~]=GenerateOneOverFTexture(noiseSigma,0,sz1,sz2,0);
                [noiseR, ~]=GenerateOneOverFTexture(noiseSigma,0,sz1,sz2,0);
                lfi = leftTexture + noiseL;
                rti = rightTexture + noiseR;
                end
                
                
                %patches
                lptch = lfi(sz1/2-pathHalfWidth:sz1/2+pathHalfWidth,sz2/2-pathHalfWidth:sz2/2+pathHalfWidth); % left patch
                rptch = rti(sz1/2-pathHalfWidth:sz1/2+pathHalfWidth,sz2/2-phwr:sz2/2+phwr); % right total patch
                
                
                %plot
                if optionalplot==1
                    figure; sgtitle('Texture with Noise');
                    
                    
                    
                    subplot(1,2,1);
yyaxis right
posvector=[ (sz2/2-pathHalfWidth) (sz1/2-pathHalfWidth) pathHalfWidth*2+1 pathHalfWidth*2+1];
rectangle('Position',posvector,'EdgeColor','b', 'LineWidth',3)
axis([1 sz1 1 sz2])

hold on
 yyaxis left
imagesc(lfi);colormap gray; axis off; title('\fontsize{16} Left');
set(gcf,'units','centimeters','position',[1,1,30,12])
axis([1 sz1 1 sz2])

subplot(1,2,2);
yyaxis right
posvector=[ (sz2/2-phwr) (sz1/2-pathHalfWidth) phwr*2+1 pathHalfWidth*2+1];
rectangle('Position',posvector,'EdgeColor','b', 'LineWidth',3)
axis([1 sz1 1 sz2])

hold on
 yyaxis left
imagesc(rti);colormap gray;axis off; title('\fontsize{16} Right');
set(gcf,'units','centimeters','position',[1,1,30,12])
axis([1 sz1 1 sz2])




                end
end

