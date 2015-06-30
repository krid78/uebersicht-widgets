#!/usr/bin/env python
# vim: ts=4:sw=4:sts=4:tw=120:expandtab:fileencoding=utf-8

"""
Package       :  ical_overview
Author(s)     :  Daniel Kriesten
Email         :  daniel.kriesten@etit.tu-chemnitz.de
Creation Date :  Mo  8 Sep 09:29:41 2014

return a list of upcomming iCal events as plain text or JSON

Inspired by icalBuddy and calStoreHelper, both written by Ali Rantakari
"""
import sys
import argparse
import datetime as dt
import EventKit

import logging
__logger__ = logging.getLogger(__name__)
import logging.handlers

class CalWrapper(object):
    """TODO Docstring"""

    def __init__(self):
        """initialize the class"""
        self.evstore = EventKit.EKEventStore.alloc().init()

    def _calendar_list(self, filter_=None):
        """TODO Docstring"""
        pass

    def __str__(self):
        """TODO Docstring"""
        pass

    def filter(self, filter_=None):
        """TODO docstring"""
        self._calendar_list(filter_)

    def print_json(self):
        """TODO Docstring"""
        pass

def main():
    """Main
    interprets all the arguments, instanziates the helper class and returns the output
    :returns: list of upcomming ical events
    """
    # some arguments to care fore
    parser = argparse.ArgumentParser(
        description=u"Print out iCal events as plain text",
        epilog=u"Tested with iCal and pyobjc 3.0.1",
        conflict_handler="resolve")
    parser.add_argument("--version", action="version", version="%(prog)s 0.1")
    parser.add_argument("-v",
                        "--verbose",
                        default=False,
                        action="store_true",
                        help="be verbose")
    parser.add_argument("-b",
                        "--begin",
                        default=False,
                        action="store_true",
                        help="parse events beginning at @begin")
    parser.add_argument("-e",
                        "--end",
                        default=False,
                        action="store_true",
                        help="parse only events between begin and end")
    parser.add_argument("-d",
                        "--days",
                        default=False,
                        action="store_true",
                        help="number of days to show, alternative to --end")
    parser.add_argument("-j",
                        "--json",
                        default=False,
                        action="store_true",
                        help="output the list in JSON format")

    (options, args) = parser.parse_known_args()
    __logger__.debug("Args: %s", args)

    ######################
    # instantiate a logger
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    handler = logging.StreamHandler(stream=sys.stderr)

    if options.verbose:
        handler.setLevel(logging.DEBUG)
    else:
        handler.setLevel(logging.INFO)

    handler.setFormatter(logging.Formatter("-- %(funcName)s [%(levelname)s]: %(message)s"))
    logger.addHandler(handler)

    ###########################
    # get current date and time
    thisday = dt.datetime.now()

    __logger__.info("Run for %s", thisday)

    if options.json:
        sys.stdout.write("print as json")

    helper = CalWrapper()
    #helper.update()
    __logger__.debug("%s", helper)
    #helper.filter(["krid", "Henriette"])
    __logger__.debug("%s", helper)

    if options.json:
        helper.print_json()

    __logger__.info("End run for %s", thisday)

if __name__ == '__main__':
    main()
