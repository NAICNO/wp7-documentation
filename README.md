# WP7 Demonstrators - Documentation

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19184233.svg)](https://doi.org/10.5281/zenodo.19184233)


Documentation site for NAIC Work Package 7 (WP7) - Demonstrators.

WP7 is responsible for the design and implementation of demonstrators that showcase
the abilities of NAIC. Each demonstrator connects to a research community, formulates
a use case as a ML/AI task, and provides a complete pipeline from data to results.

## Rendered Documentation

[View the documentation site](https://naicno.github.io/wp7-documentation)

## Use Case Demonstrators

| UC | Title | Repository | Tutorial | Status |
|----|-------|-----------|----------|--------|
| UC1 | Climate Indices Teleconnection | [wp7-UC1-climate-indices-teleconnection](https://github.com/NAICNO/wp7-UC1-climate-indices-teleconnection) | [Tutorial](https://naicno.github.io/wp7-UC1-climate-indices-teleconnection/) | Completed |
| UC2 | PEM Electrolyzer PINN Optimizer | [wp7-UC2-pem-electrolyzer-digital-twin](https://github.com/NAICNO/wp7-UC2-pem-electrolyzer-digital-twin) | [Tutorial](https://naicno.github.io/wp7-UC2-pem-electrolyzer-digital-twin/) | Completed |
| UC3 | Pseudo-Hamiltonian Neural Networks | [wp7-UC3-pseudo-hamiltonian-neural-networks](https://github.com/NAICNO/wp7-UC3-pseudo-hamiltonian-neural-networks) | [Tutorial](https://naicno.github.io/wp7-UC3-pseudo-hamiltonian-neural-networks/) | Completed |
| UC4 | 3D Medical Image Registration | [wp7-UC4-medical-image-registration](https://github.com/NAICNO/wp7-UC4-medical-image-registration) | [Tutorial](https://naicno.github.io/wp7-UC4-medical-image-registration/) | Completed |
| UC5 | Graph-Based Classification of AIS Data | [wp7-UC5-ais-classification-gnn](https://github.com/NAICNO/wp7-UC5-ais-classification-gnn) | [Tutorial](https://naicno.github.io/wp7-UC5-ais-classification-gnn/) | Completed |
| UC6 | Multi-Modal Optimization | [wp7-UC6-multimodal-optimization](https://github.com/NAICNO/wp7-UC6-multimodal-optimization) | [Tutorial](https://naicno.github.io/wp7-UC6-multimodal-optimization/) | Completed |
| UC7 | Latent Representation of PDE Solutions | [wp7-UC7-latent-pde-representation](https://github.com/NAICNO/wp7-UC7-latent-pde-representation) | [Tutorial](https://naicno.github.io/wp7-UC7-latent-pde-representation/) | Completed |

## Summary Deliverables

| ID | Deliverable | Repository |
|----|-------------|------------|
| D7.10 | Summary of completed demonstrators | [wp7-D710-deliverable-report](https://github.com/NAICNO/wp7-D710-deliverable-report) |

## Building Locally

```bash
pip install -r requirements.txt
sphinx-build -b html documents build/html
```

The built site will be in `build/html/`.
