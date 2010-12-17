from zope.sqlalchemy import ZopeTransactionExtension
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

maker = sessionmaker(autoflush=True, autocommit=False,
                     extension=ZopeTransactionExtension())
DBSession = scoped_session(maker)
DeclarativeBase = declarative_base()
metadata = DeclarativeBase.metadata

def init_model(engine):
    print "init_model(%s)" % engine
    DBSession.configure(bind=engine)

from model import HelloWorldModel
