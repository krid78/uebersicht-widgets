# vim: ts=2:sts=2:sw=2
#--------------------------------------------------------------------------------------
# Please Read
#--------------------------------------------------------------------------------------
# The images used in this widget are from the Noun Project (http://thenounproject.com).
#
# They were created by the following individuals:
#   Ethernet by Michael Anthony from The Noun Project
#   Wireless by Piotrek Chuchla from The Noun Project
#
#--------------------------------------------------------------------------------------

# Execute the shell command.
command: "NetworkInfo.widget/NetworkInfo.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 15000

# Render the output.
render: (output) -> """
  <div id="title" class="widget-title">Network Info</div>
  <table id='services'></table>
"""

# Update the rendered output.
update: (output, domEl) ->
  # Parse the JSON created by the shell script.
  data = JSON.parse output
  html = ""

  title = $(domEl).find("#title")
  title.empty()
  $("<span>Network Info: </span>").appendTo(title)

  # Loop through the services in the JSON.
  for svc in data.service

    if svc.ssid != '' and svc.ssid != 'You are not associated with an AirPort network.'
        $("<span>#{svc.ssid}</span>").appendTo(title)

    # Start building our table cell.
    html += "<td class='service'>"

    # If there is an IP Address, we should show the connected icon. Otherwise we show the disable icon.
    # If there is no IP Address, we show "Not Connected" rather than the missing IP Address.
    if svc.ipaddress == ''
      html += "  <img class='icon' src='NetworkInfo.widget/images/light_" + svc.name + "_disabled.png'/>"
      #html += "  <img class='icon' src='NetworkInfo.widget/images/dark_" + svc.name + "_disabled.png'/>"
      html += "  <p class='primaryInfo'>Not Connected</p>"
    else
      html += "  <img class='icon' src='NetworkInfo.widget/images/light_" + svc.name + ".png'/>"
      #html += "  <img class='icon' src='NetworkInfo.widget/images/dark_" + svc.name + ".png'/>"
      html += "  <p class='primaryInfo'>" + svc.ipaddress + "</p>"

    # Show the Mac Address.
    html += "  <p class='secondaryInfo'>" + svc.macaddress + "</p>"
    html += "</td>"

  # Set our output.
  $(services).html(html)

# CSS Style
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

  .service
    text-align:center
    padding:2px

  .icon
    height:32px
    width:32px

  .primaryInfo, .secondaryInfo
    padding:0px
    margin:2px

  .primaryInfo
    font-size 1em
    color fgcol()

  .secondaryInfo
    font-size 0.85em
    color comment()
"""
