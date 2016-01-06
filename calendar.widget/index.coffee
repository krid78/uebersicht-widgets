# vim: ts=2:sts=2:sw=2
# show calendar of this month

command: 'python calendar.widget/cal.py monday'

# refersh every 30 minutes
refreshFrequency: 1800000

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
  right 10%
  //transform translate(-50%, 0)

  // Statistics text settings
  color: fgcol(1)
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px

  table
    border-collapse: collapse
    table-layout: fixed

  td
    text-align: center
    padding: 4px 6px
    //text-shadow: 0 0 1px rgba(#000, 0.5)

  thead tr
    &:first-child td
      font-size  1.17em
      font-weight 200
      border-top solid 1px bghcol()
      border-bottom solid 1px bghcol()
    //background-color bghcol(.5)
    //border-radius 5px

    &:last-child td
      font-size: 0.95em
      padding-bottom: 10px
      font-weight: 500

  tbody td
    font-size: 1em

  .today
    font-weight bold
    background bghcol(.5)
    //background rgba(#000,.25)
    border-radius 45%
"""

render: -> """
  <table>
    <thead>
    </thead>
    <tbody>
    </tbody>
  </table>
"""

updateHeader: (rows, table) ->
  thead = table.find("thead")
  thead.empty()

  thead.append "<tr><td colspan='7'>#{rows[0]}</td></tr>"
  tableRow = $("<tr></tr>").appendTo(thead)
  daysOfWeek = rows[1].split(/\s+/)

  for dayOfWeek in daysOfWeek
    tableRow.append "<td>#{dayOfWeek}</td>"

updateBody: (rows, table) ->
  tbody = table.find("tbody")
  tbody.empty()

  rows.splice 0, 2
  rows.pop()
  today = rows.pop().split(/\s+/)[2]

  for week, i in rows
    days = week.split(/\s+/).filter (day) -> day.length > 0
    tableRow = $("<tr></tr>").appendTo(tbody)

    if i == 0 and days.length < 7
      for j in [days.length...7]
        tableRow.append "<td></td>"

    for day in days
      cell = $("<td>#{day}</td>").appendTo(tableRow)
      cell.addClass("today") if day == today

update: (output, domEl) ->
  rows = output.split("\n")
  table = $(domEl).find("table")

  @updateHeader rows, table
  @updateBody rows, table
