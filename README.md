# Jupyter Notebooks and Virtual Environments

Run one `jupyter notebook` server per user, but allow notebooks to be created in multiple Python virtual environments.

These instructions assume a shell environment similar to:

```text
WORKON_HOME=$HOME/.virtualenvs
PROJECT_HOME=$HOME/Code
```


## Install Jupyter

**Note**: If you're using the Anaconda distribution of Python, you can probably skip this step, and just run `jupyter notebook` in the default environment.

Install Jupyter and useful tools like Pandas into a new virtual environment: 

```text
$ python3 -m venv $WORKON_HOME/jupyter-venv
$ source $WORKON_HOME/jupyter-venv/bin/activate
(jupyter-venv)$ cd $PROJECT_HOME
(jupyter-venv)$ git clone https://github.com/bhrutledge/jupyter-venv.git
(jupyter-venv)$ cd jupyter-venv
(jupyter-venv)$ pip install -r requirements.txt
(jupyter-venv)$ jupyter nbextension enable --py --sys-prefix widgetsnbextension
(jupyter-venv)$ jupyter contrib nbextension install --sys-prefix
(jupyter-venv)$ jupyter notebook
```

You should now see the Jupyter Notebook server in your web browser, and you can create notebooks using `New > Python 3`:

![After install](img/nb-install.png)


## Add virtual environment kernels

In a new shell session, switch to one of your virtual environments, and install an IPython kernel:

```text
$ source $WORKON_HOME/my-project/bin/activate

# The `ipykernel` package should be added to this environment's requirements.txt
(my-project)$ pip install ipykernel

(my-project)$ python -m ipykernel install --user --name="$(basename $VIRTUAL_ENV)"
```

On macOS, this will create a Jupyter kernel spec in `$HOME/Library/Jupyter/kernels/my-project`. You can edit `kernel.json` in that directory to set environment variables or pass additional arguments to `python`.


## Location of notebooks

By default, new notebooks are created at the root directory of the notebook server (`~/Code/jupyter-venv` in this example). However, this means that notebooks created using the `my-project` kernel will live in the `jupyter-venv` directory. If you'd prefer that notebooks using the `my-project` kernel live in the `my-project` directory (e.g., to commit them to the same Git repo), you could create a symbolic link in the `jupyter-venv` directory:

```text
(jupyter-venv)$ mkdir venvs
(jupyter-venv)$ echo venvs >> .gitignore
(jupyter-venv)$ VENV=my-project
(jupyter-venv)$ mkdir "$PROJECT_HOME/$VENV/jupyter-notebooks"
(jupyter-venv)$ ln -s "$PROJECT_HOME/$VENV/jupyter-notebooks" "venvs/$VENV"
```

Alternatively, you could run `jupyter notebook` from a parent directory containing all of your projects, and navigate to the `my-project` directory.


## Creating notebooks inside a virtual environment

Now, reload your Jupyter Notebook browser tab, and you should see the sub-directory that you created:

![Project sub-directory](img/nb-venvs-dir.png)

Click `venvs`, then `my-project`, then use `New > my-project` to create a notebook:

![Project kernel](img/nb-my-project-kernel.png)

You can now use all of the packages that are installed in the `my-project` environment. It also means that you can't use the packages in the `jupyter-venv` environment, used by the default `Python 3` kernel. So, if you want to use packages like Pandas or matplotlib, you'll need to `pip install` them in the `my-project` environment (ideally by adding them to its `requirements.txt`).


## Reference

* [Enabling ipywidgets](https://ipywidgets.readthedocs.io/en/stable/user_install.html)
* [Using a virtualenv in an IPython notebook](http://help.pythonanywhere.com/pages/IPythonNotebookVirtualenvs)
* [Installing the IPython kernel](https://ipython.readthedocs.io/en/latest/install/kernel_install.html)
* [Making kernels for Jupyter](https://jupyter-client.readthedocs.io/en/latest/kernels.html)


## TODO

- Rationale for not running `jupyter notebook` in project's virtual environment
- Shell script for adding kernel and symlinking notebook directory
- `brew install jupyter`?
