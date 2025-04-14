find_docker_compose() {
    local paths=("." "./deployment" "./deployment/local" "./docker" "./local")
    for dir in "${paths[@]}"; do
        if [[ -f "$dir/docker-compose.yml" || -f "$dir/compose.yml" ]]; then
            echo "$dir"
            return
        fi
    done
    echo ""
}

dc() {
    local compose_dir
    compose_dir=$(find_docker_compose)
    
    if [[ -z "$compose_dir" ]]; then
        echo "No docker-compose.yml or compose.yml found in the expected directories." >&2
        return 1
    fi
    
    docker compose --project-directory "$compose_dir" "$@"
}

dce() { dc exec "$@"; }
dcl() { dc logs -f "$@"; }
dcu() { dc up -d --force-recreate --remove-orphans "$@"; }
dcb() { dc build --no-cache "$@"; }
dcd() { dc down "$@"; }
dcr() { dc restart "$@"; }
dcul() { dcu && dcl "$@"; }
dcbu() { dcb && dcu; }
dcbul() { dcb && dcu && dcl "$@"; }
