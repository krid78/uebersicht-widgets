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
refreshFrequency: 10000

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
  console.log("Title1 #{title}")
  console.log("Title2 " + title)
  title.empty()
  $("<span>Network Info: </span>").appendTo(title)

  # Loop through the services in the JSON.
  for svc in data.service

    $("<span>#{svc.ssid}</span>").appendTo(title)

    # Start building our table cell.
    html += "<td class='service'>"

    # If there is an IP Address, we should show the connected icon. Otherwise we show the disable icon.
    # If there is no IP Address, we show "Not Connected" rather than the missing IP Address.
    if svc.ipaddress == ''
      html += "  <img class='icon' src='NetworkInfo.widget/images/" + svc.name + "_disabled.png'/>"
      html += "  <p class='primaryInfo'>Not Connected</p>"
    else
      html += "  <img class='icon' src='NetworkInfo.widget/images/" + svc.name + ".png'/>"
      html += "  <p class='primaryInfo'>" + svc.ipaddress + "</p>"

    # Show the Mac Address.
    html += "  <p class='secondaryInfo'>" + svc.macaddress + "</p>"
    html += "</td>"

  # Set our output.
  $(services).html(html)

# CSS Style
style: """
  //@import 'calendar.widget/solarized.styl'
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
  bottom: 1%
  left 50%
  transform translate(-50%, 0)

  // Statistics text settings
  color base0()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px
  margin:0
  padding:0px
  //border:1px solid base02(.25)
  //border-radius:10px

  .widget-title
    text-align: center
    padding 4px 6px
    margin-bottom 1ex
    font-size  1.17em
    font-weight 200
    border-top solid 1px base02()
    border-bottom solid 1px base02()
    //background-color base02()
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
    color  base0()

  .secondaryInfo
    font-size 0.85em
    color  base01()
"""
