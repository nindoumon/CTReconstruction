close all;
N=size(F1,1);
M=size(F1,2);
r_spacing=0.1;
nx=512;
ny=nx;
D=1000;
r_max=floor(N/2)*r_spacing;
gamma=((1:N)-(N-1)/2)*r_spacing;
n=-floor(N/2):floor(N/2);
ZeroPaddedLength=2^ceil(log2(2*(N-1)));
deltaS=r_spacing*R/(R+D);
FilterType='hann';
filter=FilterLine(ZeroPaddedLength+1,r_spacing,FilterType,cutoff);
x=1:nx;
y=1:ny;
mid=nx/2;
[X,Y]=meshgrid(x,y);
xpr=X-mid;
ypr=Y-mid;
recon=zeros(nx,ny);
[phi,r]=cart2pol(xpr,ypr);
theta=linspace(360,0,M+1);
theta=theta*(pi/180);
dtheta=abs(theta(1)-theta(2));
for i=1:M
    R1=F1(:,i);
    w=((D*deltaS)./sqrt((D)^2+gamma'.^2));
    R2=w.*R1;
    Q=real(ifft(ifftshift(fftshift(fft(R2,ZeroPaddedLength)).*filter)));
    Q=Q(1:length(R2));
    angle=theta(i);
    gamma2=D*((r.*cos(angle-phi))./(D+r.*sin(angle-phi)));
    ii=find((gamma2>min(gamma(:)))&(gamma2<max(gamma(:))));
    gamma2=gamma2(ii);
    U=(D+r(ii).*sin(angle-phi(ii)))./D;
    vq=interp1(gamma,Q,gamma2);
    recon(ii)=recon(ii)+dtheta.*(1./(U.^2)).*vq;
    imshow(recon,[]);
end
imshow(recon,[]);
figure;imshow(recon-P,[]);
figure;
plot(recon(256,:));
hold on;
plot(P(256,:));