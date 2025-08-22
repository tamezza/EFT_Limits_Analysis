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
