# Common Patterns

Several patterns came up across the seven demonstrators that should inform future NAIC work.

## Physics-informed ML generalizes better with fewer parameters

UC2 and UC3 show that embedding domain physics into the architecture, instead of expecting the network to learn physics from data, produces models that generalize better with far fewer parameters. UC2's 12-parameter student outperformed a ~530,000-parameter Transformer on out-of-distribution data. UC3's decomposable architecture retains physical interpretability that monolithic networks lack. UC7 takes a related approach where autoencoders learn structured representations of PDE solutions informed by the underlying equations.

## Data representation matters as much as model choice

UC5's decision to represent vessel trajectories as graphs, instead of flat time series, enabled GNN models to capture spatial-temporal patterns that traditional approaches miss. UC7 similarly benefits from treating PDE solutions as multi-modal objects with shared latent structure. In both cases, the data representation mattered as much as the model architecture.

## NAIC infrastructure bridges interactive and batch computing

UC1 is the clearest example: the same analysis runs interactively on an Orchestrator VM (for exploration and prototyping) and via the CLI for automated parameter sweeps. UC2 and UC6 show how Orchestrator VMs with GPU and multi-core support handle training workloads that would be impractical on a researcher's laptop. The shared pattern of SSH-tunneled Jupyter access, tmux-based background training, and one-command setup scripts (`setup.sh`, `vm-init.sh`) cuts the operational overhead for domain scientists.

## Reproducibility through self-contained repositories

Each completed demonstrator ships as a Git repository containing data (or download scripts), environment specifications, training code, evaluation scripts, and a Jupyter notebook that runs end-to-end. All demonstrators include Sphinx-based tutorials published on GitHub Pages, and six (all except UC4) include AGENT.md files that let AI coding assistants set up and run the project autonomously. A new researcher can go from `git clone` to results without external dependencies.

## Glossary

| Term | Description |
| :--- | :--- |
| **AIS** | Automatic Identification System — a maritime tracking system used on ships for broadcasting vessel position, speed, course, and identity information. |
| **AMV** | Atlantic Multidecadal Variability — a pattern of sea surface temperature variability in the North Atlantic spanning multiple decades. |
| **ANTsPy** | Advanced Normalization Tools for Python — a medical image registration and segmentation library. |
| **CEC2013** | IEEE Congress on Evolutionary Computation 2013 — a standardized benchmark suite for multimodal optimization with 20 test functions. |
| **CMA-ES** | Covariance Matrix Adaptation Evolution Strategy — a derivative-free optimization algorithm for continuous domains. |
| **DGL** | Deep Graph Library — a Python library for building and training graph neural networks. |
| **Digital Twin** | A real-time virtual replica of a physical system, combining physics-based models with live telemetry for monitoring and optimization. |
| **GNN** | Graph Neural Network — a class of neural networks designed to operate on graph-structured data. |
| **HD-BET** | High-Definition Brain Extraction Tool — an AI-based tool for accurate brain extraction from MRI scans. |
| **Knowledge Distillation** | A model compression technique where a small "student" model learns to mimic a larger "teacher" model. |
| **LBM** | Lattice Boltzmann Method — a computational fluid dynamics approach used for simulating fluid flow. |
| **NAIC** | Norwegian AI Cloud — a national infrastructure project providing accessible AI/ML computing resources across Norwegian research institutions. |
| **NAIC Orchestrator** | A cloud VM provisioning platform at orchestrator.naic.no for deploying GPU-enabled virtual machines for AI workloads. |
| **NorESM** | Norwegian Earth System Model — a global climate model used for long-term climate simulations. |
| **OOD** | Out-of-Distribution — data that differs from the training distribution, used to evaluate model generalization. |
| **PDE** | Partial Differential Equation — a mathematical equation involving partial derivatives, fundamental to physics and engineering simulations. |
| **PEM** | Proton Exchange Membrane — a type of electrolyzer technology used for green hydrogen production via water electrolysis. |
| **PHNN** | Pseudo-Hamiltonian Neural Network — a physics-informed neural network architecture that decomposes system dynamics into conservation, dissipation, and external force components. |
| **PINN** | Physics-Informed Neural Network — a neural network architecture that incorporates physical laws as constraints during training. |
| **SHGA** | Scalable Hybrid Genetic Algorithm — an optimization algorithm combining Deterministic Crowding GA with CMA-ES for multimodal optimization. |
