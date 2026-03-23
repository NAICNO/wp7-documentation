# Project deliverables

## Use Case Demonstrators

| ID | Deliverable | Repository | Tutorial | Status |
|----|-------------|------------|----------|--------|
| UC1 | Climate Indices Teleconnection | [wp7-UC1-climate-indices-teleconnection](https://github.com/NAICNO/wp7-UC1-climate-indices-teleconnection) | [Tutorial](https://naicno.github.io/wp7-UC1-climate-indices-teleconnection/) | **Completed** |
| UC2 | PEM Electrolyzer PINN Optimizer | [wp7-UC2-pem-electrolyzer-digital-twin](https://github.com/NAICNO/wp7-UC2-pem-electrolyzer-digital-twin) | [Tutorial](https://naicno.github.io/wp7-UC2-pem-electrolyzer-digital-twin/) | **Completed** |
| UC3 | Pseudo-Hamiltonian Neural Networks | [wp7-UC3-pseudo-hamiltonian-neural-networks](https://github.com/NAICNO/wp7-UC3-pseudo-hamiltonian-neural-networks) | [Tutorial](https://naicno.github.io/wp7-UC3-pseudo-hamiltonian-neural-networks/) | **Completed** |
| UC4 | 3D Medical Image Registration & Segmentation | [wp7-UC4-medical-image-registration](https://github.com/NAICNO/wp7-UC4-medical-image-registration) | [Tutorial](https://naicno.github.io/wp7-UC4-medical-image-registration/) | **Completed** |
| UC5 | Graph-Based Classification of AIS Time-Series Data | [wp7-UC5-ais-classification-gnn](https://github.com/NAICNO/wp7-UC5-ais-classification-gnn) | [Tutorial](https://naicno.github.io/wp7-UC5-ais-classification-gnn/) | **Completed** |
| UC6 | Multi-Modal Optimization | [wp7-UC6-multimodal-optimization](https://github.com/NAICNO/wp7-UC6-multimodal-optimization) | [Tutorial](https://naicno.github.io/wp7-UC6-multimodal-optimization/) | **Completed** |
| UC7 | Latent Representation of PDE Solutions | [wp7-UC7-latent-pde-representation](https://github.com/NAICNO/wp7-UC7-latent-pde-representation) | [Tutorial](https://naicno.github.io/wp7-UC7-latent-pde-representation/) | **Completed** |

## Summary Deliverables

| ID | Deliverable | Repository |
|----|-------------|------------|
| D7.10 | Summary of completed demonstrators | [wp7-D710-deliverable-report](https://github.com/NAICNO/wp7-D710-deliverable-report) |
| D7.11 | Summary of contributions for training and documentation | [wp7-D711-summary](https://github.com/NAICNO/wp7-D711-summary) |

## Use Case Summaries

### UC1 — Climate Indices Teleconnection Analysis

**Domain:** Climate Science | **Key Technique:** Ensemble ML (Random Forest, XGBoost, MLP)

Analyses teleconnections between 65 climate indices from NorESM1-F simulations (850–2005 AD). Over 42,613 experiments achieved correlation coefficients exceeding 0.7 for 20+ target indices, supporting 10–50 year forecasts of Atlantic Multidecadal Variability and Pacific Decadal Variability. The only demonstrator running on both NAIC Orchestrator VMs and Sigma2 HPC clusters.

### UC2 — PEM Electrolyzer PINN Optimizer

**Domain:** Green Hydrogen | **Key Technique:** Physics-Informed Neural Networks

Predicts PEM electrolyzer cell voltage using a two-stage physics-informed architecture. A 12-parameter student model, trained via knowledge distillation from a ~9,354-parameter teacher, achieves ~18 mV out-of-distribution MAE — beating ~50,000-parameter Transformers (~118 mV) by over 5x. Includes an inverse pressure optimizer and a real-time digital twin with 3D visualization.

### UC3 — Pseudo-Hamiltonian Neural Networks

**Domain:** Dynamical Systems | **Key Technique:** Port-Hamiltonian Decomposition

Decomposes system dynamics into conservation, dissipation, and external force components using separate sub-networks. The approach outperforms standard neural networks on dynamical systems benchmarks and produces models that remain valid when external forces are modified. Based on SINTEF's prior research (Eidnes et al., *Journal of Computational Physics*, 2023) and their open-source `phlearn` package.

### UC4 — 3D Medical Image Registration & Segmentation

**Domain:** Medical Imaging | **Key Technique:** ANTsPy + HD-BET

Registers multi-modal brain MRI scans (T1, T1Gd, T2, FLAIR) to the SRI-24 standard atlas. The pipeline applies N4 bias correction, AI-based brain extraction (HD-BET), rigid registration, and atlas alignment. The only WP7 use case in healthcare.

### UC5 — Graph-Based Classification of AIS Time-Series Data

**Domain:** Maritime Surveillance | **Key Technique:** Graph Neural Networks (DGL)

Transforms vessel AIS trajectories into graph structures and classifies fishing vs. non-fishing behavior using GNNs. GraphSAGE achieved 94.4% test accuracy. The graph representation outperformed flat time series regardless of GNN architecture, showing that data representation matters as much as model choice.

### UC6 — Multi-Modal Optimization

**Domain:** Optimization | **Key Technique:** Hybrid GA + CMA-ES

Implements the Scalable Hybrid Genetic Algorithm (SHGA), combining Deterministic Crowding GA with CMA-ES for finding all optima of multi-modal functions. Achieves 66% average peak ratio on the CEC2013 benchmark suite with 3–4x speedup from multi-core parallelization. Based on Johannsen et al., *Nordic Machine Intelligence* (2022).

### UC7 — Latent Representation of PDE Solutions

**Domain:** Scientific Computing | **Key Technique:** Autoencoders + Latent Alignment

Learns compact representations of parameterized PDE solution manifolds using autoencoders with cross-modal latent alignment. Enables transfer between parameter space and solution space without re-solving the PDE, supporting multiple grid discretizations within the same latent space.
