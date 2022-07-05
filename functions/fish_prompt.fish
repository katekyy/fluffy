################ CONFIG ################

  set -g background ( set_color -b red )
  set -g marker_color ( set_color red )      # must be the same as background color
  set -g color ( set_color white )

  set -g marker ''
  set -g f_marker ''
  set -g git_marker $normal ''

  set -g icon_background_color ( set_color -b black )
  set -g icon_foreground_color ( set_color white )
  set -g icon_marker_color ( set_color black )
  set -g icon_enabled false            # default: false
  set -g icon ''

########################################



function git::branch_name
  echo ( command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||' )
end

function git::dirty
  echo ( command git status -s --ignore-submodules=dirty 2> /dev/null )
end

function git::head_detach
  echo ( command git symbolic-ref HEAD )
end

function pwd::better
  set -l dir (pwd)
  set -l plank (string split -r -m2 '/' $dir)
  set -l forte ()
  set -l home $HOME
  set -l home_array (string split -r -m2 '/' $HOME)

  if [ $dir = $home ]
    echo '~'
  else
    echo '../'(string trim $plank[2])'/'(string trim $plank[3])
  end
end

function fish_prompt
  set -l yellow ( set_color yellow )
  set -l green ( set_color green )
  set -l red ( set_color red )
  set -l normal ( set_color normal white )
  set -l background_normal ( set_color -b normal )

  set -l cwd ( pwd::better )

  if [ $icon_enabled = true ]
    set -g f_icon $icon_background_color ' ' $icon_foreground_color $icon ' ' $background $icon_marker_color $f_marker $normal
  else
    set -g f_icon ''
  end

  echo -n -s  $f_icon $color $background ' ' $cwd ' ' $background_normal $marker_color $marker $normal

  if [ (git::branch_name) ]
    set -l git_branch '' ( git::branch_name )

    if [ (contains HEAD (git::head_detach)) ]
      set git_info '' $red ' HD ' $git_branch $normal $git_marker
      set git_head_detach_addition $red ' HD '
    else
      set git_info '' $green $git_branch $normal $git_marker
      set git_head_detach_addition ' '
    end

    if [ (git::dirty) ]
      set git_info '' $git_head_detach_addition $yellow 'M ' $git_branch ' ' $normal $git_marker
    else
      set git_info '' $git_head_detach_addition $green $git_branch ' ' $normal $git_marker
    end
    echo -n -s $git_info $normal ' '
  else
    echo -n -s $normal ' '
  end

  echo -n -s $normal

end
