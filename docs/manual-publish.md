# Manual Publish Guide

This guide describes how to manually build and publish SDR-Hub images to GHCR and Docker Hub if CI workflows fail or you need to publish outside of CI.

## Prerequisites

- Docker installed and logged in to GHCR and/or Docker Hub.
- `docker buildx` installed (comes with recent Docker Desktop / Docker Engine).
- Access to the repository locally.

## GHCR Publish (Primary)

1. **Login to GHCR**:

   ```bash
   echo "$GHCR_TOKEN" | docker login ghcr.io -u infamousrusty --password-stdin
   ```

   Use a personal access token with `write:packages` scope.

2. **Build and push multi-arch image**:

   ```bash
   docker buildx create --use --name sdr-hub-builder
   docker buildx build \
     --platform linux/amd64,linux/arm64 \
     -t ghcr.io/infamousrusty/sdr-hub:latest \
     -t ghcr.io/infamousrusty/sdr-hub:1.0.0 \
     --push .
   ```

3. **Verify**:

   ```bash
   docker pull ghcr.io/infamousrusty/sdr-hub:latest
   ```

## Docker Hub Mirror (Optional)

1. **Login to Docker Hub**:

   ```bash
   docker login -u englishrusty
   ```

2. **Tag and push**:

   ```bash
   docker pull ghcr.io/infamousrusty/sdr-hub:latest
   docker tag ghcr.io/infamousrusty/sdr-hub:latest englishrusty/sdr-hub:latest
   docker push englishrusty/sdr-hub:latest
   ```

## HAOS Add-on Images

The HAOS add-on builds separate per-arch images (e.g., `ghcr.io/infamousrusty/amd64-sdr-hub`, `ghcr.io/infamousrusty/aarch64-sdr-hub`). These are built by the `haos-build.yml` workflow. To build manually:

```bash
# For amd64
docker build -t ghcr.io/infamousrusty/amd64-sdr-hub:latest ./sdr-hub

# Push
docker push ghcr.io/infamousrusty/amd64-sdr-hub:latest
```

Repeat for `aarch64` with the appropriate context / platform.

## Troubleshooting

- **Authentication failures**: Ensure tokens have correct scopes and are not expired.
- **Manifest errors**: Ensure `docker buildx` is used for multi-arch builds.
- **HAOS pull errors**: Ensure GHCR package visibility is **Public** (Settings → Packages → `sdr-hub` → Visibility).
