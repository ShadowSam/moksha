"""The base Controller API

Provides the BaseController class for subclassing.
"""
from tg import TGController, tmpl_context, request
from tg.render import render
from tw.api import WidgetBunch
from pylons.i18n import _, ungettext, N_

import moksha.model as model

from moksha.api.widgets.stomp import stomp_widget


class Controller(object):
    """Base class for a web application's controller.

    Currently, this provides positional parameters functionality
    via a standard default method.
    """

class BaseController(TGController):
    """Base class for the root of a web application.

    Your web application should have one of these. The root of
    your application is used to compute URLs used by your app.
    """

    def __call__(self, environ, start_response):
        """Invoke the Controller"""
        # TGController.__call__ dispatches to the Controller method
        # the request is routed to. This routing information is
        # available in environ['pylons.routes_dict']
        tmpl_context.stomp = stomp_widget
        request.identity = request.environ.get('repoze.who.identity')
        tmpl_context.identity = request.identity
        return TGController.__call__(self, environ, start_response)
