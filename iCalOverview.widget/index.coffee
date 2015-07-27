# show upcomming calendar events

command: "/usr/bin/swift iCalOverview.widget/ical_overview.swift \
--tage 4 \
--include Daniel,krid,WICHTIG,Jenny\\ Privat,Jenny\\ Büro,Henriette,Family,Auto\\ unterwegs,Geburtstage,Deutsche\\ Feiertage"

# refersh every 15 minutes
refreshFrequency: 900000

style: """
  //@import '/solarized.styl'
  base03(a=1)
    rgba(00,43,54,a) // #002b36
  base02(a=1)
    rgba(07,54,66,a) // #073642
  base01(a=1)
    rgba(88,110,117,a) // #586e75
  base00(a=1)
    rgba(101,123,131,a) // #657b83
  base0(a=1)
    rgba(131,148,150,a) // #839496
  base1(a=1)
    rgba(147,161,161,a) // #93a1a1
  base2(a=1)
    rgba(238,232,213,a) // #eee8d5
  base3(a=1)
    rgba(253,246,227,a) // #fdf6e3
  syellow(a=1)
    rgba(181,137,0,a) // #b58900
  sorange(a=1)
    rgba(203,75,22,a) // #cb4b16
  sred(a=1)
    rgba(220,50,47,a) // #dc322f
  smagenta(a=1)
    rgba(211,54,130,a) // #d33682
  sviolet(a=1)
    rgba(108,113,196,a) // #6c71c4
  sblue(a=1)
    rgba(38,139,210,a) // #268bd2
  scyan(a=1)
    rgba(42,161,152,a) // #2aa198
  sgreen(a=1)
    rgba(133,153,0,a) // #859900

  // Position this where you want
  top 1%
  left 50%
  transform translate(-50%, 0)
  width 30%
  //height 75%

  // Statistics text settings
  color: base00()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px
  //border solid 1px base2()

  .container
    margin 0px
    //width 220px
    //border solid 1px base2()

  .adate
    padding 4px 6px
    margin-bottom 1ex
    font-size 1.2em
    text-transform uppercase
    font-weight 200
    border-top solid 1px base2()
    border-bottom solid 1px base2()
    width 60%
    //background-color base2()
    //border-radius 5px

  ul
    display table
    padding 0px
    margin auto 0px 2% 0px

  li
    padding 0.4%
    margin 0px
    display: table-row
    list-style none
    //border solid 1px base2()

  ul li:before
    content '»'
    //margin 0 .6em
    padding 0 .6em
    display table-cell
    //border solid 1px base2()

  ul.Daniel li:before
    color scyan()

  ul.krid li:before
    color sgreen()

  ul.WICHTIG li:before
    color sred()

  ul.JennyPrivat li:before
    color sorange()

  ul.JennyBüro li:before
    color sorange()

  ul.Henriette li:before
    color sblue()

  ul.Family li:before
    color syellow()

  ul.Autounterwegs li:before
    color sviolet()

  ul.Geburtstage li:before
    color smagenta()

  ul.DeutscheFeiertage li:before
    color smagenta()


"""

render: -> """
  <div class="container">
    <div id="icallist">
    </div>
  </div>
"""

update: (output, domEl) ->
  console.log('EventsForNextDays')
  dateObjectList = JSON.parse output
  container = $(domEl).find("#icallist")
  container.empty()

  for dateObject in dateObjectList['EventsForNextDays']
    dates = Object.keys(dateObject)
    console.log(dates)

    if dates.length != 1
      console.log("More than one date!")

    headline = $("<div></div>").appendTo(container)
    headline.addClass("adate")
    headline.append("#{dates[0]}")

    for calendarObject in dateObject[dates[0]]
      calendars =  Object.keys(calendarObject)
      console.log(calendars)

      if calendars.length != 1
        console.log("More than one calendar!")

      list = $("<ul></ul>").appendTo(container)
      list.addClass("#{calendars[0].replace(" ","")}")

      for eventObject in calendarObject[calendars[0]]
        events =  Object.keys(eventObject)
        console.log(eventObject)
        console.log(events)

        litem = $("<li></li>").appendTo(list)
        litem.append("#{eventObject['titel']}<br />#{eventObject['start']} - #{eventObject['ende']} Uhr")

# vim: expandtab:ts=2:sts=2:sw=2