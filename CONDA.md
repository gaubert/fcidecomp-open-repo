# Installation of conda and fcidecomp package 

- [installation via ``conda``](#installation-from-conda-package) using pre-built packages,

  supported for the following Operating Systems (although other Linux and Windows systems with 
  a conda installation on them should allow installation as well):
  - RockyLinux 8 64-bit
  - AlmaLinux 8 64-bit
  - Linux Ubuntu 18.04 LTS 64-bit
  - Linux Ubuntu 20.04 LTS 64-bit
  - Windows 10 64-bit
  - Windows 11 64-bit

### Pre-requisites

Installation requires:

- `conda`, installed as described
  [here](<https://conda.io/projects/conda/en/latest/user-guide/install/index.html>)

### Installation

Start by creating a new `conda` environment. Let's call it `fcidecomp`, but
any valid name would do (change the following instructions accordingly):

    conda create -n fcidecomp python=$PYTHON_VERSION
    
where Python versions currently supported by ``fcidecomp`` are 3.9 <= `$PYTHON_VERSION` <= 3.12 (3.11 for Windows).

Activate the environment:

    conda activate fcidecomp

Now execute:

    conda install -y -c anaconda -c conda-forge -c eumetsat fcidecomp

### Post-installation configuration

Once the installation has completed, re-activate the `conda` environment running the following commands:

    conda deactivate
    conda activate fcidecomp
    
This last step ensures the `HDF5_PLUGIN_PATH` environment variable is correctly set to the directory containing the
FCIDECOMP decompression libraries.

