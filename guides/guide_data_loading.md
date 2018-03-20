### Data Loading Process

* Process data files to transmart expected format
* Create mappings with `tmtk`
* Load with `transmart-batch`

### `tmtk`

`tmtk` is a Python package for preparing study data before loading in tranSMART using `transmart-batch`.

Install the toolkit:

```
git clone https://github.com/thehyve/tmtk.git
pip3 install -e tmtk
cd tmtk
jupyter-nbextension install --py tmtk.arborist
jupyter-serverextension enable tmtk.arborist
```

Can then use the package with `import tmtk`.

### Arborist

The Arborist is a visual data editor for collaborating on the concept/data tree.

