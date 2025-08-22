# HH->4b statistical analysis
A framework for performing HH->4b statistical analysis

## Installation
Clone the repository from [gitlab](https://gitlab.cern.ch/atlas-physics/HDBS/DiHiggs/bbbb/statistical_analysis/-/tree/VBFEFT_analysis/EFTVBF_analysis?ref_type=heads)

```bash
# The one from kappa team:
# git clone ssh://git@gitlab.cern.ch:7999/atlas-physics/HDBS/DiHiggs/bbbb/statistical_analysis.git
# For EFT Anna made modifications
git -b VBFEFT_analysis clone ssh://git@gitlab.cern.ch:7999/atlas-physics/HDBS/DiHiggs/bbbb/statistical_analysis.git 
cd statistical_analysis
```
## Scripts for the VBF Boosted EFT analysis.
This directory contains the relevant scripts for the VBF boosted EFT analysis. Similarly to the ggF analysis, it is based on cabinetry. The scripts are modified versions of the one for the VBF boosted analysis.

**Attenion!**
Be sure you are using as input `.parquet` files that contain the VBF boosted reconstruction and were produced using the VBF analysis strategy. This is particularly important as blinding and region definitions are not the same as in the ggF boosted analysis. I created a folder 
```bash
/data/atlas/tamezza/MyEasyJet/Phd_EFT_Studies/InputEFT/
```

To get histograms that will be used as input for the stat analysis, simply run
```bash
python generate_fit_inputs.py --config ../configs/EFTVBF_example.yaml # you can add --plot 
```
This script takes care of all systematics we have implemented so far and makes the BKG estimation from the SR 1Pass. The script saves some details/results in the following files:
.  `generalDetails.txt`
.  `backgroundEstimation.txt`
.  `binningOptimisation`

Run `binningOptimisation` to get the optimised binning 
```bash
python generate_fit_inputs.py --config ../configs/EFTVBF_example.yaml --binningOptimisation
```
and then to put them in the config file `EFTVBF_example.yaml`; you can take the first binning from `M0`, what matters is the last bin that gives us better sensitivity
```bash
python generate_fit_inputs.py --config ../configs/EFTVBF_example.yaml --binningOptimisation
```
The reason why we do this because we need at lesat `one background per bin`and if I look to example below, we see values less than one in last bins (e.g.0.9755028365136698, 0.982207323362561), for that we have to run the `binningOptimisation` to get at least one background per bin
```bash
data-driven background:
values: [1.672769468798337, 1.1967509025270744, 1.1799896854048468, 1.1933986591026289, 1.1732851985559558, 1.1531717380092827, 1.1129448169159366, 1.0593089221248084, 0.9755028365136698, 0.982207323362561]
error: [0.07488344578338108, 0.06333877440948552, 0.0628936615551361, 0.06325000243256089, 0.06271473185670594, 0.06217485324468483, 0.061080782119069435, 0.05959078258128027, 0.057184989020117434, 0.05738116451575751]
unceratinty: [0.04476614810358471, 0.052925612402496255, 0.053300179088902534, 0.05299989400031794, 0.053452248382484795, 0.05391638660171911, 0.05488212999484503, 0.056254395046300996, 0.05862103817605465, 0.05842062378369833]
```

## Running results "Likelihood Scan"

To get the likelihood scan as a function of the Wilson coefficients, simply run
```bash
python likelihood_scan.py --config ../configs/EFTVBF_example.yaml --plot # -v1
```
.  --verbose (-v): Set to debug code. Can be set to 0, 1, 2 or 3, with increasing output

## Config
The parameters of the fit are set in a config file `EFTVBF_example.yaml` 

If I want to run the limist only for Run2 change the `Camps: ["mc20a", "mc20d", "mc20e", "mc23a", "mc23d"]`to include only Run2 `Camps: ["mc20a", "mc20d", "mc20e"]`

If you include more systematics don't forget to include in `utils.py`

```bash
# Should be "nominal" + sig systematics. DDbkg is added by default
SYSTEMATICS = ["xbbdummy", "lumi", "theory"] #added theory
```

# Some Issues
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
1.  Remove the old environment (optional, if you want a clean setup):
```bash
conda deactivate
conda env remove -n statistical_analysis
```
2.  Create the new environment:
```bash
conda env create -f statistical_analysis.yaml
```
3.  Activate it:
4.  ```bash
    conda activate statistical_analysis
```
4.  Run your script:
```bash
python generate_fit_inputs.py --config ../configs/EFTVBF_example.yaml
```
