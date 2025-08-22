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
(statistical_analysis) [Wed 25/08/20 10:52 CEST][pts/0][x86_64/linux-gnu/5.14.0-503.14.1.el9_5.x86_64][5.8] <tamezza@lpnatlas02:/data/atlas/tamezza/MyEasyJet/Phd_EFT_Studies/statistical_analysis> zsh/2 10007 (git)-[VBFEFT_analysis]-% python EFTVBF_analysis/generate_fit_inputs.py --config configs/EFTVBF_example.yaml zsh: illegal hardware instruction (core dumped) python EFTVBF_analysis/generate_fit_inputs.py --config
```
