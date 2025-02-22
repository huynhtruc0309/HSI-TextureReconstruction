clear; clc;

rng('default')

filename = "Fragments/Fragment4/Texrec4top_SWIR_384_SN3189_7401us_2022-02-01T163507_raw_rad_float32.hdr";
outputFilename = replace(filename, "Fragments", "KmeansColored");
outputFilename = replace(outputFilename, "hdr", "jpg");

hcube = hypercube(filename);

numEndmembers = countEndmembersHFC(hcube);

endmembers = fippi(hcube.DataCube,numEndmembers,'ReductionMethod','PCA');

[newhcube,band] = selectBands(hcube,endmembers);

dataCube = newhcube.DataCube;

[H, W, C] = size(dataCube);

flatCube = reshape(dataCube, H*W, C);

flatCube = zscore(flatCube);

nC = 10;
idx = kmeans(flatCube, nC);

colorMap = jet(nC); % 100x3 matrix of RGB values
imageRGB = zeros(H, W, 3);

for c = 1:3
    imageRGB(:,:,c) = reshape(colorMap(idx, c), H, W);
end

imshow(imageRGB);
imwrite(imageRGB, outputFilename);
