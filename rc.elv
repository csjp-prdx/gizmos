set-env EDITOR 'hx'

# set-env GOPATH '/opt/homebrew/bin/go'
# set-env GOROOT $E:HOME'/go'
# set-env GOBIN  $E:GOROOT'/bin'

# set env:PATH=$env:GOROOT'/bin:'$env:HOME'/bin:'$env:GOBIN':/usr/local/bin:/usr/local/sbin:/usr/local/opt/ruby/bin:'$env:HOME'/.fzf/bin:'$env:PATH
set-env PATH   $E:HOME'/.local/bin:'$E:PATH
set-env PATH   '/usr/local/bin:'$E:PATH
set-env PATH   '/opt/homebrew/bin:'$E:PATH

eval (carapace _carapace | slurp)
eval (zoxide init elvish | slurp)
use github.com/zzamboni/elvish-modules/terminal-title
use github.com/muesli/elvish-libs/git

fn ls  { |@a| e:exa --group-directories-first --sort new $@a }
fn lt  { |@a| e:exa --tree $@a }
fn lk  { |@a| cd (e:walk $@a) }
fn rm  { |@a| put 'Use 'del', or the full path i.e. '/bin/rm'' }
fn dl  { |@a| e:trash $@a }
fn cat { |@a| e:bat --style=plain --paging=never --theme base16 $@a }
fn _sdm_is_linked { put (==s (sdm ready 2>&1 | jq -r .is_linked) "true") }
fn ssh { |@a|
  if (_sdm_is_linked) { tmp E:TERM = 'xterm-256color'; e:sdm ssh wrapped-run $@a
  } else { put "sdm: Not logged in" }
}
fn scp { |@a|
  if (==s (sdm ready 2>&1 | jq -r .is_linked) "true") { tmp E:TERM = 'xterm-256color'; e:scp -S'sdm' -osdmSCP $@a
  } else { put "sdm: Not logged in" }
}

fn mess { |@a|
  # use str
  var messpath = $E:HOME'/mess'
  var now      = (date '+%Y/%V')
  var current  = $messpath'/'$now
  var link     = $messpath'/current'

  if ?(test -d $current) { } else {
    mkdir -p $current
    put 'Created '$now
  }

  if ?(test -e $link) {
    if ?(test -L $link) { } else {
      put $link' is not a symlink: something is wrong'
      exit
    }
  } 

  if ?(test $link -ef $current) { } else {
    e:rm -f $link
    ln -s $current $link
  }

  put $now
  cd $current
  # var target = (str:join '/' [$link $@a] )
}

var prompt-pwd-dir-length = 1
var prompt-char = '$ '

fn prompt-pwd {
  use re
  var pwd = (tilde-abbr $pwd)
  if (== $prompt-pwd-dir-length 0) {
    put $pwd
  } else {
    re:replace '(\.?[^/]{'$prompt-pwd-dir-length'})[^/]*/' '$1/' $pwd
  }
}

set edit:prompt = {
  # Current working directory
  styled (prompt-pwd)' ' 'blue'

  var _git_info = (git:status)
  if $_git_info[is-git-repo] {
    # Current Git branch
    styled '⎇ '$_git_info[branch-name]' ' 'green'

    # Rich repo status in prompt readline
    var _git_flags = ''
    var _is_staged = { or (!= 0 (count $_git_info['staged-added'])) (!= 0 (count $_git_info['staged-deleted'])) (!= 0 (count $_git_info['staged-modified'])) }

    if (!= 0 (count $_git_info[untracked]))      { set _git_flags = $_git_flags'?' }  # ? — untracked changes;
    if ($_is_staged)                             { set _git_flags = $_git_flags'+' }  # + — uncommitted changes in the index;
    if (!= 0 (count $_git_info[local-modified])) { set _git_flags = $_git_flags'!' }  # ! — unstaged changes;
    if (!= 0 (count $_git_info[renamed]))        { set _git_flags = $_git_flags'»' }  # » — renamed files;
    if (!= 0 (count $_git_info[local-deleted]))  { set _git_flags = $_git_flags'✘' }  # ✘ — deleted files;
    #   $ — stashed changes [WIP];
    if (!= 0 (count $_git_info[unmerged]))       { set _git_flags = $_git_flags'§' }  # § — unmerged changes;
    if (!= 0        $_git_info[rev-ahead])       { set _git_flags = $_git_flags'⇡' }  # ⇡ — ahead of remote branch;
    if (!= 0        $_git_info[rev-behind])      { set _git_flags = $_git_flags'⇣' }  # ⇣ — behind of remote branch;
    #   ⇕ — diverged changes.

    if (!= 0 (count $_git_flags)) { styled '['$_git_flags'] ' 'yellow' }

    # Current Git SHA
    # styled $_git_info[branch-oid][..8]' ' 'white'

    # Colorized time since last commit
  }

  # A red marker (✗) if last command exits with non-zero code.

  put $prompt-char
}

set edit:rprompt = {
  var _git_info = (git:status)
  if $_git_info[is-git-repo] {
    styled $_git_info[branch-oid] 'white'
  }
}
# set edit:rprompt = (constantly (styled (whoami)@(hostname) inverse))
