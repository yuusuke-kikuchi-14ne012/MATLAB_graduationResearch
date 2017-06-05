%対象オブジェクトを含む参照イメージを読み取ります。
x = imread('sample/試料1/切抜き（550×1500）/sm0.jpg');
boxImage = rgb2gray(x);
figure;
imshow(boxImage);
title('Image of a Box');

%要素の多いシーンを含むターゲット イメージを読み取ります。
y = imread('sample/試料1/sm1.jpg');
sceneImage = rgb2gray(y);
figure;
imshow(sceneImage);
title('Image of a Cluttered Scene');

%両方のイメージで特徴点を検出します。
boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);

%参照イメージで検出された最も強い特徴点を可視化します。
figure;
imshow(boxImage);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 100));

%ターゲットイメージで検出された最も強い特徴点を可視化します。
figure;
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));

%両方のイメージ内の関心点における特徴記述子を抽出します。

[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%特徴記述子を使用して特徴をマッチングします。
boxPairs = matchFeatures(boxFeatures, sceneFeatures);

%マッチであると推定される特徴を表示します。
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure;
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

%estimateGeometricTransform は、外れ値を排除しながら、マッチした点を関連付ける変換を計算します。この変換によってシーン内のオブジェクトの位置を決定できます。
[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');

%外れ値を削除したうえで、マッチする点のペアを表示します。
figure;
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

%参照イメージの境界多角形を取得します。
boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    
%この多角形をターゲット イメージの座標系に変換します。変換後の多角形は、シーン内のオブジェクトの位置を示しています。
newBoxPolygon = transformPointsForward(tform, boxPolygon);

%検出したオブジェクトを表示します。
figure;
imshow(y);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');