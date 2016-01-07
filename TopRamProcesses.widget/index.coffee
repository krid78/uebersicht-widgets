# vim: ts=2:sts=2:sw=2
# show topmost processes, colors indicate ram usage

command: "ps -amcwwwxo \"command rss %mem\""

# refersh every 5 seconds
refreshFrequency: 5000

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
  left 27%
  transform translate(-50%, 0)
  margin:0
  padding:0px

  // Statistics text settings
  color fgcol()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px

  // background and border
  // background bghcol(.5)
  // border:1px solid bghcol()
  // border-radius:5px

  .container
    min-width 220px

  .widget-title
    text-align: center
    padding 4px 6px
    margin-bottom 1ex
    font-size  1.17em
    font-weight 200
    border-top solid 1px bghcol()
    border-bottom solid 1px bghcol()
    //background-color bghcol(.5)
    //border-radius 5px

  table
    border-collapse collapse
    width 100%
    //table-layout fixed

  .process
    text-align left
    width 50%

  .memstr
    text-align right

  .mempl
    text-align right
    width 6px

  .memp
    text-align right

  .mempr
    text-align left
    width 15px

  .memp-xhuge
    color sred()

  .memp-huge
    color smagenta()

  .memp-high
    color sorange()

  .memp-increased
    color syellow()

  .memp-raised
    color fghcol()

  .memp-normal
    color fgcol()


"""

render: -> """
  <div class="container">
    <div class="widget-title">Top RAM Processes</div>
    <table class="ramstats">
      <tbody>
      </tbody>
    </table>
  </div>
"""

updateBody: (tbody, rows) ->
  for row in rows
    tableRow = $("<tr></tr>").appendTo(tbody)

    cells = row.split(/\s+/)

    process = cells[0..-3]
    if process.length > 15
      process = process[0..12] + "..."

    mem = parseInt(cells[-2..-1])
    if mem > 1048576
      memstr = (mem/1048576.0).toFixed(2) + "G"
    else if mem > 1024
      memstr = (mem/1024.0).toFixed(2) + "M"
    else
      memstr = mem.toFixed(2) + "k"

    memp = parseFloat(cells[-1..]).toFixed(1)
    if memp > 50
      tableRow.addClass("memp-xhuge")
    else if memp > 35
      tableRow.addClass("memp-huge")
    else if memp > 20
      tableRow.addClass("memp-high")
    else if memp > 10
      tableRow.addClass("memp-increased")
    else if memp > 5
      tableRow.addClass("memp-raised")
    else
      tableRow.addClass("memp-normal")


    tableRow.append "<td class=\"process\">#{cells[0]}</td>"
    tableRow.append "<td class=\"memstr\">#{memstr}</td>"
    tableRow.append "<td class=\"mempl\">(</td>"
    tableRow.append "<td class=\"memp\">#{memp}</td>"
    tableRow.append "<td class=\"mempr\">%)</td>"

update: (output, domEl) ->
  table = $(domEl).find("table")
  tbody = table.find("tbody")
  tbody.empty()

  lines = output.split("\n")

  @updateBody(tbody, lines[1..10])

# vim: ts=2:sts=2:sw=2
