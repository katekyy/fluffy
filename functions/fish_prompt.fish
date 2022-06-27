function git::branch_name
  echo ( command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||' )
end

function git::dirty
  echo ( command git status -s --ignore-submodules=dirty 2> /dev/null )
end

function git::detached_head
  echo ( command git rev-parse --symbolic-full-name HEAD )
end

function fish_prompt
  set -l yellow ( set_color yellow )
  set -l red ( set_color red )
  set -l blue ( set_color blue )
  set -l green ( set_color green )
  set -l normal ( set_color normal white )
  set -l gray ( set_color E7E7E7 white )

  set -l arrow ''
  set -l git_marker $gray ''

  # smallest: set -a arrow '➜'
  # small: set -a arrow '🡢'
  set -a arrow '🡪'
  # big: set -a arrow '🡲'
  # bigger: set -a arrow '🡺'
  # heavy: set -a arrow '🢂'

  set -l cwd ( basename (prompt_pwd) )

  echo -n -s $blue $arrow $normal $cwd

  if [ (git::branch_name) ]
    set -l git_branch ( git::branch_name )

    if [ (contains HEAD (git::detached_head)) ]
      set git_info ' ' $git_marker ' ' $red 'HD ' $git_branch ' '
      set git_detached_head_addition $red 'HD '
    else
      set git_info ' ' $git_marker ' ' $green $git_branch ' '
      set git_detached_head_addition ''
    end

    if [ (git::dirty) ]
      set git_info ' ' $git_marker ' ' $git_detached_head_addition $yellow 'M ' $git_branch ' '
    else
      set git_info ' ' $git_marker ' ' $git_detached_head_addition $green $git_branch ' '
    end
    echo -n -s $git_info $normal
  else
    echo -n -s $normal ' '
  end

  echo -n -s $normal ' '

end