"""Test Secure Controller"""
from moksha.lib.base import BaseController, SecureController
from tg import expose, flash
from pylons.i18n import ugettext as _
#from tg import redirect, validate
#from moksha.model import DBSession, metadata
#from dbsprockets.dbmechanic.frameworks.tg2 import DBMechanic
#from dbsprockets.saprovider import SAProvider
from repoze.what.predicates import has_permission


class Secc(SecureController):

    require = has_permission('manage')

    @expose('moksha.templates.index')
    def index(self):
        flash(_("Secure Controller here"))
        return dict(page='index')

    @expose('moksha.templates.index')
    def some_where(self):
        """should be protected because of the require attr
        at the controller level.
        """
        return dict()
