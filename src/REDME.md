WISHBONE Specification Sources
==============================

Those are the ReStructuredText (RST) sources for the Wishbone
specification. To build the sources, follow these steps:

```
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
make -C b3 latexpdf html
```
