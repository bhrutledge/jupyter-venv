# Jupyter Notebooks and Virtual Environments

Run one `jupyter notebook` server per user, but allow notebooks to be created in multiple Python virtual environments.

## Install Jupyter

**Note**: If you're using the Anaconda distribution of Python, you can probably skip this step, and just run `jupyter notebook` in the default environment.

Clone this repo, then install Jupyter and useful tools like Pandas into a virtual environment:

```sh
cd jupyter-venv

python3 -m venv venv

source venv/bin/activate

pip install -U setuptools wheel pip pip-tools

pip-sync

jupyter nbextension enable --py --sys-prefix widgetsnbextension

jupyter labextension install @jupyter-widgets/jupyterlab-manager

deactivate
```

To run Jupyter without needing to activate its virtual environment, add a symbolic link to the `jupyter` executable in a directory in your `$PATH`, e.g.:

```sh
ln -sfv "$PWD/venv/bin/jupyter" "$HOME/.local/bin/jupyter"
```

Run the notebook server in your home directory:

```sh
cd

jupyter notebook
```

You should now see the Jupyter Notebook application in your web browser, showing the contents of your home directory. To create a notebook, navigate to the directory where you'd like to save it, then click `New > Python 3`.

You can also run JupyterLab:

```sh
jupyter lab
```

## Creating notebooks for a virtual environment

In a new shell session, activate the virtual environment for one of your projects, and install an IPython kernel:

```sh
cd my-project

source venv/bin/activate

pip install ipykernel

python -m ipykernel install --user --name=my-project

deactivate
```

- **NOTE**: The `ipykernel` package should be added to the project's `requirements.txt`

On macOS, this will create a Jupyter kernel spec in `$HOME/Library/Jupyter/kernels/my-project`. You can edit `kernel.json` in that directory to set environment variables or pass additional arguments to `python`.

Reload your Jupyter Notebook browser tab, then use `New > my-project` to create a notebook. You can now use all of the packages that are installed in the `my-project` environment. However, this means you can't use the packages in the `jupyter-venv` environment, used by the default `Python 3` kernel. If you want to use packages like Pandas or matplotlib, you'll need to `pip install` them in the `my-project` environment (ideally by adding them to its `requirements.txt`).

## Run as a service on macOS

```sh
cd jupyter-venv

./load_launch_agent.sh
```

This will write a `.plist` file to run the notebook server at <http://localhost:8888>, then show the contents of the log file. Typing `Ctrl-C` will return to the prompt, but leave the server running. When you reboot, the server will start automatically.

For JupyterLab, running at <http://localhost:8889>:

```sh
./load_launch_agent.sh lab 8889
```

## Reference

- [Enabling ipywidgets](https://ipywidgets.readthedocs.io/en/stable/user_install.html)
- [Using a virtualenv in an IPython notebook](http://help.pythonanywhere.com/pages/IPythonNotebookVirtualenvs)
- [Installing the IPython kernel](https://ipython.readthedocs.io/en/latest/install/kernel_install.html)
- [Making kernels for Jupyter](https://jupyter-client.readthedocs.io/en/latest/kernels.html)

## TODO

- Document rationale for one notebook server per user vs. running `jupyter notebook` in project's virtual environment
- `Makefile` or shell script for creating virtual environment, adding kernel, updating requirements, installing service
- Use configuration file to set root notebook directory
- Add a `supervisord` configuration?
