from setuptools import setup

setup(name='pywm-grid',
      version='0.1',
      description='pywm grid',
      url="https://github.com/jbuchermn/pywm-grid",
      author='Jonas Bucher',
      author_email='j.bucher.mn@gmail.com',
      packages=['pywm_grid'],
      scripts=['bin/pywm-grid', 'bin/.pywm-grid'],
      install_requires=[])
