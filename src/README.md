WISHBONE Specification Sources
==============================

Those are the ReStructuredText (RST) sources for the Wishbone
specification. To build the sources, follow one of the following
guides.

Using Docker
------------

Just create the container:

```
docker build -t wishbone-bld .
```

Then build the documentation:

```
docker run -it -v $PWD:/tmp/src wishbone-bld make -C b3 html latexpdf
```

On your system
--------------

You can just use your standard Python installation. If you want to
build the PDF you will need the texlive installtion. On Ubuntu 18.04
the following should suffice to build the documentation:

```
apt-get -y install python3 python3-pip texlive-latex-base texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra latexmk
```

To install the Python dependencies globally:

```
pip3 install -r requirements.txt
make -C b3 latexpdf html
```

The preferred way is to use Python virtual environments (venv):

```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
make -C b3 latexpdf html
```
