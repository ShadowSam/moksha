"""Pylons environment configuration"""
import os

from pylons import config

from pylons.i18n import ugettext
from genshi.filters import Translator
from tg import defaults
from sqlalchemy import engine_from_config

import wiki20.lib.app_globals as app_globals

def template_loaded(template):
    "Plug-in our i18n function to Genshi."
    template.filters.insert(0, Translator(ugettext))

def load_environment(global_conf, app_conf):
    """Configure the Pylons environment via the ``pylons.config``
    object
    """
    # Pylons paths
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    paths = dict(root=root,
                 controllers=os.path.join(root, 'controllers'),
                 static_files=os.path.join(root, 'public'),
                 templates=[os.path.join(root, 'templates')])
    
    # This setups up a set of default route that enables a standard
    # TG2 style object dispatch.   Fell free to overide it with 
    # custom routes.  TODO: Link to TG2+routes doc. 
    
    make_map = defaults.make_default_route_map
    
    # Initialize config with the basic options
    config.init_app(global_conf, app_conf, package='wiki20',
                    template_engine='genshi', paths=paths)
    config['routes.map'] = make_map()                
    config['pylons.g'] = app_globals.Globals()
    config['pylons.g'].sa_engine = engine_from_config(config, 'sqlalchemy.')

    # Customize templating options via this variable
    tmpl_options = config['buffet.template_options']
    tmpl_options['genshi.loader_callback'] = template_loaded

    # CONFIGURATION OPTIONS HERE (note: all config options will override
    # any Pylons config options)

    from wiki20 import model
    model.DBSession.configure(bind=config['pylons.g'].sa_engine)
    model.metadata.bind = config['pylons.g'].sa_engine
    
