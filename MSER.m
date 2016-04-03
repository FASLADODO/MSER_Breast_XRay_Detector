%% 读取图片
grayImage = imread('D:/RayZ/fig0304.tif');
figure;imshow(grayImage);
grayImage = imcomplement(grayImage);


%% mser区域提取
% grayImage = rgb2gray(colorImage);
mserRegions = detectMSERFeatures(grayImage);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));

%%  把mser区域的坐标系数取出来，然后将相应系数的地方赋值为真。取出mser区域。
mserMask = false(size(grayImage));
ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
mserMask(ind) = true;
figure;imshow(mserMask);

%% 粗滤除
% [p_image,cwidth] =conComp_analysis(mserMask);

[x,y]=size(mserMask);
cwidth=[];
whole=x*y;
connComp = bwconncomp(mserMask); % Find connected components
threefeature = regionprops(connComp,'Area','BoundingBox','Centroid');
broder=[threefeature.BoundingBox];%[x y width height]字符的区域
area=[threefeature.Area];%区域面积
centre=[threefeature.Centroid];
%%
for i=1:connComp.NumObjects  
    leftx=broder((i-1)*4+1);
    lefty=broder((i-1)*4+2);
    width=broder((i-1)*4+3);
    height=broder((i-1)*4+4);
    cenx=floor(centre((i-1)*2+1));
    ceny=floor(centre((i-1)*2+2));
   
    if area(i)<80||area(i)>0.3*whole
      mserMask(connComp.PixelIdxList{i})=0;
    elseif width/height<0.1||width/height>2
      mserMask(connComp.PixelIdxList{i})=0;
    else
      cwidth=[cwidth,width];
       rectangle('Position',[leftx,lefty,width,height], 'EdgeColor','g');
    end
end

figure;imshow(grayImage);
for i=1:connComp.NumObjects  
    leftx=broder((i-1)*4+1);
    lefty=broder((i-1)*4+2);
    width=broder((i-1)*4+3);
    height=broder((i-1)*4+4);
    cenx=floor(centre((i-1)*2+1));
    ceny=floor(centre((i-1)*2+2));
   
    if area(i)<80||area(i)>0.3*whole
      mserMask(connComp.PixelIdxList{i})=0;
    elseif width/height<0.1||width/height>2
      mserMask(connComp.PixelIdxList{i})=0;
    else
      cwidth=[cwidth,width];
       rectangle('Position',[leftx,lefty,width,height], 'EdgeColor','g');
    end
end
wi= median(cwidth(:))/2;
se1=strel('line',wi,0);
% p_image_dilate= imclose(p_image,se1);








