# Frequently Asked Questions

## Infrastructure

**How do I know what resources I need for a demonstrator?**
Each demonstrator repository includes a README describing its computational requirements. The table below summarizes GPU needs:

| UC | GPU Required? | Typical Training Time |
|----|--------------|----------------------|
| UC1 | No (CPU sufficient) | 5–30 min per model |
| UC2 | Recommended | ~10 min (teacher + student) |
| UC3 | Recommended | Varies by system |
| UC4 | No (CPU sufficient) | ~5 min per subject |
| UC5 | Recommended (CUDA 11.8) | ~15 min training |
| UC6 | No (CPU, multi-core helps) | ~5 min per function |
| UC7 | Recommended | ~20 min (autoencoder training) |

**Where can I find the list of available resources?**
See the NAIC resource catalogue maintained by WP2 (deliverable 2.2.2). Sigma2 provides
HPC and cloud resources through NRIS (Norwegian Research Infrastructure Services).

**How much does it cost?**
Sigma2 resources are available to Norwegian researchers through project allocations.
Apply via the NRIS application process. There is no direct monetary cost for approved
research projects.

## Getting Started

**How do I provision a NAIC Orchestrator VM?**
1. Register with [MyAccessID](https://puhuri.neic.no/user_guides/myaccessid_registration/) using your Feide account
2. Login to [orchestrator.naic.no](https://orchestrator.naic.no/)
3. Create a VM — select **NREC UiO** or **NREC UiB** as provider
4. Select **"Virtual machine with GPU (1 x L40S)"** for GPU-accelerated work
5. Download your SSH key and connect via `ssh -i key.pem ubuntu@<VM_IP>`

**Which use case should I start with?**
If you want the most polished experience, start with **UC1**, **UC2**, or **UC6**. These have the most detailed multi-chapter tutorials (8–10 episodes each). All repos include Sphinx documentation and CI/CD pipelines; six (all except UC4) include `AGENT.md` files and `setup.sh` scripts.

**What skills do I need to use a WP7 demonstrator?**
Most demonstrators require familiarity with Python and Jupyter notebooks. Some
demonstrators require additional domain knowledge (e.g., physics-informed neural
networks, genetic algorithms). Prerequisites are listed in each repository README.

**How do I learn to use HPC for my work?**
WP3 (Training) provides courses and materials for getting started with HPC. See the
NAIC training portal for upcoming sessions.

## Technical Setup

**How do I set up JupyterLab on NAIC Orchestrator VMs?**
Each demonstrator repository includes VM setup instructions. The general workflow is:
1. Provision a VM at [https://orchestrator.naic.no](https://orchestrator.naic.no)
2. SSH into the VM and clone the demonstrator repository
3. Run the provided `setup.sh` script to configure the environment
4. Start JupyterLab and create an SSH tunnel from your local machine

See the NRIS documentation at [https://documentation.sigma2.no/](https://documentation.sigma2.no/)
for cluster-specific instructions.

**How do I use GPUs for my tasks?**
GPU access depends on the resource. On NAIC Orchestrator VMs, request a GPU-enabled
flavor when provisioning. On Sigma2 HPC clusters, submit jobs with the appropriate
SLURM partition flags. Each demonstrator that requires GPU access documents the specific
setup in its repository.

**What Python version is required?**
All repositories target **Python 3.11**. CI pipelines use the `python:3.11-slim` Docker image. UC4 uses Conda with Python 3.11 pinned in `environment.yml`.

## Data Access, Sharing, and Reproducibility

**How do I get training data for a demonstrator?**
Each demonstrator repository includes instructions for obtaining its datasets. Some
datasets are bundled in the repository; others must be downloaded separately due to
size or licensing constraints.

**How do I share my results?**
Use the NAIC publication coordination portal (WP5, deliverable 5.4.1) for publishing
results. Repositories can be forked and extended within the NAIC GitLab namespace.

## Using AI Coding Assistants

**Can I use AI coding assistants with the demonstrators?**
Yes. Six repositories (UC1, UC2, UC3, UC5, UC6, UC7) include `AGENT.md` files with machine-readable instructions for AI coding assistants like **Claude Code**, **GitHub Copilot**, or **Cursor**. Tell your assistant:

> "Read AGENT.md and help me run the demonstrator on my NAIC VM."

The assistant will set up the environment and run experiments automatically.

## Demonstrator-specific Questions

**When I try to run a notebook cell I get "library X not found"**
Ensure you have activated the correct Python environment. Each demonstrator provides
a `setup.sh` or `requirements.txt`. Run `pip install -r requirements.txt` within
the activated virtual environment.

**The optimization/training takes a very long time**
Check whether the demonstrator supports parallel execution. For example, the
Multi-Modal Optimization demonstrator offers `MultiModalMinimizerParallel` with
`n_jobs=-1` for multi-core speedup. GPU-based demonstrators require a GPU-enabled
machine.

**Some tests skip when I run pytest — is that a problem?**
No. Tests are designed to skip gracefully when optional heavy dependencies (e.g., DGL, TensorFlow, requests) are not installed. This ensures CI pipelines pass quickly while still validating project structure and code logic. All critical tests run in every environment.

## Collaboration and Next Steps

**How do I get project-specific support to adapt a demonstrator?**
Contact the WP7 team or request project-specific assistance through WP4 (deliverable
4.1.1). We can help adapt demonstrator pipelines to your domain and data.

**How do I cite a WP7 demonstrator in a publication?**
Each demonstrator repository includes citation information in its README or
references section. Some demonstrators build on prior published work:
- UC3: Based on Eidnes et al., *Journal of Computational Physics* (2023), *Applied Mathematics and Computation* (2024)
- UC6: Based on Johannsen et al., *Nordic Machine Intelligence*, 02, 16–27 (2022). [DOI:10.5617/nmi.9633](https://doi.org/10.5617/nmi.9633)

For citing the demonstrators themselves, contact the authors listed in the repository.

**Who do I contact for questions?**

| UC | Contact |
|----|---------|
| UC1 | Klaus Johannsen (NORCE) |
| UC2 | Hasan Asyari Arief (NORCE) |
| UC3 | Sølve Eidnes (SINTEF) |
| UC4 | Saruar Alam (UiB) |
| UC5 | Xue-Cheng Tai (NORCE) |
| UC6 | Klaus Johannsen (NORCE) |
| UC7 | Klaus Johannsen (NORCE) |
| Infrastructure | support@naic.no |
