# Repository instructions

- Keep diffs minimal and target Interface 16001.
- Feature-detect every optional Forever API; do not guess signatures or claim simulated behavior is client validation.
- This addon is read-only: no gameplay mutation, protected hooks, pin replacement, identity collection, networking, or full-frame/global dumps.
- Keep diagnostics bounded and serialization deterministic. Add tests for label normalization and serialization changes.
- Do not create commits or pull requests unless explicitly requested, except the initial repository creation authorized by the bootstrap request.
