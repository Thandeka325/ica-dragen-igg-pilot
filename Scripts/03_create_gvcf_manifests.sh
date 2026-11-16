
#!/usr/bin/env bash
set -euo pipefail

# Generate ICA gVCF manifests for batches 1-3.
# Run from the repository root.

outdir="metadata/batches"

for batch in 1 2 3; do
    samples="$outdir/batch-$batch.samples.txt"
    output="$outdir/batch-$batch.gvcfs.csv"

    [[ -f "$samples" ]] || {
        echo "Missing: $samples" >&2
        exit 1
    }

    case "$batch" in
        1) prefix="ica://gvcf-100-test/input/1K_GVCFs" ;;
        2) prefix="ica://gvcf-100-test/input/1k_GVCF_Batch2" ;;
        3) prefix="ica://gvcf-100-test/input/1k_GVCF_Batch3" ;;
    esac

    # One ICA URI per sample, no header.
    while IFS= read -r sample; do
        [[ -n "$sample" ]] || continue
        printf '%s/%s.hard-filtered.gvcf.gz\n' \
            "$prefix" "$sample"
    done < "$samples" > "$output"

    echo "Created $output"
done
