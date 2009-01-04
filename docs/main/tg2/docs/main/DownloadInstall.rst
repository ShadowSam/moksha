.. highlight:: bash

How to install TurboGears 2
===========================

Installing TurboGears 2 has been made simple with the advent of the package 
index.  We recommend installing TurboGears 2 into a virtual environment
so that any existing packages will not interfere with your installation, and 
so that you don't upgrade any python libraries that your system needs.  

So, with a virtual environment the basic installation goes as follows:

1. Install ``setuptools``

2. Install ``virtualenv``

3. Create a ``virtualenv`` for your project

4. Switch to the ``virtualenv``

5. ``easy_install`` TurboGears development package

6. Profit


Prerequisites
--------------

* Python 2.4 or 2.5
* Appropriate python development package (python*-devel python*-dev)

Setting up setuptools:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On windows: 

download http://peak.telecommunity.com/dist/ez_setup.py and then run it from 
the command line.

On unix: 

If you have curl or  wget installed you can do this with a single command: 

.. code-block:: bash

	$ curl http://peak.telecommunity.com/dist/ez_setup.py | sudo python

Setting up a Virtual Environment
---------------------------------

.. info :: Virtualenv is a tool that you can use to keep your python path clean and tidy.It allows you to install new packages and all of their dependencies into a clean working environment -- thus eliminating the possibility that installing turbogears or some other new package will break your existing python environment.So, while not strictly necessary, we recommend using virtualenv.  

So, first we will install ``virtualenv`` using this command:

On Windows::

    easy_install virtualenv

On Unix: 

You will likely need root permissions to install virtualenv in you your system's site-packages directory: 

.. code-block:: bash

	$ sudo easy_install virtualenv

will output something like:

.. code-block:: text

    Searching for virtualenv
    Reading http://pypi.python.org/simple/virtualenv/
    Best match: virtualenv 1.1
    Downloading http://pypi.python.org/packages/2.5/v/virtualenv/virtualenv-1.1-py2.5.egg#md5=1db8cdd823739c79330a138327239551
    Processing virtualenv-1.1-py2.5.egg
    .....
    Processing dependencies for virtualenv
    Finished processing dependencies for virtualenv

Create a virtual environment:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash
	
	$ virtualenv --no-site-packages tg2env

that produces something like this::

     Using real prefix '/usr/local'
     New python executable in tg2env/bin/python
     Installing setuptools............done.

.. code-block:: bash

	$ cd tg2env

On windows you activate a virtualenv this way::

    Scripts\activate.bat

.. code-block:: bash
	
	$ source bin/activate

and now your prompt should change to indicate that you're in a virtualenv.  It will look something like this (if you're on unix)::

	(tg2env)usrname@host:tgenv$

Install Turbogears 2
---------------------

We've included pre-compiled binaries for windows users, but if you're on unix
you'll need a working version of the GCC compiler installed, as well as the 
python headers.   On OSX this means installing Xcode (available on the OS X cd
or at http://developer.apple.com/tools/xcode/), and on Debian derived linux 
versions this requires python-dev and build-esentials (available via ``apt-get install python-dev``), Fedora users will need the python-devel rpm, etc. 

If you've got the compilers and python header files, you'll be able to install 
the latest version of turbogears via:  

.. code-block:: bash

	$ easy_install -i http://www.turbogears.org/2.0/downloads/current/index tg.devtools

All of turbogears, and all of it's dependencies should download and install themselves.  (This may take a several min.)

Validate the installation:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To check if you installed TurboGears 2 correctly, type

.. code-block:: bash
	
	$ paster --help

should look something like::

    Usage: paster [paster_options] COMMAND [command_options]

    Options:
      --version         show program's version number and exit
      --plugin=PLUGINS  Add a plugin to the list of commands (plugins are Egg
                        specs; will also require() the Egg)
      -h, --help        Show this help message

    Commands:
      create       Create the file layout for a Python distribution
      help         Display help
      make-config  Install a package and create a fresh config file/directory
      points       Show information about entry points
      post         Run a request for the described application
      request      Run a request for the described application
      serve        Serve the described application
      setup-app    Setup an application, given a config file

    TurboGears2:
      quickstart   Create a new TurboGears 2 project.
      tginfo       Show TurboGears 2 related projects and their versions


and you'll see a new "TurboGears2" command section in paster help.

Paster has replaced the old tg-admin command, and most of the tg-admin commands have now been reimplemented as paster commands. For example, "tg-admin quickstart" command has changed to "paster quickstart" command, and "tg-admin info" command has changed to "paster tginfo" command.

Be sure to check out our `What's new in TurboGears 2.0 <WhatsNew.html>`_ page to get a picture of what's changed in TurboGears2 so far.

Special Considerations:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Cygwin** does not include the necessary binary file **sqlite3.dll**; if you want to run cygwin you'll need to install a different database. If you have cygwin installed and you want to use the default setup described here, you must perform all operations, including setup operations, within DOS command windows, not cygwin command windows.


Installing the development version of Turbogears 2 (from source)
-------------------------------------------------------------------

See `Contributing to Turbogears 2`_

.. _Contributing to Turbogears 2: Contributing.html#installing-the-development-version-of-turbogears-2-from-source
