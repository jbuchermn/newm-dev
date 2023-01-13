from __future__ import annotations

import logging
import sys

from .compositor import Compositor

logger = logging.getLogger(__name__)

def run() -> None:
    print("pywm-fullscreen (python) - args are %s" % str(sys.argv), flush=True)


    handler = logging.StreamHandler()
    formatter = logging.Formatter('[%(levelname)s] %(filename)s:%(lineno)s %(asctime)s: %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

    handler.setLevel(logging.DEBUG)
    handler.setFormatter(formatter)

    for l in ["pywm_fullscreen"]:
        log = logging.getLogger(l)
        log.setLevel(logging.DEBUG)
        log.addHandler(handler)

    wm = Compositor()

    try:
        wm.run()
    except Exception:
        logger.exception("Unexpected")
    finally:
        wm.terminate()
