# Overview

The Norwegian AI Cloud promised that shared infrastructure could lower the barrier for researchers to apply machine learning in their own domains. Work Package 7 tested that promise by building seven demonstrator projects, each solving a real research problem and each packaged as a self-contained pipeline that runs on NAIC Orchestrator VMs.

The seven use cases cover a wide range of AI techniques and scientific disciplines. Some, like the PEM electrolyzer optimizer (UC2) and pseudo-Hamiltonian networks (UC3), explore how embedding physics into neural networks can produce models that are smaller and generalize better than pure data-driven approaches. Others, like the climate teleconnection analysis (UC1) and AIS vessel classification (UC5), tackle large-scale data-driven discovery, finding patterns that would be impractical to identify manually. The rest address foundational computational challenges: multi-modal optimization (UC6), latent PDE representations (UC7), and medical image registration (UC4).

They all share a common workflow: each demonstrator ships a Jupyter notebook that a researcher can provision on an NAIC Orchestrator VM and run end-to-end, from data loading through training to results, without managing infrastructure.

## Use Case Demonstrators

| Use Case | Title | Repository | Tutorial | DOI | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **UC1** | Climate Indices Teleconnection | [Repository](https://github.com/NAICNO/wp7-UC1-climate-indices-teleconnection) | [Tutorial](https://naicno.github.io/wp7-UC1-climate-indices-teleconnection/) | [10.5281/zenodo.19184215](https://doi.org/10.5281/zenodo.19184215) | **Completed** |
| **UC2** | PEM Electrolyzer PINN Optimizer | [Repository](https://github.com/NAICNO/wp7-UC2-pem-electrolyzer-digital-twin) | [Tutorial](https://naicno.github.io/wp7-UC2-pem-electrolyzer-digital-twin/) | [10.5281/zenodo.19184217](https://doi.org/10.5281/zenodo.19184217) | **Completed** |
| **UC3** | Pseudo-Hamiltonian Neural Networks | [Repository](https://github.com/NAICNO/wp7-UC3-pseudo-hamiltonian-neural-networks) | [Tutorial](https://naicno.github.io/wp7-UC3-pseudo-hamiltonian-neural-networks/) | [10.5281/zenodo.19184219](https://doi.org/10.5281/zenodo.19184219) | **Completed** |
| **UC4** | 3D Medical Image Registration | [Repository](https://github.com/NAICNO/wp7-UC4-medical-image-registration) | [Tutorial](https://naicno.github.io/wp7-UC4-medical-image-registration/) | [10.5281/zenodo.19184221](https://doi.org/10.5281/zenodo.19184221) | **Completed** |
| **UC5** | Graph-Based AIS Classification | [Repository](https://github.com/NAICNO/wp7-UC5-ais-classification-gnn) | [Tutorial](https://naicno.github.io/wp7-UC5-ais-classification-gnn/) | [10.5281/zenodo.19184225](https://doi.org/10.5281/zenodo.19184225) | **Completed** |
| **UC6** | Multi-Modal Optimization | [Repository](https://github.com/NAICNO/wp7-UC6-multimodal-optimization) | [Tutorial](https://naicno.github.io/wp7-UC6-multimodal-optimization/) | [10.5281/zenodo.19184224](https://doi.org/10.5281/zenodo.19184224) | **Completed** |
| **UC7** | Latent Representation of PDE Solutions | [Repository](https://github.com/NAICNO/wp7-UC7-latent-pde-representation) | [Tutorial](https://naicno.github.io/wp7-UC7-latent-pde-representation/) | [10.5281/zenodo.19184227](https://doi.org/10.5281/zenodo.19184227) | **Completed** |

## Summary Deliverables

| ID | Deliverable | Repository | DOI |
|----|-------------|------------|-----|
| D7.10 | Summary of completed demonstrators | [wp7-D710-deliverable-report](https://github.com/NAICNO/wp7-D710-deliverable-report) | [10.5281/zenodo.19184229](https://doi.org/10.5281/zenodo.19184229) |

## Getting Started

Each demonstrator repository includes everything needed to go from `git clone` to results:

1. **Provision a VM** at [orchestrator.naic.no](https://orchestrator.naic.no/)
2. **Clone the repository** and run `setup.sh` to configure the environment
3. **Open the orchestrator notebook** in JupyterLab and run end-to-end

All demonstrators include Sphinx-based tutorials published on GitHub Pages, and six (all except UC4) include `AGENT.md` files that let AI coding assistants set up and run the project autonomously.

## Technology Stack

| Technology | Use Cases | Role |
| :--- | :--- | :--- |
| Python | All | Primary implementation language |
| PyTorch | UC2, UC3, UC5 | Deep learning framework |
| TensorFlow | UC7 | Deep learning framework |
| scikit-learn / XGBoost | UC1 | Classical ML and gradient boosting |
| DGL | UC5 | Graph neural network library |
| ANTsPy / HD-BET | UC4 | Medical image registration and brain extraction |
| CMA-ES / DEAP | UC6 | Evolutionary optimization |

## Infrastructure

| Infrastructure | Use Cases | Purpose |
| :--- | :--- | :--- |
| NAIC Orchestrator VMs | All | GPU-enabled cloud VMs for interactive development and training |
| Jupyter Notebooks | All | Interactive demonstrator interfaces |
| Sphinx Tutorials (GitHub Pages) | All | Multi-chapter tutorial documentation |
| AI Agent Files | UC1, UC2, UC3, UC5, UC6, UC7 | AI coding assistant integration (AGENT.md/AGENT.yaml) |
