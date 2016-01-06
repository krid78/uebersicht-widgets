# vim: ts=2:sts=2:sw=2
# show upcomming calendar events

command: "/usr/bin/swift iCalOverview.widget/ical_overview.swift \
--tage 4 \
--include Daniel,krid,WICHTIG,Jenny\\ Privat,Jenny\\ Büro,Henriette,Family,Auto\\ unterwegs,Deutsche\\ Feiertage"

# refersh every 15 minutes
refreshFrequency: 900000

style: """
  // the base color selector light or dark
  the-bg = "light"

  // the actual color definition. For base16, its done in a quite generic way...
  base00(a=1)     // dark: bg
    rgba(00,43,54,a)    // #002b36
  base01(a=1)     // dark: bg highlight
    rgba(07,54,66,a)    // #073642
  base02(a=1)     // light: emphasized; dark: comment
    rgba(88,110,117,a)  // #586e75
  base03(a=1)     // light: std. text
    rgba(101,123,131,a) // #657b83
  base04(a=1)     // dark: std. text
    rgba(131,148,150,a) // #839496
  base05(a=1)     // light: comment; dark: emphasized
    rgba(147,161,161,a) // #93a1a1
  base06(a=1)     // light: bg highlight
    rgba(238,232,213,a) // #eee8d5
  base07(a=1)     // light: bg
    rgba(253,246,227,a) // #fdf6e3
  base08(a=1)     // syellow
    rgba(181,137,0,a)   // #b58900
  base09(a=1)     // sorange
    rgba(203,75,22,a)   // #cb4b16
  base0A(a=1)     // sred
    rgba(220,50,47,a)   // #dc322f
  base0B(a=1)     // smagenta
    rgba(211,54,130,a)  // #d33682
  base0C(a=1)     // sviolet
    rgba(108,113,196,a) // #6c71c4
  base0D(a=1)     // sblue
    rgba(38,139,210,a)  // #268bd2
  base0E(a=1)     // scyan
    rgba(42,161,152,a)  // #2aa198
  base0F(a=1)     // sgreen
    rgba(133,153,0,a)   // #859900

  // generic, selector-dependend color selection
  bgcol(a=1)
    if the-bg == "light"
      base07(a)
    else
      base01(a)
  bghcol(a=1)
    if the-bg == "light"
      base06(a)
    else
      base01(a)
  fgcol(a=1)
    if the-bg == "light"
      base03(a)
    else
      base04(a)
  fghcol(a=1)
    if the-bg == "light"
      base02(a)
    else
      base05(a)
  comment(a=1)
    if the-bg == "light"
      base05(a)
    else
      base02(a)

  // solarized equivalenz wrapper
  syellow(a=1)
    base08(a)
  sorange(a=1)
    base09(a)
  sred(a=1)
    base0A(a)
  smagenta(a=1)
    base0B(a)
  sviolet(a=1)
    base0C(a)
  sblue(a=1)
    base0D(a)
  scyan(a=1)
    base0E(a)
  sgreen(a=1)
    base0F(a)

  // Position this where you want
  top 1%
  left 50%
  transform translate(-50%, 0)
  width 30%
  //height 75%

  // Statistics text settings
  color: fgcol()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px
  //border solid 1px bghcol()

  .container
    margin 0px
    //width 220px
    //border solid 1px bghcol()

  .adate
    padding 4px 6px
    margin-bottom 1ex
    font-size 1.2em
    text-transform uppercase
    font-weight 200
    width 60%
    border-top solid 1px bghcol()
    border-bottom solid 1px bghcol()
    //background-color bghcol()
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
    //border solid 1px bghcol()

  ul li:before
    content '»'
    //margin 0 .6em
    padding 0 .6em
    display table-cell
    //border solid 1px bghcol()

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
