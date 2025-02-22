clear; clc;
rng('default')

filename = "Fragments/Fragment4/Texrec4top_SWIR_384_SN3189_7401us_2022-02-01T163507_raw_rad_float32.hdr";

hcube = hypercube(filename);

numEndmembers = countEndmembersHFC(hcube);

endmembers = fippi(hcube.DataCube,numEndmembers,'ReductionMethod','PCA');

[newhcube,band] = selectBands(hcube,endmembers);

dataCube = newhcube.DataCube;

[H, W, C] = size(dataCube);
flatCube = reshape(dataCube, H*W, C);

flatCube = zscore(flatCube);

% Apply ICA using MATLAB's 'rica' function for dimensionality reduction
nComponents = 10;  % Number of independent components to extract
ricaModel = rica(flatCube, nComponents);

reducedCubeICA = transform(ricaModel, flatCube);

dataCubeICA = reshape(reducedCubeICA, H, W, nComponents);

nClusters = 10;  

idx = imsegkmeans(uint8(dataCubeICA), nClusters);

colorMap = jet(nClusters);
imageRGB = zeros(H, W, 3);
for c = 1:3
    imageRGB(:,:,c) = reshape(colorMap(idx, c), H, W);
end
imshow(imageRGB);

