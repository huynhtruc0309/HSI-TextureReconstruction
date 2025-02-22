% Perform K-means clustering on ICA-reduced data
nC = 10;  % Number of clusters
[idx, C_centers] = kmeans(flatCube, nC);

% C_centers will contain the coordinates of the cluster centers
% Compute pairwise distances between cluster centers
distances = pdist(C_centers);  % Returns the distances between the centers
distMatrix = squareform(distances);  % Convert to a square matrix for easy visualization

% Normalize the distances for color mapping (optional step, depending on your needs)
maxDist = max(distances);
normalizedDistances = distMatrix / maxDist;

% Generate a colormap based on the distances
% You can use a gradient from a colormap or a perceptual color space like LAB
% Here, we will use a simple gradient from blue to red
colorMap = parula(nC);  % Choose a colormap where similar clusters are close in color

% Apply the new color scheme to the clusters
imageRGB = zeros(H, W, 3);
for c = 1:3
    imageRGB(:,:,c) = reshape(colorMap(idx, c), H, W);
end

% Display the result
imshow(imageRGB);

% Optionally, save the image
outputFilename = 'Cluster_distance_colormap_result.png';
imwrite(imageRGB, outputFilename);
