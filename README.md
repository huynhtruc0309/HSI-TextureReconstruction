# Texture Reconstruction of Archaeological Textiles Using Hyperspectral Images

## Overview

This project explores the use of **hyperspectral imaging** and computational techniques to analyze and reconstruct **fragmented archaeological textiles**, specifically the **Oseberg tapestries**. The goal is to enhance visualization, uncover hidden details, and aid archaeologists in identifying and matching textile fragments.

## Key Features

- **Spectral Visualization**: Implements techniques like **Principal Component Analysis (PCA), Independent Component Analysis (ICA), Minimum Noise Fraction (MNF), and False-Color Imaging** to reveal hidden patterns in hyperspectral images.
- **Spectral Classification**: Uses **K-means clustering** to group textile fragments based on spectral similarities.
- **Histogram-Based Evaluation**: Employs the **Jaccard Index** to measure similarity between fragments and validate potential relationships.
- **Psychophysical Experiment**: Evaluates different spectral visualization techniques through user studies with archaeologists and naive observers.

## Methodology

1. **Dataset**
   - The dataset consists of **hyperspectral images** of **26 textile fragments** captured in **VNIR (400-1000 nm) and SWIR (1000-2500 nm) spectral ranges**.
   - Relationships between fragments are hypothesized based on texture, motifs, and weaving styles.

2. **Spectral Visualization Techniques**
   - **RGB Visualization**
   - **Bandwise Analysis**
   - **False-Color Imaging**
   - **Dimensionality Reduction** (PCA, ICA, MNF)

3. **Spectral Classification**
   - **K-means Clustering**: Groups fragments based on spectral signatures.
   - **Evaluation Methods**:
     - **Elbow Method**
     - **Silhouette Score**
     - **Davies-Bouldin Index**
     - **Calinski-Harabasz Index**

4. **Histogram-Based Clustering & Jaccard Index**
   - A threshold-based Jaccard Index is used to determine fragment relationships.
   - **Evaluation Metrics**:
     - **Accuracy: 85%**
     - **Precision: 89%**
     - **Recall: 80%**
     - **F1-score: 84%**

## Results

- **MNF outperformed PCA and ICA** in terms of clarity and ease of recognition.
- **Jaccard Index-based classification** successfully identified related fragments with high precision.
- **False-color imaging** revealed subtle material and weave pattern differences.

## Future Work

- Integrate **Spectral Angle Mapper (SAM), Spectral Correlation Mapper (SCM), and Spectral Information Divergence (SID)** for improved classification.
- Automate preprocessing and component selection.
- Apply the method to larger datasets, including the **entire Oseberg collection**.
- Develop **interactive tools** for archaeologists to explore hyperspectral data.