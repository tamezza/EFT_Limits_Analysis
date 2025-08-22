# HH->4b statistical analysis
A framework for performing HH->4b statistical analysis

## Installation
Clone the repository from gitlab

```bash
# The one from kappa team:
# git clone ssh://git@gitlab.cern.ch:7999/atlas-physics/HDBS/DiHiggs/bbbb/statistical_analysis.git
# For EFT Anna made modifications
git -b VBFEFT_analysis clone ssh://git@gitlab.cern.ch:7999/atlas-physics/HDBS/DiHiggs/bbbb/statistical_analysis.git 
cd statistical_analysis
```

I had issue setting up conda regrading some independies for python kind got 

```bash
(git)-[VBFEFT_analysis]-% python EFTVBF_analysis/generate_fit_inputs.py --config configs/EFTVBF_example.yaml
zsh: illegal hardware instruction (core dumped) python EFTVBF_analysis/generate_fit_inputs.py --config
```
A “zsh: illegal hardware instruction (core dumped)” usually means that Python crashed at a very low level, often because: A compiled extension (like uproot, hist, cabinetry, or numpy) is incompatible with your CPU. There’s a mismatch between the conda environment’s packages and your system libraries.
Sometimes Python compiled with optimizations uses CPU instructions your processor doesn’t support. To solve the problem I had create a `conda environment YAML ` configuration to statistical_analysis setup  `statistical_analysis.yaml` that avoids these crashes on the cluster CPU. 
conda environment YAML tuned for stability on typical cluster CPUs (no risky AVX instructions) and compatible with the `generate_fit_inputs.py script`:
```bash
name: statistical_analysis
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.10
  - numpy=1.25
  - pandas
  - pyyaml
  - uproot
  - hist
  - histoprint
  - cabinetry
  - pip
```
🔧 How to use it
1-  Remove the old environment (optional, if you want a clean setup):
```bash
conda deactivate
conda env remove -n statistical_analysis
```
2-  Create the new environment:
```bash
conda env create -f statistical_analysis.yaml
```
