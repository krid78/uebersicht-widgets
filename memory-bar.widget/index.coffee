# vim: ts=2:sts=2:sw=2
# show a memory usage bar

command: "memory_pressure && sysctl hw.memsize"

# refersh every 5 seconds
refreshFrequency: 5000

style: """
  // the base color selector light or dark
  the-bg = "dark"

  // the actual color definition. For base16, its done in a quite generic way...
  base00(a=1)     // dark: bg
    rgba(#000000, a)
  base01(a=1)     // dark: bg highlight
    rgba(#303030, a)
  base02(a=1)     // light: emphasized; dark: comment
    rgba(#505050, a)
  base03(a=1)     // light: std. text
    rgba(#B0B0B0, a)
  base04(a=1)     // dark: std. text
    rgba(#D0D0D0, a)
  base05(a=1)     // light: comment; dark: emphasized
    rgba(#E0E0E0, a)
  base06(a=1)     // light: bg highlight
    rgba(#F5F5F5, a)
  base07(a=1)     // light: bg
    rgba(#FFFFFF, a)
  base08(a=1)     // syellow
    rgba(#FB0120, a)
  base09(a=1)     // sorange
    rgba(#FC6D24, a)
  base0A(a=1)     // sred
    rgba(#FDA331, a)
  base0B(a=1)     // smagenta
    rgba(#A1C659, a)
  base0C(a=1)     // sviolet
    rgba(#76C7B7, a)
  base0D(a=1)     // sblue
    rgba(#6FB3D2, a)
  base0E(a=1)     // scyan
    rgba(#D381C3, a)
  base0F(a=1)     // sgreen
    rgba(#BE643C, a)

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

  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  // Position this where you want
  bottom 1%
  right 2%
  //transform translate(-50%, 0)

  // Statistics text settings
  color fgcol(1)
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px
  padding 10px 10px 15px
  border-radius 5px

  .container
    width: 300px
    text-align: widget-align
    position: relative
    clear: both

  .widget-title
    text-align: center
    text-transform uppercase
    padding 4px 6px
    margin-bottom 1ex
    font-size 1.17em
    font-weight 200
    //border-top solid 1px bghcol(.25)
    //border-bottom solid 1px bghcol(.25)

  .stats-container
    margin-bottom 5px
    border-collapse collapse

  td
    font-size: 1.2em
    font-weight: 300
    color: fgcol(1)
    text-align: widget-align

  .label
    font-size 0.8em
    text-transform uppercase
    font-weight bold

  .bar-container
    width: 100%
    height: bar-height
    border-radius: bar-height
    float: widget-align
    clear: both
    //background: bghcol(1)
    position: absolute
    margin-bottom: 5px

  .bar
    height: bar-height
    float: widget-align
    transition: width .2s ease-in-out

  .bar:first-child
    if widget-align == left
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar:last-child
    if widget-align == right
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar-inactive
    background: sblue(.8)

  .bar-active
    background: syellow(.8)

  .bar-wired
    background: sred(.8)
"""


render: -> """
  <div class="container">
    <div class="widget-title">Memory</div>
    <table class="stats-container" width="100%">
      <tr>
        <td class="stat"><span class="wired"></span></td>
        <td class="stat"><span class="active"></span></td>
        <td class="stat"><span class="inactive"></span></td>
        <td class="stat"><span class="free"></span></td>
        <td class="stat"><span class="total"></span></td>
      </tr>
      <tr>
        <td class="label">wired</td>
        <td class="label">active</td>
        <td class="label">inactive</td>
        <td class="label">free</td>
        <td class="label">total</td>
      </tr>
    </table>
    <div class="bar-container">
      <div class="bar bar-wired"></div>
      <div class="bar bar-active"></div>
      <div class="bar bar-inactive"></div>
    </div>
  </div>
"""

update: (output, domEl) ->

  usage = (pages) ->
    mb = (pages * 4096) / 1024 / 1024
    usageFormat mb

  usageFormat = (mb) ->
    if mb > 1024
      gb = mb / 1024
      "#{parseFloat(gb.toFixed(2))}GB"
    else
      "#{parseFloat(mb.toFixed())}MB"

  updateStat = (sel, usedPages, totalBytes) ->
    usedBytes = usedPages * 4096
    percent = (usedBytes / totalBytes * 100).toFixed(1) + "%"
    $(domEl).find(".#{sel}").text usage(usedPages)
    $(domEl).find(".bar-#{sel}").css "width", percent

  lines = output.split "\n"

  freePages = lines[3].split(": ")[1]
  inactivePages = lines[13].split(": ")[1]
  activePages = lines[12].split(": ")[1]
  wiredPages = lines[16].split(": ")[1]

  totalBytes = lines[28].split(": ")[1]
  $(domEl).find(".total").text usageFormat(totalBytes / 1024 / 1024)

  updateStat 'free', freePages, totalBytes
  updateStat 'active', activePages, totalBytes
  updateStat 'inactive', inactivePages, totalBytes
  updateStat 'wired', wiredPages, totalBytes
