#!/usr/bin/env python
# Author: Daniel Kriesten <daniel@die-kriestens.de>

"""
Simple python script to get a calendar
"""

import sys
import locale
import datetime as dt
import calendar

def main(weekday='monday'):
    """The main function for this module"""

    lce = locale.getdefaultlocale()
    if weekday.lower() != "monday":
        sow = calendar.SUNDAY
    else:
        sow = calendar.MONDAY

    ltcal = calendar.LocaleTextCalendar(sow, lce)

    today = dt.date.today()
    tcal = ltcal.formatmonth(today.year, today.month)

    sys.stdout.write(tcal + today.strftime("%c") + "\n")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        main()
