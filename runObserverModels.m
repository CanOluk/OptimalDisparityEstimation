function [dcc,dse,dNcc,dop,dccB] = runObserverModels(stt)
% Outputs disparity estimate of observer model in each trial as a vector, input is the
% settings of the simulations.

% neccesary calculations for the ideal observers
sigma_t=sqrt(stt.sgnModel^2+stt.sgtModel^2); % standard deviation of the marginal gaussian, sigma_t
km = 1/(2*sigma_t^2); % marginal distrbution
p_c=stt.sgtModel^2/(stt.sgnModel^2+stt.sgtModel^2); % joint distrbution bivariate gaussian
kl= 1/ (2*(sigma_t^2)* (1-p_c^2)); % joint distrbution bivariate gaussian

% initialize outpus
dcc = zeros(stt.ntrl,1); dse = zeros(stt.ntrl,1); dop = zeros(stt.ntrl,1);dNcc= zeros(stt.ntrl,1); dccB=zeros(stt.ntrl,1);
f=waitbar(0,'Please wait...'); % initialize bar
%% loop of trials
for i = 1:stt.ntrl
    %% Texture generation
    % generate texture and optional plot with background
    if stt.TextureType==1
        [lft,rft,lftS,rftS] = GenerateBinaryTexture(stt.p,stt.dsp,stt.sz1,stt.sz2,stt.optionalplotForStereogram);
    elseif stt.TextureType==2
        [lft,rft,lftS,rftS] = GenerateGaussianTexture(stt.sgt,stt.dsp,stt.sz1,stt.sz2,stt.optionalplotForStereogram);
    elseif stt.TextureType==3
        [lft,rft,lftS,rftS] = GenerateOneOverFTexture(stt.sgt,stt.dsp,stt.sz1,stt.sz2,stt.optionalplotForStereogram);
    end
    % optional plot textures without background
    if stt.optionalplotForTextures==1
        figure; sgtitle('Texture only');
        subplot(1,2,1);imagesc(lft);colormap gray; axis image; axis off; title('\fontsize{16} Left');
        subplot(1,2,2);imagesc(rft);colormap gray; axis image; axis off; title('\fontsize{16} Right');
        set(gcf,'units','centimeters','position',[1,1,30,12])
    end
    
    %% Noise and Cropping a patch
    %optional plot that generates the figures of stimulus with background
    if stt.optionalplotForStereogram==1
        [lptch,rptch,lfi,rti] = AddNoise_CropPattches(lftS,rftS,stt.sgn,stt.noiseType,stt.phwl,stt.prw,stt.optionalplotForPatches2);
        sgtitle('Texture and Surround with Noise');
    end
    [lptch,rptch,lfi,rti] = AddNoise_CropPattches(lft,rft,stt.sgn,stt.noiseType,stt.phwl,stt.prw,stt.optionalplotForPatches1);
    
    %% Simulate observer models
    
    % Pure cross-correlation
    eff_rr=conv2(rptch,rot90(lptch,2),'valid');
    dcc(i)=find(max(eff_rr)==eff_rr)-stt.prw-1; % find max
    
    % Summed Square Difference
    ww=ones(2*stt.phwl+1,2*stt.phwl+1);
    rsquare_img=conv2(rptch.^2,ww,'valid');
    lsquare_img=sum(sum(lptch.^2));
    eff_sse=rsquare_img+lsquare_img-2*eff_rr;
    dse(i) =  find(min(eff_sse)==eff_sse)-stt.prw-1;
    
    % Normalized-cross correlation
    Neff_rr=eff_rr./ (sqrt(rsquare_img).*sqrt(lsquare_img));
    dNcc(i)=find(max(Neff_rr)==Neff_rr)-stt.prw-1; % find max
    
    if sum(ismember(stt.mdls,2))~=0
        % white texture Ideal
        dum2=0;
        dvariableWhite=zeros(1,stt.prw*2+1);
        for d=-stt.prw:stt.prw
            coordinates=ceil(size(rptch,2)/2-stt.phwl-d):ceil(size(rptch,2)/2+stt.phwl-d);
            rpTemp=rptch(:,coordinates);
            joinProb=mvnpdf([rpTemp(:) lptch(:)],[0 0],[sigma_t^2 stt.sgtModel^2;stt.sgtModel^2 sigma_t^2 ]);
            margProb=normpdf(rptch(:,coordinates),0,sigma_t);
            lklhoodB=-sum(log(joinProb))+sum(sum(log(margProb)));%-log(stt.priors(dum1))
            dvariableWhite(stt.prw*2+1-dum2)=lklhoodB;
            dum2=dum2+1;
            
        end
        dop(i) =  find(min(dvariableWhite)==dvariableWhite)-stt.prw-1;
    end
    
    if sum(ismember(stt.mdls,1))~=0
        %Bernoulli Binary texture Ideal
        a=stt.SucessAModel; %
        a2=stt.NoSucessAModel; %
        
        dum1=0;
        dvariableBinary=zeros(1,stt.prw*2+1);
        for d=-stt.prw:stt.prw
            coordinates=ceil(size(rptch,2)/2-stt.phwl-d):ceil(size(rptch,2)/2+stt.phwl-d);
            joinProb=normpdf(rptch(:,coordinates),a,stt.sgnModel2).*normpdf (lptch,a,stt.sgnModel2)*stt.pModel +...
                normpdf (rptch(:,coordinates),a2,stt.sgnModel2).*normpdf (lptch,a2,stt.sgnModel2)*(1-stt.pModel);
            margProb=normpdf(rptch(:,coordinates),a,stt.sgnModel2)*stt.pModel +...
                normpdf (rptch(:,coordinates),a2,stt.sgnModel2)*(1-stt.pModel);
            lklhoodB=-sum(sum(log(joinProb)))+sum(sum(log(margProb)));%-log(stt.priors(dum1))
            dvariableBinary(stt.prw*2+1-dum1)=lklhoodB;
            dum1=dum1+1;
        end
        dccB(i) = find(min(dvariableBinary)==dvariableBinary)-stt.prw-1;
    end
    % optional plot of absolute disparity preference
    if stt.optPlotDispPref==1
        
        figure(10)
        subplot(1,3+length(stt.mdls),1)
        plot(-stt.prw:stt.prw,eff_rr); title('Cross-Correlation'); hold on; scatter([stt.dsp ],[ max(eff_rr)],'r');
        xlabel('Disparity');ylabel('Decision Variable')
        subplot(1,3+length(stt.mdls),2)
        plot(-stt.prw:stt.prw,eff_sse);title('Squared Error'); hold on; scatter([stt.dsp ],[min(eff_sse) ],'r');
        subplot(1,3+length(stt.mdls),3)
        plot(-stt.prw:stt.prw,Neff_rr) ;title('Normalized Cross-Correlation'); hold on;scatter([stt.dsp ],[ max(Neff_rr)],'r');
        if sum(ismember(stt.mdls,2))~=0
            subplot(1,3+length(stt.mdls),4)
            plot(-stt.prw:stt.prw,dvariableWhite);title('The Ideal for White'); hold on;scatter([ stt.dsp],[ min(dvariableWhite)],'r');
            tdum=5;
        else
            tdum=4;
        end
        if sum(ismember(stt.mdls,1))~=0
            subplot(1,3+length(stt.mdls),tdum)
            plot(-stt.prw:stt.prw,dvariableBinary);title('The Ideal for Binary'); hold on;scatter([ stt.dsp],[ min(dvariableBinary)],'r');
        end
        
    end
    waitbar(i/stt.ntrl,f,'Please wait...');
end
%%plotting optional histograms
if stt.optPlotDec==1
    BinEdges= [-50:5:50] ;
    figure(11)
    subplot(1,3+length(stt.mdls),1)
    histogram(dcc,BinEdges); title('Cross-Correlation'); hold on;
    xlabel('Disparity Estimate');ylabel('Number of Trials')
    subplot(1,3+length(stt.mdls),2)
    histogram(dse,BinEdges);title('Squared Error'); hold on;
    subplot(1,3+length(stt.mdls),3)
    histogram(dNcc,BinEdges);title('Normalized Cross-Correlation'); hold on;
    if sum(ismember(stt.mdls,2))~=0
        subplot(1,3+length(stt.mdls),4)
        histogram(dop,BinEdges);title('The Ideal for White'); hold on;
        tdum=5;
    else
        tdum=4;
    end
    if sum(ismember(stt.mdls,1))~=0
        subplot(1,3+length(stt.mdls),tdum)
        histogram(dccB,BinEdges);title('The Ideal for Binary'); hold on;
    end
    
end
close(f)

end

