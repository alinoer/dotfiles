# ============================================================
# PROJECT MANAGEMENT CONFIGURATION
# Tambahkan kode ini ke ~/.zshrc atau ~/.bashrc
# ============================================================

# Define project paths
declare -A PROJECTS=(
    [rupay]="$HOME/code/rpy"
    [goldenpay]="$HOME/code/gldpy"
    [monsterpay]="$HOME/code/monsterpay"
    [onepay]="$HOME/code/onepay"
    [onetwopay]="$HOME/code/onetwopay"
    [kompaspay]="$HOME/code/kompaspay"
)

# ============================================================
# FUNCTION: Quick navigation to project directory
# Usage: pj marketing
#        pj payment
#        pj           (show list)
# ============================================================
cdproject() {
    local project="$1"

    if [[ -z "$project" ]]; then
        echo "📁 Available projects:"
        echo ""
        for proj in "${(@k)PROJECTS[@]}"; do
            printf "  %-15s → %s\n" "$proj" "${PROJECTS[$proj]}"
        done
        return 0
    fi

    if [[ -n "${PROJECTS[$project]}" ]]; then
        local target="${PROJECTS[$project]}"
        if [[ -d "$target" ]]; then
            cd "$target"
            echo "✓ Moved to: $(pwd)"
            ls -la
        else
            echo "✗ Error: Path does not exist: $target"
            return 1
        fi
    else
        echo "✗ Project '$project' not found"
        echo ""
        cdproject
        return 1
    fi
}

# ============================================================
# FUNCTION: Go to project + subdirectory
# Usage: pjcd marketing backend
# ============================================================
project_cd() {
    local project="$1"
    local subdir="$2"

    if [[ -z "$project" ]]; then
        echo "Usage: pjcd <project> [subdir]"
        echo "Example: pjcd marketing backend"
        return 1
    fi

    if [[ -n "${PROJECTS[$project]}" ]]; then
        local target="${PROJECTS[$project]}/$subdir"
        if [[ -d "$target" ]]; then
            cd "$target"
            echo "✓ Moved to: $(pwd)"
            ls -la
        else
            echo "✗ Directory not found: $target"
            return 1
        fi
    else
        echo "✗ Project '$project' not found"
        return 1
    fi
}

# ============================================================
# ALIASES
# ============================================================
# First, unalias pjcd if it exists to prevent conflicts
unalias pjcd 2>/dev/null || true
alias pj="cdproject"
alias pjcd="project_cd"
alias work="~/bin/workspace"
alias worklist="work list"
alias worksessions="work sessions"

# ============================================================
# OPTIONAL: FZF Integration (uncomment if you have fzf)
# brew install fzf
# ============================================================

# cdproject_fzf() {
#     local project=$(printf '%s\n' "${(@k)PROJECTS[@]}" | sort | fzf --preview "ls -la ${PROJECTS[${}]}")
#     if [[ -n "$project" ]]; then
#         cd "${PROJECTS[$project]}"
#         echo "✓ Moved to: $(pwd)"
#     fi
# }
#
# alias pj="cdproject_fzf"

# Ensure pjcd works correctly by removing any circular alias
unalias pjcd 2>/dev/null || true
alias pjcd="project_cd"
