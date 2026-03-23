# Use Cases

## UC1 — Climate Indices Teleconnection Analysis

**Repository:** [wp7-UC1-climate-indices-teleconnection](https://github.com/NAICNO/wp7-UC1-climate-indices-teleconnection)
**Contributors:** Klaus Johannsen, Odd Helge Otterå, Adrian Evensen, Hasan Asyari Arief (NORCE Research)
**Tutorial:** [https://naicno.github.io/wp7-UC1-climate-indices-teleconnection/](https://naicno.github.io/wp7-UC1-climate-indices-teleconnection/)

### The Problem

Climate teleconnections are large-scale patterns that link distant regions' weather and climate. They are central to decadal climate prediction, but identifying them from observational data is hard. Traditional approaches rely on expert-curated index pairs and linear statistics. UC1 tests whether machine learning can systematically discover teleconnection relationships across a large set of climate indices, including non-linear ones, and use them for multi-decadal forecasts.

### Approach

The team worked with three long-term climate simulations from the Norwegian Earth System Model (NorESM1-F), spanning 850–2005 AD under different forcing scenarios (low solar, high solar, and a 1000-year pre-industrial control). These simulations provide 65 climate indices covering surface temperatures, sea surface temperatures, sea ice concentration, precipitation, atmospheric pressure, and ocean circulation.

The ML pipeline normalizes all indices to a 0–100 scale, generates lagged features to capture temporal dependencies (up to 150-year lags), and trains an ensemble of five model types, from linear regression baselines through Random Forest and XGBoost to MLP neural networks. Feature importance is averaged across ensemble runs, top-N features are selected, and performance is evaluated using Pearson correlation and MAE. An optional Morlet wavelet bandpass filter isolates specific frequency bands for targeted analysis.

### What It Found

Over 42,613 individual experiments were conducted across all model–target–lag combinations. ML models achieved correlation coefficients exceeding 0.7 for more than 20 target climate indices, identifying statistically significant teleconnections across multi-decadal timescales. These results support 10–50 year forecasts of patterns such as Atlantic Multidecadal Variability (AMV) and Pacific Decadal Variability (PDV).

### Infrastructure

UC1 runs on the NAIC Orchestrator for interactive exploration via `demonstrator-v1.orchestrator.ipynb`. It also provides a full CLI for automated parameter sweeps, which makes it a useful reference for how large-scale ML experiments can use NAIC infrastructure.

---

## UC2 — PEM Electrolyzer PINN Optimizer

**Repository:** [wp7-UC2-pem-electrolyzer-digital-twin](https://github.com/NAICNO/wp7-UC2-pem-electrolyzer-digital-twin)
**Contributors:** Hasan Asyari Arief (NORCE Research)
**Tutorial:** [https://naicno.github.io/wp7-UC2-pem-electrolyzer-digital-twin/](https://naicno.github.io/wp7-UC2-pem-electrolyzer-digital-twin/)

### The Problem

PEM water electrolysis is a key technology for green hydrogen production, but predicting cell voltage under varying operating conditions is essential for safe, efficient operation. The hard part is generalization: a model trained on one set of operating conditions must predict accurately when current, pressure, or temperature move outside the training range. Pure ML models (MLPs, Transformers) can fit training data well but fail when extrapolating. Purely empirical physics models lack the flexibility to capture the full behavior.

### Approach

UC2 addresses this with a two-stage physics-informed architecture. First, a **teacher model** embeds electrochemical equations (Nernst voltage, Butler-Volmer activation overpotential, Ohmic losses) directly into the network, with an MLP residual clamped to ±100 mV so physics always dominates. Second, through **knowledge distillation**, a compact 12-parameter **student model** learns from both the real data (10% weight) and the teacher's predictions (90% weight). The student replaces the MLP with a 6-parameter logistic correction and adds a concentration overpotential term, which trades in-distribution fit for much better generalization.

Beyond prediction, UC2 includes an **inverse pressure optimizer** (Newton-Raphson with bisection fallback) that finds the maximum safe operating pressure for given conditions, and a **real-time digital twin** combining PINN voltage predictions with Lattice-Boltzmann fluid dynamics at ~10 FPS.

### What It Found

The 12-parameter student model achieves ~15 mV average OOD MAE, beating a ~530,000-parameter Transformer (~62 mV) by more than 4x.

| Model | Parameters | Val MAE | OOD Avg MAE |
| :--- | :--- | :--- | :--- |
| Distilled Student | **12** | ~14 mV | **~15 mV** |
| Teacher (HybridPhysicsMLP) | ~9,354 | ~14 mV | ~28 mV |
| Pure Physics | 12 | ~25 mV | ~21 mV |
| PureMLP | ~2,049 | ~13 mV | ~42 mV |
| BigMLP | ~43,393 | ~12 mV | ~47 mV |
| Transformer | ~529,793 | ~10 mV | ~62 mV |

The pure ML models win on in-distribution validation because they have orders of magnitude more parameters to memorize training patterns, but they collapse on out-of-distribution data.

### Infrastructure

UC2 deploys on NAIC Orchestrator VMs with GPU support, exposing both the training pipeline and the digital twin through SSH-tunneled ports. The 9-chapter Sphinx tutorial makes it one of the most thoroughly documented demonstrators in WP7.

---

## UC3 — Pseudo-Hamiltonian Neural Networks

**Repository:** [wp7-UC3-pseudo-hamiltonian-neural-networks](https://github.com/NAICNO/wp7-UC3-pseudo-hamiltonian-neural-networks)
**Contributors:** Sølve Eidnes, Kjetil Olsen Lye (SINTEF Digital)
**Tutorial:** [https://naicno.github.io/wp7-UC3-pseudo-hamiltonian-neural-networks/](https://naicno.github.io/wp7-UC3-pseudo-hamiltonian-neural-networks/)
**Reference Implementation:** [github.com/SINTEF/pseudo-hamiltonian-neural-networks](https://github.com/SINTEF/pseudo-hamiltonian-neural-networks)

### The Problem

Standard neural networks trained to model physical systems learn to predict the next state but have no built-in notion of energy conservation, dissipation, or external forcing. They can produce physically implausible trajectories, especially over long time horizons. The goal is to design neural architectures that respect the structure of the underlying physics while still learning from data.

### Approach

UC3 tackles this through Pseudo-Hamiltonian Neural Networks (PHNNs), which decompose system dynamics into three physically meaningful components, each modeled by a separate sub-network:

1. A **Conservation Network** that captures energy-preserving Hamiltonian dynamics
2. A **Dissipation Network** that models energy loss and damping
3. An **External Force Network** that learns state-dependent forcing terms

This decomposition is rooted in port-Hamiltonian theory and ensures that each learned component is physically interpretable. A researcher can inspect what the model attributes to dissipation versus external forcing, for example. Symmetric fourth-order integration schemes further improve training with sparse and noisy data.

### What It Found

The approach outperforms standard neural networks on dynamical systems benchmarks (forced/damped mass-spring systems, complex tank systems, PDEs). Learned models also remain valid when external forces are modified or removed, which standard neural networks cannot do. The underlying methodology is described in Eidnes et al., *Journal of Computational Physics* (2023) and *Applied Mathematics and Computation* (2024).

### Infrastructure

UC3 is led by SINTEF, and the reference implementation is available as the open-source `phlearn` Python package integrated into the WP7 repository with a full test suite and CI/CD pipeline.

---

## UC4 — 3D Medical Image Registration & Segmentation

**Repository:** [wp7-UC4-medical-image-registration](https://github.com/NAICNO/wp7-UC4-medical-image-registration)
**Contributors:** Saruar Alam (UiB)
**Tutorial:** [https://naicno.github.io/wp7-UC4-medical-image-registration/](https://naicno.github.io/wp7-UC4-medical-image-registration/)

### The Problem

Brain tumor diagnosis and monitoring rely on multiple MRI modalities (T1, T1 with gadolinium contrast, T2, and FLAIR), each highlighting different tissue characteristics. Before these modalities can be analyzed together to delineate tumor boundaries or estimate tumor volume, the images must be spatially aligned. This registration step is critical for both clinical practice and automated segmentation research.

### Approach

The pipeline combines two established medical imaging tools. **HD-BET** performs AI-based brain extraction (skull stripping), while **ANTsPy** handles the registration. The workflow applies N4 bias correction to remove intensity non-uniformities, rigidly registers all modalities to the T1Gd reference, registers T1Gd to the SRI-24 standard atlas, and then propagates all transformations to the remaining modalities.

Each modality contributes a different perspective:

| Modality | Clinical Role |
| :--- | :--- |
| T1 / T1Gd | Detailed anatomy; gadolinium highlights active tumor tissue |
| T2 | Sensitive to fluids, revealing edema and infiltration |
| FLAIR | Differentiates CSF from lesions, especially near ventricles |

### Infrastructure

UC4 provides the core registration pipeline with a Conda environment, an orchestrator notebook with synthetic 3D data for demonstration, a full test suite, and CI/CD pipeline. UC4 is the only WP7 use case in healthcare, where reproducible computational pipelines are especially important for clinical research.

---

## UC5 — Graph-Based Classification of AIS Time-Series Data

**Repository:** [wp7-UC5-ais-classification-gnn](https://github.com/NAICNO/wp7-UC5-ais-classification-gnn)
**Contributors:** Xue-Cheng Tai, Gro Fonnes (NORCE Research)
**Tutorial:** [https://naicno.github.io/wp7-UC5-ais-classification-gnn/](https://naicno.github.io/wp7-UC5-ais-classification-gnn/)

### The Problem

Maritime surveillance generates large volumes of AIS data (position, speed, heading, identity) for thousands of vessels. A key task is classifying vessel activities, particularly distinguishing fishing from non-fishing behavior, which matters for fisheries management and environmental monitoring. Traditional approaches use hand-crafted features and thresholds, but vessel movement patterns are complex and context-dependent.

### Approach

Instead of treating AIS data as a flat time series, UC5 transforms each vessel's trajectory into a **graph structure** where nodes represent time steps and edges encode spatial and temporal relationships between points. These graphs are then classified using graph neural networks built on the Deep Graph Library (DGL).

Three GNN architectures were evaluated:

| Model | Architecture | Description |
| :--- | :--- | :--- |
| GCN | Graph Convolutional Network | Spectral-based graph convolutions |
| GraphSAGE (GSG) | Sample and Aggregate | Inductive representation learning |
| GAT | Graph Attention Network | Attention-weighted neighbor aggregation |

### What It Found

GraphSAGE achieved the best performance at **94.4% test accuracy** on fishing vs. non-fishing classification. The graph-based representation captures spatial-temporal patterns in vessel movement that would be hard to extract with traditional feature engineering. The framework supports both CPU and GPU training with CUDA 11.8.

Representing AIS data as graphs instead of sequences turned out to matter more than the choice of GNN architecture, and the same idea applies to other domains with spatial-temporal data.

---

## UC6 — Multi-Modal Optimization

**Repository:** [wp7-UC6-multimodal-optimization](https://github.com/NAICNO/wp7-UC6-multimodal-optimization)
**Contributors:** Klaus Johannsen, Hasan Asyari Arief (NORCE Research)
**Tutorial:** [https://naicno.github.io/wp7-UC6-multimodal-optimization/](https://naicno.github.io/wp7-UC6-multimodal-optimization/)
**Reference:** Johannsen, K., Goris, N., Jensen, B., & Tjiputra, J. (2022). *Nordic Machine Intelligence*, 02, 16–27. [DOI:10.5617/nmi.9633](https://doi.org/10.5617/nmi.9633)

### The Problem

Many real-world optimization problems in engineering design, molecular modeling, and scientific parameter estimation have multiple valid solutions, not just one global optimum. Standard optimization algorithms converge to one solution and stop. Finding *all* optima requires different strategies that balance exploration (searching the full domain) with exploitation (refining promising regions).

### Approach

UC6 implements the Scalable Hybrid Genetic Algorithm (SHGA), which combines two complementary strategies. A **Deterministic Crowding GA** handles global exploration while keeping population diversity. It replaces individuals only with similar ones, preventing the population from collapsing onto a single solution. Once promising regions are identified through nearest-neighbor clustering, individual **CMA-ES** instances refine each seed to high precision. The outer loop scales up the population and repeats, progressively discovering additional optima.

The algorithm supports multi-core parallelization of the inner CMA-ES loop, yielding 3–4x speedup on 16-core NAIC Orchestrator VMs.

### What It Found

SHGA reliably discovers all 4 global optima of Himmelblau's function within 50,000 evaluations and achieves an average peak ratio of 66% across the 20-function CEC2013 benchmark suite (2–20 dimensions).

UC6 also shows that NAIC infrastructure pays off for workloads beyond deep learning: the parallelized SHGA runs 3–4x faster on 16-core Orchestrator VMs than the sequential version.

---

## UC7 — Latent Representation of PDE Solutions

**Repository:** [wp7-UC7-latent-pde-representation](https://github.com/NAICNO/wp7-UC7-latent-pde-representation)
**Contributors:** Klaus Johannsen, Yngve Heggelund (NORCE Research)
**Tutorial:** [https://naicno.github.io/wp7-UC7-latent-pde-representation/](https://naicno.github.io/wp7-UC7-latent-pde-representation/)

### The Problem

Solving PDEs numerically is expensive. For applications that require exploring a parameterized family of solutions (varying boundary conditions, coefficients, or discretization resolutions), re-solving the PDE for every parameter configuration is prohibitive. UC7 tries to learn a compact representation of the entire solution manifold so that new solutions can be evaluated, interpolated, and compared without running the solver.

### Approach

UC7 focuses on steady-state convection–diffusion equations in two spatial dimensions, with parameterized, divergence-free convection fields. The methodology has three stages:

1. Train **autoencoders** separately on PDE solution fields and on the convection parameter (streamfunction) modality to learn compact latent representations
2. **Align the latent spaces** of these different modalities, so that a single shared representation bridges between parameters and solutions
3. **Fine-tune** encoders and decoders toward the shared latent, then evaluate reconstruction quality via relative MSE across modalities and grid discretizations

### What It Found

The framework learns structured latent spaces that capture the solution manifold, with cross-modal alignment allowing transfer between parameter space and solution space. Multiple grid discretizations can coexist within the same latent space, which means the representation works regardless of mesh resolution.

UC7 is designed as an educational sandbox for researchers interested in neural operators and representation learning for scientific computing. It is the third use case (alongside UC2 and UC3) where the ML approach is shaped by the structure of the underlying math, instead of treating the problem as generic regression.
