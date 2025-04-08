# Texture Reconstruction of Archaeological Textiles Using Hyperspectral Images

This repository provides MATLAB implementations for analyzing and reconstructing fragmented archaeological textiles, specifically the Oseberg tapestries, utilizing hyperspectral imaging methods. Techniques include dimensionality reduction (PCA, ICA, MNF) and K-means clustering.

## 🚀 Project Overview

This project aims to assist archaeologists in reconstructing and analyzing severely degraded textile fragments by:

- Enhancing visualizations to uncover hidden details
- Identifying and matching related fragments
- Streamlining the reconstruction process of historical textiles

## 🛠️ Techniques and Tools

- **MATLAB:** Core computational framework
- **Hyperspectral Imaging:** VNIR (400–1000 nm) and SWIR (1000–2500 nm) data analysis
- **Dimensionality Reduction:** Principal Component Analysis (PCA), Independent Component Analysis (ICA), Minimum Noise Fraction (MNF)
- **Clustering:** K-means clustering for spectral segmentation

## 📂 Repository Structure

- `Classify_RGB_Image.m`: Classifies RGB-based images
- `extract_false_color.m`: Generates false-color images from hyperspectral data
- `icaongoing.m`: ICA implementation for visualization
- `kmeans_color_segmentation.m`: Color-based segmentation using K-means clustering
- `runICA.m`: Executes Independent Component Analysis (ICA)
- `runKmeans.m`: Runs K-means clustering on hyperspectral data
- `runPCA.m`: Performs Principal Component Analysis (PCA)

## 💻 Usage

### Dimensionality Reduction

- **PCA:**
```matlab
runPCA
```
- **ICA:**
```matlab
runICA
```
### K-means Clustering
Segment hyperspectral data into meaningful clusters:

```matlab
runKmeans
```
### False-Color Visualization
Generate false-color images highlighting spectral details:

```matlab
extract_false_color
```
## 📊 Results

### Psychophysical Experiments

- **MNF** visualizations consistently outperformed **PCA** and **ICA** in:
  - Clarity of visualization
  - Ease of recognizing key elements like figures, patterns, and textures

### Histogram-based Clustering Evaluation

Using a **Jaccard Index threshold of 0.6**, the clustering method achieved:

- **Accuracy:** 85%
- **Precision:** 89%
- **Recall:** 80%
- **F1-Score:** 84%

For detailed methodology, experiments, and further analysis, please refer to the provided [Report](Report.pdf).

## 📖 Citation
If you find this project helpful, please cite:

```bibtex
@misc{huynh2024texture,
  author = {Truc Luong Phuong HUYNH},
  title = {Texture Reconstruction Of Archaeological Textiles Using Hyperspectral Images},
  year = {2024},
  howpublished = {GitHub repository},
  url = {https://github.com/huynhtruc0309}
}
```
## 📜 License
This project is licensed under the MIT License.
