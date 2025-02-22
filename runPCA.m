clear; clc;
rng('default')

filename = "Fragments/Fragment1/Texrec1Atop_VNIR_1800_SN00841_19998us_2022-02-08T153917_raw_rad_float32.hdr";

hcube = hypercube(filename);

numEndmembers = countEndmembersHFC(hcube);

endmembers = fippi(hcube.DataCube,numEndmembers,'ReductionMethod','PCA');

[newhcube,band] = selectBands(hcube,endmembers);

dataCube = newhcube.DataCube;

[H, W, C] = size(dataCube);
flatCube = reshape(dataCube, H*W, C);

flatCube = zscore(flatCube);

[coeff, score, ~, ~, explained] = pca(flatCube);

% Keep enough components to cover 95% of variance
numComponents = find(cumsum(explained) >= 95, 1);
% reducedCubePCA = score(:, 1:numComponents);
reducedCubePCA = score(:, 1);

dataCubePCA = reshape(reducedCubePCA, H, W, numComponents);

nC = 10;
idx = imsegkmeans(dataCubePCA, nC);

colorMap = jet(nC);
imageRGB = zeros(H, W, 3);
for c = 1:3
    imageRGB(:,:,c) = reshape(colorMap(idx, c), H, W);
end
imshow(imageRGB);
