#!/bin/bash
# check.sh: the repo's quality gate; `make check` runs every step.
# requires: shellcheck shfmt gitleaks stow git

missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v shellcheck >/dev/null || missing shellcheck "see _gate/Brewfile"
command -v shfmt >/dev/null || missing shfmt "see _gate/Brewfile"
command -v gitleaks >/dev/null || missing gitleaks "see _gate/Brewfile"
command -v stow >/dev/null || missing stow "see _gate/Brewfile"
command -v git >/dev/null || missing git "install the Command Line Tools: xcode-select --install"

gate="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$gate/.." && pwd)"
count=0
all_steps="structure shell references secrets entrypoints selftest"
root_allow=" bootstrap.sh install.sh verify.sh packages Makefile README.md LICENSE .gitignore .githooks .github _gate .DS_Store "
canon_stow="stow --dir=\"\$here\" --target=\"\$HOME\" --no-folding --ignore='\\.DS_Store' home"
missing_fn="$(printf '%s\n' 'missing() {' "  echo \"missing prerequisite: \$1 (\$2)\" >&2" '  exit 3' '}')"
self_locate="here=\"\$(cd \"\$(dirname \"\$0\")\" && pwd)\""

usage() {
  echo "usage: check.sh [--root DIR] [$(echo "$all_steps" | tr ' ' '|')]... | check.sh fmt" >&2
  exit 2
}

violation() { # $1 rule, $2 path, $3 message
  local rel="${2#"$root"}"
  rel="${rel#/}"
  echo "$1 ${rel:-.}: $3"
  count=$((count + 1))
}

# Every script: *.sh, or any file starting with a shebang. Symlinks are linted at their target.
scripts() {
  find "$root" -name .git -prune -o -type f -print | sort | while IFS= read -r f; do
    case "$f" in
      *.sh) echo "$f" ;;
      *) [ "$(head -c 2 "$f")" = "#!" ] && echo "$f" ;;
    esac
  done
}

# Top-level names R2 and R3 judge. In a git checkout, only tracked or staged paths: those
# rules keep the published layout clean, and untracked local files (notes, scratch) are
# never published or installed, so failing on them would only push people to delete or
# allowlist them. Outside git (the self-test's fixture copies), everything on disk.
root_entries() {
  if [ -e "$root/.git" ]; then
    git -C "$root" ls-files -z | tr '\0' '\n' | sed 's|/.*||' | sort -u | while IFS= read -r n; do
      [ -e "$root/$n" ] || [ -L "$root/$n" ] && echo "$n"
    done
  else
    for e in "$root"/* "$root"/.[!.]*; do
      [ -e "$e" ] || [ -L "$e" ] && basename "$e"
    done
  fi
}

list_packages() {
  [ -f "$root/packages" ] || return 0
  sed -e 's/#.*//' -e 's/[[:space:]]//g' "$root/packages" | grep -v '^$'
}

# Script body without its header, comment lines, or trailing " # ..." comments.
code_of() { sed -e '1,3d' -e '/^[[:space:]]*#/d' -e 's/[[:space:]]#.*$//' "$1"; }

# Matches $1 where a command name can start (line start, after ; & | ( ! { a keyword, or
# VAR=value prefixes), optionally path-qualified or quoted.
cmd_re() {
  echo "(^|[;&|(!{])[[:space:]]*(([[:alpha:]_][[:alnum:]_]*=[^[:space:]]*|then|do|else|exec|if|while|until|time|xargs|command|env|sudo|nohup)[[:space:]]+)*[\"']?(/[^[:space:]]*/)?$1[\"']?([[:space:];)]|$)"
}

# R11: a verify.sh must not change state.
check_readonly() {
  local f="$1" body m
  body="$(code_of "$f")"
  for m in \
    'brew[[:space:]]+(install|reinstall|upgrade|uninstall|link|unlink|tap)' \
    'brew[[:space:]]+bundle([[:space:]]+(install|cleanup|dump|-)|[[:space:]]*$)' \
    'mise[[:space:]]+(install|use|uninstall|upgrade|prune)' \
    '(^|[^[:alnum:]_.-])["'"'"']?(rm|mv|cp|ln|mkdir|touch|tee|truncate|dd|install|mktemp)["'"'"']?([[:space:]]|$)' \
    'sed[[:space:]]+(-[[:alpha:]]*[[:space:]]+)*-i|[[:space:]]-delete([[:space:]]|$)' \
    'defaults[[:space:]]+write'; do
    grep -Eq "$m" <<<"$body" && violation R11 "$f" "modifies state: matches /$m/"
  done
  grep -E "$(cmd_re stow)" <<<"$body" | grep -Evq '[[:space:]](-n|--no|--simulate)([[:space:]]|$)' &&
    violation R11 "$f" "stow without -n"
  sed -E 's/[0-9]*>>?[[:space:]]*(\/dev\/null|&[12])//g' <<<"$body" | grep -q '>' &&
    violation R11 "$f" "redirects output somewhere other than /dev/null or &2"
}

step_structure() {
  local pkgs p d e f n h body req l1 l2 l3 stows m blanked chk use
  pkgs="$(list_packages)"

  # R2: packages <-> directories
  [ -f "$root/packages" ] || violation R2 "$root/packages" "missing"
  for p in $(sort <<<"$pkgs" | uniq -d); do violation R2 "$root/packages" "duplicate: $p"; done
  for p in $pkgs; do [ -d "$root/$p" ] || violation R2 "$root/packages" "listed but no directory: $p"; done
  while IFS= read -r n; do
    [ -d "$root/$n" ] || continue
    case "$n" in _* | .*) continue ;; esac
    grep -qx -- "$n" <<<"$pkgs" || violation R2 "$root/$n" "directory not listed in packages"
  done < <(root_entries)

  # R3: root allowlist (non-underscore directories are packages, judged by R2)
  while IFS= read -r n; do
    e="$root/$n"
    case "$root_allow" in *" $n "*) continue ;; esac
    if [ -d "$e" ]; then
      case "$n" in _* | .*) ;; *) continue ;; esac
    fi
    violation R3 "$e" "not allowed at the repo root"
  done < <(root_entries)

  [ -f "$root/verify.sh" ] && check_readonly "$root/verify.sh"

  for p in $pkgs; do
    d="$root/$p"
    [ -d "$d" ] || continue

    # R1: package shape
    for f in README.md install.sh verify.sh; do [ -f "$d/$f" ] || violation R1 "$d" "missing $f"; done
    for f in install.sh verify.sh; do
      [ -f "$d/$f" ] && [ ! -x "$d/$f" ] && violation R1 "$d/$f" "not executable"
    done
    for e in "$d"/* "$d"/.[!.]*; do
      [ -e "$e" ] || [ -L "$e" ] || continue
      [ "$(basename "$e")" = home ] && [ ! -d "$e" ] && violation R1 "$e" "home must be a directory"
      case "$(basename "$e")" in
        README.md | install.sh | verify.sh | Brewfile | home | .DS_Store) ;;
        *) violation R1 "$e" "not allowed in a package" ;;
      esac
    done

    # R12: package README shape
    if [ -f "$d/README.md" ]; then
      n=$(wc -l <"$d/README.md" | tr -d ' ')
      [ "$n" -le 60 ] || violation R12 "$d/README.md" "$n lines (max 60)"
      h=$(awk '/^```/ { fence = !fence; next } !fence && /^## / { sub(/^## /, ""); printf "%s ", $0 }' "$d/README.md")
      [ "$h" = "What Why Install Customize Verify " ] ||
        violation R12 "$d/README.md" "## headings must be What, Why, Install, Customize, Verify (found: ${h% })"
      awk '/^## /{ w = ($0 == "## Why") } w && $0 == "### Alternatives Considered" { f = 1 } END { exit !f }' "$d/README.md" ||
        violation R12 "$d/README.md" "## Why needs a ### Alternatives Considered subsection"
    fi

    # R18: the README is the package's site page, so it names everything the package installs or links.
    if [ -f "$d/README.md" ]; then
      [ -f "$d/Brewfile" ] && while IFS= read -r m; do
        grep -qF -- "${m##*/}" "$d/README.md" || violation R18 "$d/README.md" "does not name Brewfile entry ${m##*/}"
      done < <(sed -nE 's/^[[:space:]]*(brew|cask)[[:space:]]+"([^"]+)".*/\2/p' "$d/Brewfile")
      [ -d "$d/home" ] && while IFS= read -r f; do
        grep -qF -- "$(basename "$f")" "$d/README.md" || violation R18 "$d/README.md" "does not name linked file $(basename "$f")"
      done < <(find "$d/home" -type f ! -name .DS_Store)
    fi

    # R5: linking only through the canonical stow call
    for f in "$d/install.sh" "$d/verify.sh"; do
      [ -f "$f" ] || continue
      body="$(code_of "$f")"
      grep -Eq -- '--adopt|--override' <<<"$body" && violation R5 "$f" "stow --adopt/--override is banned"
      grep -Eq '(^|[^[:alnum:]_])ln[[:space:]]+(-[[:alpha:]]*s|--symbolic)' <<<"$body" && violation R5 "$f" "ln -s is banned; link through stow"
    done
    if [ -f "$d/install.sh" ]; then
      stows=$(grep -E "$(cmd_re stow)" <<<"$(code_of "$d/install.sh")" | sed 's/^[[:space:]]*//')
      if [ -d "$d/home" ]; then
        [ "$stows" = "$canon_stow" ] || violation R5 "$d/install.sh" "must link with exactly one line: $canon_stow"
      else
        [ -z "$stows" ] || violation R5 "$d/install.sh" "calls stow but has no home/"
      fi
    fi

    [ -f "$d/verify.sh" ] && check_readonly "$d/verify.sh"
  done

  # R17: a Brewfile check must neither count outdated formulae as missing nor auto-update.
  while IFS= read -r f; do
    while IFS= read -r l1; do
      case "$l1" in *--no-upgrade*) ;; *) violation R17 "$f" "brew bundle check without --no-upgrade" ;; esac
      grep -Eq '(^|[^[:alnum:]_])HOMEBREW_NO_AUTO_UPDATE=1[[:space:]]+brew[[:space:]]' <<<"$l1" ||
        violation R17 "$f" "brew bundle check without the HOMEBREW_NO_AUTO_UPDATE=1 prefix"
    done < <(code_of "$f" | grep -E "$(cmd_re brew)" | grep -E 'brew[[:space:]]+bundle([[:space:]]+-[^[:space:]]*)*[[:space:]]+check')
  done < <(scripts)

  # R4 + R15: header lines and prerequisite checks, every script
  while IFS= read -r f; do
    l1="$(sed -n 1p "$f")"
    l2="$(sed -n 2p "$f")"
    l3="$(sed -n 3p "$f")"
    [ "$l1" = "#!/bin/bash" ] || violation R4 "$f" "line 1 must be #!/bin/bash"
    case "$l2" in "# "?*) ;; *) violation R4 "$f" "line 2 must be a '# <purpose>' comment" ;; esac
    case "$l3" in
      "# requires: "?*) req="${l3#"# requires: "}" ;;
      *)
        violation R4 "$f" "line 3 must be '# requires: <cmd>...' or '# requires: none'"
        continue
        ;;
    esac
    if [ "$req" != none ]; then
      [ "$(grep -x -A 3 'missing() {' "$f")" = "$missing_fn" ] ||
        violation R15 "$f" "missing() must be exactly the canonical function (R15)"
      blanked="$(sed -e 's/^[[:space:]]*#.*//' -e 's/[[:space:]]#.*$//' -e 's/^[[:space:]]*//' "$f")"
      for m in $req; do
        chk="$(grep -nEx "command -v $m >/dev/null \|\| missing $m \".+\"" <<<"$blanked" | head -n 1 | cut -d: -f1)"
        use="$(grep -nE "$(cmd_re "$m")" <<<"$blanked" | grep -v "command -v $m " | head -n 1 | cut -d: -f1)"
        if [ -z "$chk" ]; then
          violation R15 "$f" "no check line: command -v $m >/dev/null || missing $m \"<how to get it>\""
        elif [ -n "$use" ] && [ "$use" -lt "$chk" ]; then
          violation R15 "$f" "line $use runs $m before its prerequisite check"
        fi
      done
      req=" $req "
    else
      req=" "
    fi
    # bootstrap.sh installs the managed set, so it cannot require it.
    [ "$f" = "$root/bootstrap.sh" ] && continue
    body="$(code_of "$f")"
    while IFS= read -r m; do
      case "$req" in *" $m "*) continue ;; esac
      grep -Eq "$(cmd_re "$m")" <<<"$body" && violation R15 "$f" "runs $m without declaring it on line 3"
    done < <(grep -Ev '^[[:space:]]*(#|$)' "$gate/managed-commands.txt")
  done < <(scripts)
}

step_shell() {
  local f
  while IFS= read -r f; do
    /bin/bash -n "$f" 2>/dev/null || violation R6 "$f" "/bin/bash -n: syntax error under bash 3.2"
    shellcheck --shell=bash --severity=style "$f" >&2 || violation R6 "$f" "shellcheck"
    shfmt -d -i 2 -ci "$f" >&2 || violation R6 "$f" "shfmt (run make fmt)"
    grep -Eq '^[[:space:]]*#[[:space:]]*shellcheck[[:space:]].*disable' "$f" && violation R6 "$f" "disable directive present"
    grep -Eq 'declare[[:space:]]+-A|local[[:space:]]+-A|[m]apfile|[r]eadarray|[c]oproc|[[:space:]][|]&[[:space:]]|\$\{[[:alnum:]_]+(\^|,)|\[-[0-9]+\]\}' "$f" &&
      violation R6 "$f" "bash 4+ construct (not available in /bin/bash 3.2)"
  done < <(scripts)
  while IFS= read -r f; do
    violation R6 "$f" "shellcheck rc files are banned; the gate's flags are the only config"
  done < <(find "$root" -name .git -prune -o -name .shellcheckrc -print)
}

step_references() {
  local pats f rel line p d body
  pats="$(mktemp "${TMPDIR:-/tmp}/check.XXXXXX")"
  grep -Ev '^[[:space:]]*(#|$)' "$gate/forbidden.txt" >"$pats"
  # R7: forbidden references anywhere outside the list itself and the fixtures
  while IFS= read -r f; do
    rel="${f#"$root"/}"
    case "$rel" in _gate/forbidden.txt | _gate/fixtures/*) continue ;; esac
    grep -iEq -f "$pats" <<<"$rel" && violation R7 "$f" "path matches _gate/forbidden.txt"
    while IFS=: read -r line _; do
      violation R7 "$f" "line $line matches _gate/forbidden.txt"
    done < <(grep -IinE -f "$pats" "$f")
  done < <(find "$root" -name .git -prune -o -type f -print | sort)
  rm -f "$pats"

  # R8: package scripts locate themselves and never climb out of their package
  for p in $(list_packages); do
    d="$root/$p"
    for f in "$d/install.sh" "$d/verify.sh"; do
      [ -f "$f" ] || continue
      body="$(code_of "$f")"
      grep -Eq "(^|[/\"'[:space:]=])\.\.(\$|[/\"'[:space:]])" <<<"$body" && violation R8 "$f" "'..' path segment"
      grep -q 'rev-parse' <<<"$body" && violation R8 "$f" "asks git for repo paths"
      grep -Eq 'dirname[[:space:]]+"?\$\{?here' <<<"$body" && violation R8 "$f" "climbs out of its package via dirname"
      grep -qxF "$self_locate" <(sed 's/^[[:space:]]*//' "$f") || violation R8 "$f" "must locate itself with: $self_locate"
    done
  done
}

step_secrets() {
  local f
  gitleaks dir --no-banner --redact --log-level error "$root" >&2 || violation R9 "$root" "gitleaks found a secret"
  while IFS= read -r f; do
    violation R9 "$f" "gitleaks allow comments are banned"
  done < <(grep -rlE --exclude-dir=.git 'gitleaks[:]allow' "$root")
}

# R16: run a root entrypoint against the fixture repo; compare its stdout and exit code.
expect_entry() { # $1 HOME, $2 expected exit code, $3 expected stdout, $4... command
  local h="$1" want_rc="$2" want="$3" out rc label
  shift 3
  out="$(HOME="$h" PATH="$stubs:$PATH" "$@" 2>/dev/null)"
  rc=$?
  label="${1##*/} ${*:2}"
  if [ "$rc" != "$want_rc" ] || [ "$out" != "$want" ]; then
    violation R16 "$root/${1##*/}" "\`${label% }\` expected exit $want_rc and '${want//$'\n'/ | }', got exit $rc and '${out//$'\n'/ | }'"
  fi
}

step_entrypoints() {
  local tmp r stubs m
  [ -f "$root/install.sh" ] && [ -f "$root/verify.sh" ] || return 0
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/check.XXXXXX")"
  r="$tmp/repo"
  stubs="$tmp/bin"
  cp -R "$gate/fixtures/base" "$r"
  cp "$root/install.sh" "$root/verify.sh" "$r/"
  mkdir -p "$r/demo/home/Application Support/demo" "$stubs" "$tmp/a/Application Support" "$tmp/b/Application Support/demo" "$tmp/ok"
  echo demo >"$r/demo/home/Application Support/demo/demo.conf"
  # install.sh only checks that brew and mise exist; the stubs stand in where they are not installed.
  for m in brew mise; do
    printf '#!/bin/sh\n' >"$stubs/$m"
    chmod +x "$stubs/$m"
  done
  ln -s "$stubs" "$tmp/a/Application Support/demo"
  echo real >"$tmp/b/Application Support/demo/demo.conf"
  mkdir "$r/miss"
  printf '#!/bin/sh\necho "missing prerequisite: nosuch (hint)" >&2\nexit 3\n' >"$r/miss/verify.sh"
  chmod +x "$r/miss/verify.sh"
  echo miss >>"$r/packages"

  expect_entry "$tmp/a" 1 "FAIL demo: conflicts with existing ~/Application Support/demo
0 ok, 1 failed" "$r/install.sh" demo
  expect_entry "$tmp/b" 1 "FAIL demo: conflicts with existing ~/Application Support/demo/demo.conf
0 ok, 1 failed" "$r/install.sh" demo
  for m in install install verify; do
    expect_entry "$tmp/ok" 0 "ok demo
1 ok, 0 failed" "$r/$m.sh" demo
  done
  expect_entry "$tmp/ok" 1 "ok demo
FAIL miss: missing prerequisite: nosuch
1 ok, 1 failed" "$r/verify.sh"
  for m in install verify; do
    expect_entry "$tmp/ok" 2 "" "$r/$m.sh" nosuch
    expect_entry "$tmp/ok" 2 "" "$r/$m.sh" --bogus
  done
  rm -rf "$tmp"
}

step_selftest() {
  local base="$gate/fixtures/base" tmp m want got out covered=" " r
  [ -d "$base" ] || {
    violation R10 "$gate/fixtures" "missing base fixture"
    return
  }
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/check.XXXXXX")"
  cp -R "$base" "$tmp/base"
  "$gate/check.sh" --root "$tmp/base" structure shell references secrets >/dev/null 2>&1 ||
    violation R10 "$base" "the clean fixture fails the gate"
  for m in "$gate"/fixtures/R*.sh; do
    [ -f "$m" ] || continue
    want="$(basename "$m")"
    want="${want%%-*}"
    rm -rf "$tmp/m"
    cp -R "$base" "$tmp/m"
    "$m" "$tmp/m" || {
      violation R10 "$m" "mutation failed to apply"
      continue
    }
    out="$("$gate/check.sh" --root "$tmp/m" structure shell references secrets 2>/dev/null)"
    got="$(sed -n 's/^\(R[0-9]*\) .*/\1/p' <<<"$out" | sort -u | tr '\n' ' ')"
    [ "$got" = "$want " ] || violation R10 "$m" "expected only $want, got: ${got:-nothing}"
    covered="$covered$want "
  done
  # R3 in a git checkout: an untracked root file passes; the same file staged fails.
  cp -R "$base" "$tmp/g"
  git -C "$tmp/g" init -q && git -C "$tmp/g" add -A && touch "$tmp/g/notes.txt"
  "$gate/check.sh" --root "$tmp/g" structure >/dev/null 2>&1 ||
    violation R10 "$base" "an untracked root file fails the gate in a git checkout"
  git -C "$tmp/g" add notes.txt
  "$gate/check.sh" --root "$tmp/g" structure 2>/dev/null | grep -q '^R3 notes.txt' ||
    violation R10 "$base" "a staged stray root file passes the gate in a git checkout"
  rm -rf "$tmp"
  for r in R1 R2 R3 R4 R5 R6 R7 R8 R9 R11 R12 R15 R17 R18; do
    case "$covered" in *" $r "*) ;; *) violation R10 "$gate/fixtures" "no fixture for $r" ;; esac
  done
}

steps=""
while [ $# -gt 0 ]; do
  case "$1" in
    --root)
      [ -d "${2:-}" ] || usage
      root="$(cd "$2" && pwd)"
      shift 2
      ;;
    fmt)
      scripts | while IFS= read -r f; do shfmt -w -i 2 -ci "$f" || exit 1; done
      exit $?
      ;;
    structure | shell | references | secrets | entrypoints | selftest)
      steps="$steps $1"
      shift
      ;;
    *) usage ;;
  esac
done

echo "gate tools: shellcheck $(shellcheck --version | sed -n 's/^version: //p'), shfmt $(shfmt --version), gitleaks $(gitleaks version), stow $(stow --version | sed 's/.* //')"
for s in ${steps:-$all_steps}; do
  echo "== $s"
  "step_$s"
done
echo "check: $count violation(s)"
[ "$count" -eq 0 ]
