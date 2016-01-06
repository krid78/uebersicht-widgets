# vim: ts=2:sts=2:sw=2
###
This widget puts an indicator on the side of the screen that TimeMachine is running and show's is progress
as it runs. It will hide again with TimeMachine is completes. It parses tmutil status data for this information
and runs every 15 seconds - you may wish to change.
- refreshFrequency (15s)
- poitioning (Middle of left edge - transform translate(0,-50%))
- Font-name and size (although you'll need to fiddle with the line sizes etc I expect.)
- Font color and opacities to suit your desktop picture

The .revealer div essentially reduces in size by 1 - %complete to reveal the underlying
.indicator div based on the value of the "Percent =xxx" in the tmutil status output.
###

command: "tmutil status"

# every 15 seconds is probably unnecessary but I'm a bit OCD

refreshFrequency: 15000

render: (output)->"""
  <div class='container'>
    <div class='scale'><p>100% - </p><p>75% - </p><p>50% - </p><p>25% - </p><p>0% - </p></div>
    <div class='indicator-container'>
      <div class='revealer'></div>
      </div>
  </div>
  """

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
  right 10px
  top 50%
  transform translate(0, -50%)

  // Statistics text settings
  color fgcol()
  font-family "Helvetica Neue"
  font-weight normal
  font-size 12px

  .scale
    display inline-block

  .scale p
    text-align right
    line-height 50px

  .indicator-container
    display inline-block
    height 250px
    width 4px
    background-color sgreen()
    border-radius 2px
    margin-bottom 2px
    overflow hidden

  .revealer
    width 4px
    height 100%
    //background-color bgcol()
    background-color rgba(70,70,70, .9)
    border-radius 2px
"""

update: (output, domEl) ->

  # if TimeMachine is running the show our block, if not hide it.

  if @isRunning(output)
    $(domEl).find('.container').css('display', 'block')
    $(domEl).find('.revealer').css('height', 100 - @percentComplete(output) + '%')
  else
    $(domEl).find('.container').css('display', 'none')

isRunning: (data) ->
  return (if data.match(/Running = \d;/)[0].match(/(\d+)/)[0] is '1' then true else false)

percentComplete: (data) ->
  return Math.round(Number(data.match?(/Percent = \"?([0-9.e-]*)\D/)[1]) * 100)

###
There are a few patterns here to deal with.
 - Percent = 0;
 - Percent = "-1"; (this one returns -100 which sets revealer to 200% which is an error, which works - HACK!!!)
 - Percent = "1";
 - Percent = "0.328473270";
 - Percent = "5.2340984e-34";

 So the regex is as follows.
  - Percent =
  - \"? is optional "
  - [0-9.e-]* gets all the characters in our numbers of various forms
  - \D is the trailing " or ; whichever is present
  - () gives us just the number string
###
# vim: ts=2:sts=2:sw=2
